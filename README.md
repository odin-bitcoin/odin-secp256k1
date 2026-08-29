# odin-secp256k1

Odin bindings for [libsecp256k1](https://github.com/bitcoin-core/secp256k1). The project is intended to provide a foundation for Bitcoin development in Odin through an idiomatic interface over the upstream C library.

This is a work in progress.

## Requirements

- Odin
- Git
- CMake
- `make`
- A C compiler

The current build flow targets macOS and Linux. On Windows, use WSL until a native Windows toolchain is documented and tested.

## Build

The Makefile downloads the pinned `libsecp256k1` revision, builds only the required modules, and writes the static library to `lib/libsecp256k1.a`.

```sh
make
```

Run an example after building:

```sh
make example EXAMPLE=examples/start_context.odin
```

Other useful commands:

```sh
make test
make info
make clean
make distclean
```

## Project structure

```text
src/
  Public Odin API
  internal/core/        C FFI bindings and ABI-compatible types

examples/               API usage examples
lib/                    Generated libsecp256k1 static library
```

Code outside this repository should use the API in `src/`. Files under `src/internal/core/` mirror the upstream C headers and are implementation details.

## Usage

The examples import the public package and never call the C bindings directly:

```odin
import secp256k1 "path/to/odin-secp256k1/src"

ctx := secp256k1.create_context(
    secp256k1.CONTEXT_SIGN | secp256k1.CONTEXT_VERIFY,
)
defer secp256k1.destroy_context(ctx)
```

Adjust the import path to match your Odin collection or local dependency layout.

## License

MIT. See [LICENSE.md](LICENSE.md).
