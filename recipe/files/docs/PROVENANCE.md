# Provenance — MinIO (`RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r13`)

Every item below is copied from a record in this archive; the record is named in brackets.

## Source

- Upstream repository: https://github.com/minio/minio
- Revision built: `RELEASE.2025-10-15T17-29-55Z` (commit `9e49d5e7a648f00e26f2246f4dc28e6b07f8c84a`)
- Source tree: `2349200805cf08e1931ad35d051a378bf2839a098d6e0616ec72c6e85c0e6fb2` over 1363 files [`docs/provenance/SOURCE_TREE_HASH.json`]
- Community Edition only: enterprise code is removed or refused before the build (CE audit at acquire).

## Build

- Method: `source-rebuild-go`; base image `scratch + a chiselled Ubuntu 24.04 runtime (vendored/chisel/slices.txt, packages.tsv)`
- Compiled with `--network=none` from vendored source, dependencies and base images; BuildKit pinned to `moby/buildkit:v0.31.2` (shipped in `toolchain/`).
- Not compiled here, shipped as upstream's prebuilt files: the web Console's compiled React frontend is the prebuilt bundle that ships inside the github.com/minio/console Go module (//go:embed build/*), vendored with the Go dependencies; it is not built here
- SOURCE_DATE_EPOCH: `1795161125` [`SOURCE_DATE_EPOCH.txt`]
- Frozen inputs: [`docs/provenance/FREEZE_MANIFEST.json`], build recipe: [`docs/provenance/BUILD_RECIPE.json`].

## Output

- Published image: `readystack/minio:RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r13` — index digest `sha256:468eb3ebc673a8f3586c1dfdfd7cdfa2f3e8395a5ac5440c11b80183b60192ee` [`docs/provenance/LOCKED_DIGEST.txt`]
- linux/amd64 image digest `sha256:b8f540021c62e0e113afce0aa0f180b8a82e7209ed0f2a03b350748729bb8311` — reproduced from this archive before publishing [`docs/provenance/REPRO_VERIFICATION.json`].

## Attestations and signature

- SBOM + SLSA provenance attached to the image: attached: an SPDX SBOM and SLSA v1 provenance [`docs/provenance/SCOUT_VERDICT.json`]
- cosign signature by the ReadyStack release key: verified before publishing. Check it: `cosign verify --key https://readystack.dev/keys/cosign.pub readystack/minio:RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r13`

## Pinned inputs, and why

- 60 pinned inputs, each with where it came from, why this one, how it was checked and when it was decided: `docs/PINS.md` [`docs/provenance/PINS.json`] (upstream source 2, base and build images 3, image digests 2, dependency versions readystack sets 23, pins in the kit's dockerfiles 23, readystack's build engine 5, dependencies upstream chose 2).

## Build trail

- How this release passed through the ReadyStack harness, record by record (every chain, drive, stage, review round, defect and check, each naming the record it is copied from): `ReadyStack-minio-RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r13.trail.json`, published beside this archive and signed with the release key (`ReadyStack-minio-RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r13.trail.json.sigstore`), and readable at https://readystack.dev/products/minio/trail/RELEASE.2025-10-15T17-29-55Z-CE-ubuntu24.04-r13.

