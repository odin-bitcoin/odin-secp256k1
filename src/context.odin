package secp256k1
import core "./internal/core/"

create_context :: proc(flags: u32) -> ^Context {
  return core.secp256k1_context_create(flags)
}

destroy_context :: proc(ctx: ^Context) {
  if ctx != nil {
    core.secp256k1_context_destroy(ctx)
  }
}

