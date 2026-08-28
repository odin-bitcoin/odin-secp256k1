// Simple example for initializing the secp256k1 context
package main

import "core:fmt"
import "../src/"

main :: proc() {
    // creates the context.
    ctx := src.create_context(src.CONTEXT_SIGN | src.CONTEXT_VERIFY)
    
    defer src.destroy_context(ctx)
 
    if ctx != nil {
      fmt.println("The secp256k1 context was created.")
    } else {
      fmt.println("Something went wrong.")
    }
}
