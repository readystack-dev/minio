#!/bin/sh
# ReadyStack MinIO entrypoint (RELEASE.2025-10-15T17-29-55Z). MinIO falls back to its public default
# credentials minioadmin/minioadmin when it finds no root credentials, and it silently ignores a *_FILE
# or MINIO_CONFIG_ENV_FILE that names a missing file (cmd/common-main.go: loadEnvVarsFromFiles,
# readFromSecret, parsEnvEntry, loadRootCredentials). So this works out the root password the way MinIO
# will - same variables, same order, same /run/secrets lookup, quote and whitespace handling - and exits
# 1 with a `readystack:` message unless it is set and is not minioadmin in any letter case. Order:
#   1. MINIO_ROOT_USER, MINIO_ROOT_PASSWORD
#   2. MINIO_ACCESS_KEY_FILE, MINIO_SECRET_KEY_FILE, MINIO_ROOT_USER_FILE, MINIO_ROOT_PASSWORD_FILE, each
#      read from /run/secrets/<value> if that file exists, else from <value>; a non-empty file overrides
#   3. MINIO_CONFIG_ENV_FILE's KEY=value lines (blank, # and `export` handled as MinIO does); last wins
# Every *_FILE and MINIO_CONFIG_ENV_FILE that is set must name a readable file, and a *_FILE must not be
# empty (MinIO would ignore it without a word). A value starting with "env" is refused: MinIO reads it
# as a remote env:// lookup address, not a value. MinIO never defaults the user alone: given a password
# and no user it exits naming MINIO_ROOT_USER. Arguments after the image name replace the default
# `server /data --address :9000 --console-address :9001`; a leading `minio` is accepted.
set -e
rs_die() { echo "readystack: $*" >&2; exit 1; }
# Go's strings.TrimSpace: ASCII and Unicode White_Space (UTF-8 bytes) at both ends.
rs_ws='\([\t\n\v\f\r ]\|\xc2[\x85\xa0]\|\xe1\x9a\x80\|\xe2\x80[\x80-\x8a\xa8\xa9\xaf]\|\xe2\x81\x9f\|\xe3\x80\x80\)'
rs_trim() { printf '%s' "$1" | LC_ALL=C sed -z "s/^$rs_ws*//;s/$rs_ws*\$//" | tr -d '\000'; }
rs_weak() {  # $1 = where the password came from, $2 = the password as MinIO will hold it
  [ "$(rs_trim "$2" | tr 'A-Z' 'a-z')" = minioadmin ] || return 0
  if [ "$1" = MINIO_ROOT_PASSWORD ] && [ "$2" = minioadmin ]; then
    rs_die "MINIO_ROOT_PASSWORD=minioadmin is MinIO's public default; choose another password."
  fi
  rs_die "the root password from $1 is minioadmin (letter case and surrounding whitespace ignored), MinIO's public default; choose another password."
}
rs_readable() {  # $1 = variable, $2 = its value, $3 = the file MinIO would read, $4 = where it looked
  [ -e "$3" ] || rs_die "$1=$2: no such file$4. MinIO would ignore the variable without a word; mount the file or unset the variable."
  [ -f "$3" ] || rs_die "$1=$2: $3 is not a regular file."
  [ -r "$3" ] || rs_die "$1=$2: $3 exists but user $(id -un) (uid $(id -u)) cannot read it; make it readable by uid $(id -u) (for example chown $(id -u) on the host file)."
  [ "$(wc -c <"$3")" = "$(tr -d '\000' <"$3" | wc -c)" ] || rs_die "$1=$2: $3 contains a NUL byte, which MinIO cannot put in its environment, so it would ignore it."
}
rs_secret() {  # $1 = a *_FILE variable; sets rs_val to the trimmed contents (empty if unset), rs_src
  eval "rs_raw=\${$1-}"
  rs_val= rs_src=
  case $rs_raw in env*) rs_die "$1 starts with \"env\", which MinIO reads as a remote env:// lookup and would ignore; give the file's path, such as /run/secrets/<name>." ;; esac
  rs_sp=$(rs_trim "$rs_raw")
  [ -n "$rs_sp" ] || return 0
  case /$rs_sp/ in */../*) rs_die "$1=$rs_raw: give a path without \"..\"." ;; esac
  rs_f=$rs_sp
  if [ -f "/run/secrets/$rs_sp" ]; then rs_f=/run/secrets/$rs_sp; fi
  rs_hint=
  case $rs_sp in /*) ;; *) rs_d=$(pwd); [ "$rs_d" != / ] || rs_d=; rs_hint=" (looked for /run/secrets/$rs_sp and $rs_d/$rs_sp)" ;; esac
  rs_readable "$1" "$rs_raw" "$rs_f" "$rs_hint"
  rs_val=$(LC_ALL=C sed -z "s/^$rs_ws*//;s/$rs_ws*\$//" "$rs_f" | tr -d '\000')
  [ -n "$rs_val" ] || rs_die "$1=$rs_raw: $rs_f is empty or only whitespace, so MinIO would ignore it."
  rs_src="$1 ($rs_f)"
}
rs_envline() {  # last "$1=" line of the env file as MinIO parses it, printed as "=value"; empty if none
  LC_ALL=C sed -n "s/^$rs_ws*//;s/$rs_ws*\$//;/^#/d;s/^export//;s/^$rs_ws*//;s/^$1=/=/p" "$rs_ef" | tail -n 1
}
rs_unquote() { case $1 in \"*\"|\'*\') rs_q=${1#?}; printf '%s' "${rs_q%?}" ;; *) printf '%s' "$1" ;; esac; }

rs_u=${MINIO_ROOT_USER-} rs_us=MINIO_ROOT_USER
rs_p=${MINIO_ROOT_PASSWORD-} rs_ps=MINIO_ROOT_PASSWORD
rs_weak "$rs_ps" "$rs_p"
for rs_v in MINIO_ACCESS_KEY_FILE MINIO_SECRET_KEY_FILE MINIO_ROOT_USER_FILE MINIO_ROOT_PASSWORD_FILE; do
  rs_secret "$rs_v"
  [ -n "$rs_val" ] || continue
  case $rs_v in
    *USER*|*ACCESS*) rs_u=$rs_val rs_us=$rs_src ;;
    *) rs_weak "$rs_src" "$rs_val"; rs_p=$rs_val rs_ps=$rs_src ;;
  esac
