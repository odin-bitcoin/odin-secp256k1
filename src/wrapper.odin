// In this file we add a wrapper around our bindings so that we make it easier to the user
package secp256k1

create_context :: proc(flags: u32) -> ^Context {
  return secp256k1_context_create(flags)
}

destroy_context :: proc(ctx: ^Context) {
  if ctx != nil {
    secp256k1_context_destroy(ctx)
  }
}

create_keypair :: proc(ctx: ^Context, seckey: []byte) -> (KeyPair, bool) {
  // safety validation that C does not do natively
  if len(seckey) != 32 {
    return KeyPair{}, false
  }

  kp: KeyPair

  // raw_data(seckey) takes the [^]byte inside the slice to make C happy in the underneath secp lib
  // returns 1 if successful or 0 if failure
  result := secp256k1_keypair_create(ctx, &kp, raw_data(seckey))

  return kp, result == 1
}
