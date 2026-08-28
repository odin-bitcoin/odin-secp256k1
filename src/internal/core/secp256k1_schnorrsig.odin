package core
foreign import secp256k1_lib "../../../lib/libsecp256k1.a"

// Here we define how Odin should call the C functions
@(default_calling_convention="c")
foreign secp256k1_lib {  
  // schnorr signature => msg32 is the hash of the message and aux_rand32 is extra entropy for safety (bip340)
  secp256k1_schnorrsig_sign32 :: proc(ctx: ^Context, sig64: [^]byte, msg32: [^]byte, keypair: ^KeyPair, aux_rand32: [^]byte) -> i32 ---

  // shcnorr verification
  secp256k1_schnorrsig_verify :: proc(ctx: ^Context, sig64: [^]byte, msg32: [^]byte, msglen: uint, pubkey: ^XOnlyPublicKey) -> i32 ---
}
