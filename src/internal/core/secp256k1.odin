package core
foreign import secp256k1_lib "../../../lib/libsecp256k1.a"

// Here we define how Odin should call the C functions
@(default_calling_convention="c")
foreign secp256k1_lib {
  secp256k1_context_create :: proc(flags: u32) -> ^Context ---
  secp256k1_context_destroy :: proc(ctx: ^Context) ---
}
