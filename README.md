# odin-secp256k1

Odin bindings for the secp256k1 library, optimized for Bitcoin. This project provides a thin, idiomatic wrapper around the C library to enable secure elliptic curve operations within the Odin ecosystem.

## Overview

The secp256k1 curve is the standard for Bitcoin. This library allows Odin developers to perform operations such as context management, keypair generation, and Schnorr signatures (WIP) with native performance and improved type safety.

## Advantages of Using Odin

Choosing Odin for cryptographic implementations provides several benefits over traditional C or other modern languages:

1. Type Safety: Odin's strong typing system prevents many common errors found in C, such as implicit pointer conversions and ambiguous memory layouts.
2. Controlled Memory Management: Explicit allocation and the 'defer' keyword ensure that sensitive cryptographic data is properly handled and cleared.
3. C Interoperability: Odin's foreign import system allows for seamless integration with high-performance C libraries like libsecp256k1 without overhead.
4. Readable Syntax: The language offers a modern, clean syntax that remains close to the hardware while providing high-level constructs for better maintainability.
5. Performance: As a compiled language, Odin provides the performance necessary for heavy cryptographic computations.

## Features

- Context Creation and Destruction: Safe management of the secp256k1 execution context.
- Keypair Generation: Utility functions to create internal keypair representations from private keys.
- Schnorr Signatures: Support for the Schnorr signature scheme as defined in BIP340.
- Wrapper Functions: High-level Odin procedures that wrap raw C calls for better ergonomics and safety checks.

## Project Structure

- src/: Core bindings and wrapper implementations.
- lib/: Contains the static library (libsecp256k1.a).
- examples/: Practical demonstrations of how to use the library.
- build_secp256k1.sh: Script for building the underlying C library.

## Getting Started

To use this library in your Odin project, ensure you have the compiled static library in the lib directory.

```odin
package main

import "core:fmt"
import "core:crypto"
import "src"

main :: proc() {
    // Create the context
    ctx := src.create_context(src.CONTEXT_SIGN | src.CONTEXT_VERIFY)
    defer src.destroy_context(ctx)

    // Generate a private key
    private_key := make([]byte, 32)
    defer delete(private_key)
    crypto.rand_bytes(private_key)
    
    // Create a keypair
    keypair, ok := src.create_keypair(ctx, private_key)

    if ok {
        fmt.println("Success: Keypair created.")
        fmt.printf("Internal data: %x\n", keypair.data)
    } else {
        fmt.println("Error: Failed to create keypair.")
    }
}
```

## License

This project is licensed under the MIT License. See the LICENSE.md file for details.
