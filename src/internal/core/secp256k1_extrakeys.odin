package core
foreign import secp256k1_lib "../../../lib/libsecp256k1.a"

// Here we define how Odin should call the C functions
@(default_calling_convention="c")
foreign secp256k1_lib {
  secp256k1_keypair_create :: proc(ctx: ^Context, keypair: ^KeyPair, seckey32: [^]byte) -> i32 ---

  secp256k1_keypair_xonly_pub :: proc(ctx: ^Context, pubkey: ^XOnlyPublicKey, pk_parity: ^i32, keypair: ^KeyPair) -> i32 ---

  // serializes an x-only pubkey to an array of bytes
  secp256k1_xonly_pubkey_serialize :: proc(ctx: ^Context, output32: [^]byte, pubkey: ^XOnlyPublicKey) -> i32 ---
}
