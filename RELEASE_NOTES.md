# MinIO RELEASE.2025-10-15T17-29-55Z — ReadyStack release `RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r13`

Generated 2026-11-22 from this release's build records and strategy. Statements that come from a single record name it in brackets; the others come from this release's strategy and build log.

## Release

- **Image:** `readystack/minio:RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r13` (linux/amd64). Index digest `sha256:468eb3ebc673a8f3586c1dfdfd7cdfa2f3e8395a5ac5440c11b80183b60192ee` [`docs/provenance/LOCKED_DIGEST.txt`].
- **Image manifest digest:** `sha256:b8f540021c62e0e113afce0aa0f180b8a82e7209ed0f2a03b350748729bb8311` [`TARGET_DIGEST.txt`].
- **Upstream:** MinIO RELEASE.2025-10-15T17-29-55Z built from source at `RELEASE.2025-10-15T17-29-55Z` of https://github.com/minio/minio (the web Console's compiled React frontend is the prebuilt bundle that ships inside the github.com/minio/console Go module (//go:embed build/*), vendored with the Go dependencies; it is not built here) — upstream notes: https://github.com/minio/minio/releases/tag/RELEASE.2025-10-15T17-29-55Z [`docs/provenance/BUILD_RECIPE.json`].
- **Base image:** none (`FROM scratch`): a chiselled Ubuntu 24.04 runtime, the files Canonical's chisel cut from Ubuntu's own packages (`vendored/chisel/slices.txt`, `vendored/chisel/packages.tsv`); runtime user `minio`.
- **Build:** `source-rebuild-go`, compiled offline with `--network=none`.
- **Supersedes:** ReadyStack release `RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r12`.

## What changed in this release

- Upstream version unchanged (RELEASE.2025-10-15T17-29-55Z); ReadyStack rebuild.
- Minimum dependency versions ReadyStack enforces on top of upstream (raised only where upstream's own version was lower); shipped versions from the SBOM [`docs/sbom/SBOM.json`]:
  - `golang.org/x/crypto` raised from upstream's `v0.37.0` to at least `v0.56.0` (shipped: `v0.58.0`)
  - `golang.org/x/net` raised from upstream's `v0.39.0` to at least `v0.62.0` (shipped: `v0.62.0`)
  - `golang.org/x/text` raised from upstream's `v0.24.0` to at least `v0.41.0` (shipped: `v0.43.0`)
  - `golang.org/x/sys` raised from upstream's `v0.32.0` to at least `v0.47.0` (shipped: `v0.49.0`)
  - `golang.org/x/oauth2` raised from upstream's `v0.29.0` to at least `v0.36.0` (shipped: `v0.36.0`)
  - `google.golang.org/grpc` raised from upstream's `v1.72.0` to at least `v1.83.2` (shipped: `v1.83.2`)
  - `go.opentelemetry.io/otel` raised from upstream's `v1.35.0` to at least `v1.43.0` (shipped: `v1.44.0`)
  - `go.opentelemetry.io/otel/sdk` raised from upstream's `v1.35.0` to at least `v1.43.0` (shipped: `v1.44.0`)
  - `github.com/prometheus/prometheus` raised from upstream's `v0.303.0` to at least `v0.311.3` (shipped: `v0.311.3`)
  - `github.com/go-jose/go-jose/v4` raised from upstream's `v4.1.0` to at least `v4.1.6` (shipped: `v4.1.6`)
  - `github.com/buger/jsonparser` raised from upstream's `v1.1.1` to at least `v1.1.2` (shipped: `v1.1.2`)
  - `github.com/apache/thrift` raised from upstream's `v0.21.0` to at least `v0.25.0` (shipped: `v0.25.0`)
  - `github.com/rabbitmq/amqp091-go` raised from upstream's `v1.10.0` to at least `v1.13.0` (shipped: `v1.13.0`)
  - `go.etcd.io/etcd/api/v3` raised from upstream's `v3.5.21` to at least `v3.5.33` (shipped: `v3.5.33`)
  - `go.etcd.io/etcd/client/v3` raised from upstream's `v3.5.21` to at least `v3.5.33` (shipped: `v3.5.33`)
  - `go.etcd.io/etcd/client/pkg/v3` raised from upstream's `v3.5.21` to at least `v3.5.33` (shipped: `v3.5.33`)
  - `github.com/klauspost/compress` raised from upstream's `v1.18.0` to at least `v1.20.2` (shipped: `v1.20.2`)
- MinIO RELEASE.2025-10-15T17-29-55Z is unchanged from the release this supersedes (RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r12); this release rebuilds it. Changes: the image is rebuilt on the current ubuntu:24.04 image (sha256:9c7f200c07e3…), which its maintainers updated after RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r12 was built on sha256:2198e4c65076…. Settings, ports and data volumes are those of RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r12: replace the container with this image on the same volumes.

## Security status at release (measured 2026-11-20)

- **Docker Scout:** 0 fixable critical/high vulnerabilities; runs as `minio` (non-root); SBOM + provenance attestations present (SPDX SBOM + SLSA v1) [`docs/provenance/SCOUT_VERDICT.json`].
- **OSV cross-check:** no fixable critical/high vulnerability beyond Docker Scout's findings.
- **Signature:** cosign signature verified by ReadyStack's release gate before publishing; check it yourself with `cosign verify --key https://readystack.dev/keys/cosign.pub readystack/minio:RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r13` (signatures are recorded in the public Sigstore transparency log).
- **ReadyStack release check at release:** passed (ReadyStack's own test, not a Docker Scout grade). Vulnerabilities are disclosed every day and the image never changes, so it is re-checked daily, beside Docker Scout's own dated grade, at https://readystack.dev/queue.

## Reproducibility

Rebuilds offline from this archive to the identical image digest `sha256:b8f540021c62e0e113afce0aa0f180b8a82e7209ed0f2a03b350748729bb8311`: run `./BUILD_OFFLINE.sh`, then `./VERIFY_OFFLINE.sh` (add `--online` to confirm the Docker Hub tag holds the same digest). Before publishing, ReadyStack rebuilt the kit with `./BUILD_OFFLINE.sh` and compared the result with the published digest [`docs/provenance/REPRO_VERIFICATION.json`], then ran `./BUILD_OFFLINE.sh` and `./VERIFY_OFFLINE.sh` from this archive (without `--online`).

## Validation

- 7 of 7 use cases passed (7 authored) against the running image [`docs/validation/test-results.json`].

## Known issues

- None recorded.

## Defects fixed

- 20 problems found before release and fixed before it shipped (20 by review); each is listed in `docs/defects/defects.json`.

## Verify this archive

```
sha256sum -c CHECKSUMS.sha256
./BUILD_OFFLINE.sh && ./VERIFY_OFFLINE.sh --online
cosign verify --key https://readystack.dev/keys/cosign.pub readystack/minio:RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r13
```

ReadyStack records every signature in the public Sigstore transparency log (Rekor), so the command needs no extra flags.

