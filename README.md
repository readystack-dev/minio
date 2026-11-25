# MinIO: ReadyStack build kit

The offline build kit for the Docker image `readystack/minio:RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r13`. It holds what the image is built from (upstream source, base images, toolchain, pinned dependencies) and the documents, so the image can be rebuilt with no network access (`docker build --network=none`).

- Release: [RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r13](https://github.com/readystack-dev/minio/releases/tag/RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r13)
- Image: [`docker.io/readystack/minio:RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r13`](https://hub.docker.com/r/readystack/minio/tags), manifest digest `sha256:b8f540021c62e0e113afce0aa0f180b8a82e7209ed0f2a03b350748729bb8311`
- Product page: https://readystack.dev/products/minio
- Source and build recipe: https://readystack.dev/products/minio/recipe
- Build trail: https://readystack.dev/products/minio/trail/RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r13
- Defects: this repository's Issues (defects recorded from 25 November 2026 on) and https://readystack.dev/defects.html?product=minio

## The image

Single container, single static Go binary (CGO-free), foreground process. S3-compatible OBJECT STORAGE: objects + metadata persisted on the local filesystem under /data (internal state under /data/.minio.sys). NO relational/SQL database. Embeds and serves a web Console (an object browser) on port 9001. The image IS the complete running instance (no docker-compose, no Kubernetes, no external DB). The entrypoint, /usr/local/bin/readystack-entrypoint.sh, works out the root password MinIO will use (from MINIO_ROOT_PASSWORD, a MINIO_ROOT_PASSWORD_FILE secret or MINIO_CONFIG_ENV_FILE), exits 1 if it is unset, blank or minioadmin (and also on other unusable credential input, for example a root user or password that starts with "env", a `*_FILE` secret or MINIO_CONFIG_ENV_FILE naming a missing or unreadable file, or an empty `*_FILE` secret), and then runs `minio` with the default arguments `server /data --address :9000 --console-address :9001`, which arguments after the image name replace.

## Who uses MinIO and why

Teams who need object storage on their own hardware for backups, analytics data and application files.

MinIO is open-source object storage compatible with an established cloud object-storage API, so existing tools and applications written for that API can store data on your own servers.

A typical use: A team's backup software and data pipelines are written for cloud object storage, but the data must stay on site. They point those tools at MinIO on their own servers and keep their backups and datasets in buckets there.

From the upstream project's own description: https://github.com/minio/minio.

## This release

- Docker Scout policy grade at release: **A** (94%), graded 2026-11-22 with `docker scout policy` (CLI 1.26.0, docker-default configuration).
  - Docker Scout counts 15 packages with copyleft licences (GPL, LGPL, MPL), all of them operating-system packages (it counts only packages whose licence it can read; the SBOM lists every component).
- Signed with ReadyStack's release key (fingerprint `04daa92344a52dbc`): https://readystack.dev/keys/cosign.pub.
- Runs as a non-root user (`minio`).
- Attestations on the image: an SPDX SBOM and SLSA provenance v1.
- Rebuilt from this kit with network egress blocked on 2026-11-22; the rebuilt image digest is the published one.
- Base: Ubuntu 24.04.

The current grade, measured again every day, is on https://readystack.dev/products/minio.

MinIO is distributed under its upstream licence (AGPL-3.0-or-later); the kit contains upstream's source under that licence, and each vendored component under its own.

## Download

From the [RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r13 release](https://github.com/readystack-dev/minio/releases/tag/RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r13): `ReadyStack-minio-RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r13.tar.gz` (504.6 MB), SHA-256 `52e8c8cd02548b428050a504409aaef7b7e7de3ce7a5b06d45e0b7cbabf4a346`.

```sh
sha256sum --check --ignore-missing SHA256SUMS
```

## Verify and rebuild

The rebuild statement is signed with the ReadyStack release key. Check the signature before you rely on it:

```sh
cosign verify-blob --key https://readystack.dev/keys/cosign.pub \
  --bundle ReadyStack-minio-RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r13.rebuild.json.sigstore ReadyStack-minio-RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r13.rebuild.json
```

Unpack with `-p` so file modes are kept, then follow the kit's own README.md and docs/REBUILD.md:

```sh
tar -xpzf ReadyStack-minio-RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r13.tar.gz
cd RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r13
less README.md docs/REBUILD.md
```

The build trail (`ReadyStack-minio-RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r13.trail.json`, signed the same way, and its Markdown copy) records how this release was built and checked.

## This repository

`recipe/` holds the kit's recipe files (Dockerfiles, build scripts, pins) as published at https://readystack.dev/products/minio/recipe. The complete kit is the release download. Each release is a tag here.

— ReadyStack · https://readystack.dev
