// Example for generating a keypair
package main

import "core:fmt"
import "core:crypto" //to generate random numbers
import src "../src/"

main :: proc() {
    // creates the context.
    ctx := src.create_context(src.CONTEXT_SIGN | src.CONTEXT_VERIFY)
    
    defer src.destroy_context(ctx)

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
