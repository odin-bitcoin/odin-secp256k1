package secp256k1
import core "./internal/core/"

create_keypair :: proc(ctx: ^Context, seckey: []byte) -> (KeyPair, bool) {
  // safety validation that C does not do natively
  if len(seckey) != 32 {
    return KeyPair{}, false
  }

  kp: KeyPair

  // raw_data(seckey) takes the [^]byte inside the slice to make C happy in the underneath secp lib
  // returns 1 if successful or 0 if failure
  result := core.secp256k1_keypair_create(ctx, &kp, raw_data(seckey))

  return kp, result == 1
}

// extract the XOnlyPublicKey (64 bytes) from KeyPair
extract_xonly_pubkey :: proc(ctx: ^Context, kp: ^KeyPair) -> (XOnlyPublicKey, bool) {
    pubkey: XOnlyPublicKey
    parity: i32
    
    result := core.secp256k1_keypair_xonly_pub(ctx, &pubkey, &parity, kp)
    
    return pubkey, result == 1
}

