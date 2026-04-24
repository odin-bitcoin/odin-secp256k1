// Simple example for initializing the secp256k1 context
package main

import "core:fmt"
import "../src/"

main :: proc() {
    // creates the context.
    ctx := src.secp256k1_context_create(src.CONTEXT_SIGN | src.CONTEXT_VERIFY)
    
    defer src.secp256k1_context_destroy(ctx)
 
    if ctx != nil {
      fmt.println("The secp256k1 context was created.")
    } else {
      fmt.println("Something went wrong.")
    }
}
