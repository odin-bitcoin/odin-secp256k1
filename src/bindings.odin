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

  // For schnorr specifically
  secp256k1_schnorrsig_sign32 :: proc(
    ctx: ^Context,
    sig64: [^]byte,
    msg32: [^]byte,
    keypair: ^byte, 
    aux_rand32: ^byte,
  ) -> i32 ---

  secp256k1_keypair_create :: proc(ctx: ^Context, keypair: ^KeyPair, seckey32: [^]byte) -> i32 ---
}
