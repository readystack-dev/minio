# GENERATED L-009 hermetic build (--network=none, SBOM+SLSA-attestation-producing).
# Pinned bases from BASE_IMAGE_DIGESTS.lock; vendored Go tree + debs from Dockerfile.vendor.
FROM golang:1.26.11-bookworm@sha256:dc40a13b61304647ed7e5d581d246b86413dfc29d63c6d018310feb93cd98fc0 AS build_minio
WORKDIR /src
COPY vendored/minio-src/ .
ENV CGO_ENABLED=0 GOTOOLCHAIN=local GOWORK=off GOFLAGS="-mod=vendor -buildvcs=false" GOPROXY=off SOURCE_DATE_EPOCH=1795161125
RUN go build -trimpath -tags "kqueue" -ldflags='-s -w -X github.com/minio/minio/cmd.Version=2025-10-15T17-29-55Z -X github.com/minio/minio/cmd.ReleaseTag=RELEASE.2025-10-15T17-29-55Z -X github.com/minio/minio/cmd.CommitID=9e49d5e7a648f00e26f2246f4dc28e6b07f8c84a -X github.com/minio/minio/cmd.ShortCommitID=9e49d5e7a648 -X github.com/minio/minio/cmd.CopyrightYear=2025' -o /minio . && /minio --version && \
    { readelf -lW /minio | sed -n 's/.*Requesting program interpreter: \(.*\)]$/\1/p'; readelf -dW /minio | sed -n 's/.*Shared library: \[\(.*\)\]$/\1/p'; } > /minio.needs
# rs-probe: the HEALTHCHECK helper (standard library only, from the kit's rs-probe.go)
FROM golang:1.26.11-bookworm@sha256:dc40a13b61304647ed7e5d581d246b86413dfc29d63c6d018310feb93cd98fc0 AS build_rs_probe
WORKDIR /probe
COPY rs-probe.go main.go
COPY rs-probe.mod go.mod
ENV CGO_ENABLED=0 GOTOOLCHAIN=local GOFLAGS="-buildvcs=false" GOPROXY=off SOURCE_DATE_EPOCH=1795161125
RUN go build -trimpath -ldflags='-s -w' -o /rs-probe .
# the chiselled rootfs (vendored/chisel, cut by Dockerfile.vendor), the service user, the binaries
FROM ubuntu:24.04@sha256:9c7f200c07e3d4a03e7249d2c16bf66a51120fb876aa2242cf31451412543289 AS rootfs
ARG SOURCE_DATE_EPOCH=1795161125
ADD vendored/chisel/rootfs.tar /rootfs/
RUN printf 'minio:x:999:999::/data:/bin/sh\n' >> /rootfs/etc/passwd && printf 'minio:x:999:\n' >> /rootfs/etc/group && \
    mkdir -p /rootfs/data /rootfs/data/.minio.sys && chown -R 999:999 /rootfs/data /rootfs/data/.minio.sys
COPY --from=build_minio /minio /rootfs/usr/bin/minio
COPY --from=build_minio /minio.needs /tmp/needs/minio
COPY --from=build_rs_probe /rs-probe /rootfs/usr/local/bin/rs-probe
COPY readystack-entrypoint.sh /rootfs/usr/local/bin/readystack-entrypoint.sh
RUN chmod 755 /rootfs/usr/bin/minio /rootfs/usr/local/bin/rs-probe && \
    chown 999:999 /rootfs/usr/local/bin/readystack-entrypoint.sh && \
    chmod 0755 /rootfs/usr/local/bin/readystack-entrypoint.sh
RUN --mount=type=bind,source=vendored/chisel,target=/chisel set -eu; \
    for n in /tmp/needs/*; do while read -r lib; do [ -n "$lib" ] || continue; \
      case "$lib" in /*) [ -e "/rootfs$lib" ] ;; *) [ -n "$(find /rootfs/usr/lib /rootfs/usr/lib64 -name "$lib" 2>/dev/null | head -1)" ] ;; esac || \
      { echo "$(basename "$n") needs $lib, which the chiselled rootfs does not have: add its slice to runtime_base.slices" >&2; exit 1; }; \
    done < "$n"; done; rm -rf /tmp/needs; \
    [ -e /rootfs/etc/os-release ] || { echo "no /etc/os-release: base-files_release-info is missing" >&2; exit 1; }; \
    [ "$(grep -c '^Package: ' /rootfs/var/lib/dpkg/status)" = "$(wc -l < /chisel/packages.tsv)" ] || \
      { echo "/var/lib/dpkg/status does not list every package of vendored/chisel/packages.tsv" >&2; exit 1; }; \
    rm -rf /rootfs/var/log/dpkg.log /rootfs/var/log/alternatives.log /rootfs/var/log/apt /rootfs/var/cache/ldconfig/aux-cache /rootfs/var/cache/fontconfig
FROM scratch
ARG SOURCE_DATE_EPOCH=1795161125
COPY --from=rootfs /rootfs/ /
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
LABEL org.opencontainers.image.licenses="AGPL-3.0-or-later"
LABEL com.readystack.license.disclosure="This image includes MinIO (https://github.com/minio/minio), licensed under AGPL-3.0-or-later. Modifications: the build raises Go-module dependency versions in go.mod and go.sum to fixed, upstream-published releases (security updates; no MinIO source file is edited); full diff of every upstream file the build changes at https://readystack.dev/source/minio/RELEASE.2025-10-15T17-29-55Z/minio-RELEASE.2025-10-15T17-29-55Z-readystack.patch. Operating-system packages come from Ubuntu's archive, unmodified. ReadyStack license holders have access to the image build recipe and patched-package manifest on request via contact@readystack.dev."
LABEL org.opencontainers.image.title="MinIO"
LABEL org.opencontainers.image.source="https://github.com/minio/minio"
LABEL org.opencontainers.image.version="RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r13"
LABEL org.opencontainers.image.revision="9e49d5e7a648f00e26f2246f4dc28e6b07f8c84a"
HEALTHCHECK --interval=5s --timeout=30s --start-period=10s \
  CMD /usr/local/bin/rs-probe http://127.0.0.1:9000/minio/health/live || exit 1
USER minio
EXPOSE 9000 9001
ENTRYPOINT ["/usr/local/bin/readystack-entrypoint.sh"]
CMD ["server", "/data", "--address", ":9000", "--console-address", ":9001"]