done
rs_raw=${MINIO_CONFIG_ENV_FILE-}
case $rs_raw in env*) rs_die "MINIO_CONFIG_ENV_FILE starts with \"env\", which MinIO reads as a remote env:// lookup and would ignore; give the file's path." ;; esac
rs_ef=$(rs_trim "$rs_raw")
if [ -n "$rs_ef" ]; then
  case /$rs_ef/ in */../*) rs_die "MINIO_CONFIG_ENV_FILE=$rs_raw: give a path without \"..\"." ;; esac
  rs_readable MINIO_CONFIG_ENV_FILE "$rs_raw" "$rs_ef" ""
  rs_l=$(rs_envline MINIO_ROOT_USER)
  if [ -n "$rs_l" ]; then rs_u=$(rs_unquote "${rs_l#=}") rs_us="MINIO_CONFIG_ENV_FILE ($rs_ef)"; fi
  rs_l=$(rs_envline MINIO_ROOT_PASSWORD)
  if [ -n "$rs_l" ]; then
    rs_p=$(rs_unquote "${rs_l#=}") rs_ps="MINIO_CONFIG_ENV_FILE ($rs_ef)"
    rs_weak "$rs_ps" "$rs_p"
  fi
fi
case $rs_p in env*) rs_die "the root password from $rs_ps starts with \"env\", which MinIO reads as a remote env:// lookup address instead of a password, so it would treat the password as unset; choose a password that does not start with \"env\"." ;; esac
case $rs_u in env*) rs_die "the root user from $rs_us starts with \"env\", which MinIO reads as a remote env:// lookup address instead of a user name; choose a user name that does not start with \"env\"." ;; esac
if [ -z "$(rs_trim "$rs_p")" ]; then
  if [ -n "$rs_p" ] || [ "$rs_ps" != MINIO_ROOT_PASSWORD ]; then
    rs_die "the root password from $rs_ps is empty or only whitespace, which MinIO treats as no password; set a real one."
  fi
  if [ -n "$rs_ef" ]; then
    rs_die "MINIO_CONFIG_ENV_FILE=$rs_raw has no MINIO_ROOT_PASSWORD line, and neither MINIO_ROOT_PASSWORD nor MINIO_ROOT_PASSWORD_FILE is set. Without a root password MinIO would start with its public default credentials minioadmin/minioadmin."
  fi
  rs_die "set MINIO_ROOT_USER and MINIO_ROOT_PASSWORD (at least 3 and 8 characters). Without them MinIO would start with its public default credentials minioadmin/minioadmin."
fi
[ "${1:-}" = "minio" ] && shift
exec minio "$@"
