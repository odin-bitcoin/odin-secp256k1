// Example for generating a keypair
package main

import "core:fmt"
import "core:crypto" //to generate random numbers
import "../src/"

main :: proc() {
    // creates the context.
    ctx := src.secp256k1_context_create(src.CONTEXT_SIGN | src.CONTEXT_VERIFY)
    
    defer src.secp256k1_context_destroy(ctx)

    private_key := make([]byte, 32) // creates a 32 byte slice for the private key
    defer delete(private_key) //cleans the slice memory allocation
    crypto.rand_bytes(private_key) //generates random bytes and fills the slice
    
    keypair, ok := src.create_keypair(ctx, private_key)

    if ok {
      fmt.println("Yep, sucess, key pair created.")
      fmt.printf("Raw keypair data: %x\n", keypair.data)
    } else {
      fmt.println("Something went wrong.")
    }
}
