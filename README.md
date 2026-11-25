# MinIO: ReadyStack build kit

The offline build kit for the Docker image `readystack/minio:RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r13`. It holds what the image is built from (upstream source, base images, toolchain, pinned dependencies) and the documents, so the image can be rebuilt with no network access (`docker build --network=none`).

- Release: [RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r13](https://github.com/readystack-dev/minio/releases/tag/RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r13)
- Image: [`docker.io/readystack/minio:RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r13`](https://hub.docker.com/r/readystack/minio/tags), manifest digest `sha256:b8f540021c62e0e113afce0aa0f180b8a82e7209ed0f2a03b350748729bb8311`
- Product page: https://readystack.dev/products/minio
- Defects: this repository's Issues (defects recorded from 25 November 2026 on) and https://readystack.dev/defects.html?product=minio

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
