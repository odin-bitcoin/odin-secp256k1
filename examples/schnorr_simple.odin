package main

import "core:fmt"
import "core:crypto"
import "../src/"

main :: proc() {
  ctx := src.secp256k1_context_create(src.CONTEXT_SIGN | src.CONTEXT_VERIFY)
  defer src.secp256k1_context_destroy(ctx)

  private_key := make([]byte, 32) // creates a 32 byte slice for the private key
  defer delete(private_key) //cleans the slice memory allocation
  crypto.rand_bytes(private_key) //generates random bytes and fills the slice

  kp: src.KeyPair
  if src.secp256k1_keypair_create(ctx, &kp, raw_data(private_key)) != 1 {
    fmt.println("Error: not able to create keypair.")
    return
  }

  pubkey, ok_pub := src.extract_xonly_pubkey(ctx, &kp)
  if !ok_pub {
    fmt.println("Error extracting pubkey!")
    return
  }

  // now we create a fake message do sign 
  msg_hash := [32]byte{
        0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08,
        0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08,
        0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08,
        0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08,
  }

  sig, ok_sign := src.sign_schnorr(ctx, msg_hash[:], &kp)
    
  if ok_sign {
    fmt.println("Signing successful!")
    fmt.printf("   [Hex]: %x\n", sig)
  } else {
    fmt.println("Error when signing!")
    return
  }
  
  is_valid := src.verify_schnorr(ctx, sig[:], msg_hash[:], &pubkey)
    
  if is_valid {
    fmt.println("Verification was successful, the signature belongs to that pubkey.")
  } else {
    fmt.println("Verification failed.")
  }
}
