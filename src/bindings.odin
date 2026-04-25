// In this file we only add the interface for the exterior (C), we do not redeclare the consts here
package secp256k1

// Detects the OS and then
// links with the compiled lib
when ODIN_OS == .Darwin {
    foreign import lib "../lib/libsecp256k1.a"
} else when ODIN_OS == .Linux {
    foreign import lib "../lib/libsecp256k1.a"
}

// Here we define how Odin should call the C functions
@(default_calling_convention="c")
foreign lib {
  secp256k1_context_create :: proc(flags: u32) -> ^Context ---
  secp256k1_context_destroy :: proc(ctx: ^Context) ---
 
  secp256k1_keypair_create :: proc(ctx: ^Context, keypair: ^KeyPair, seckey32: [^]byte) -> i32 ---

  secp256k1_keypair_xonly_pub :: proc(ctx: ^Context, pubkey: ^XOnlyPublicKey, pk_parity: ^i32, keypair: ^KeyPair) -> i32 ---

  // serializes an x-only pubkey to an array of bytes
  secp256k1_xonly_pubkey_serialize :: proc(ctx: ^Context, output32: [^]byte, pubkey: ^XOnlyPublicKey) -> i32 ---
  
  // schnorr signature => msg32 is the hash of the message and aux_rand32 is extra entropy for safety (bip340)
  secp256k1_schnorrsig_sign32 :: proc(ctx: ^Context, sig64: [^]byte, msg32: [^]byte, keypair: ^KeyPair, aux_rand32: [^]byte) -> i32 ---

  // shcnorr verification
  secp256k1_schnorrsig_verify :: proc(ctx: ^Context, sig64: [^]byte, msg32: [^]byte, msglen: uint, pubkey: ^XOnlyPublicKey) -> i32 ---
}
