package secp256k1

import "core:crypto"

// extract the XOnlyPublicKey (64 bytes) from KeyPair
extract_xonly_pubkey :: proc(ctx: ^Context, kp: ^KeyPair) -> (XOnlyPublicKey, bool) {
    pubkey: XOnlyPublicKey
    parity: i32
    
    result := secp256k1_keypair_xonly_pub(ctx, &pubkey, &parity, kp)
    
    return pubkey, result == 1
}

sign_schnorr :: proc(ctx: ^Context, msg_hash: []byte, kp: ^KeyPair) -> ([64]byte, bool) {
  sig: [64]byte

  if len(msg_hash) != 32 {
    return sig, false // schnorr needs hashes of exact 32 bytes long
  }

  // bip340 recomends to add 32 bytes of entropy to aux the signing
  aux_rand: [32]byte
  crypto.rand_bytes(aux_rand[:])

  result := secp256k1_schnorrsig_sign32(
    ctx,
    raw_data(sig[:]),
    raw_data(msg_hash),
    kp,
    raw_data(aux_rand[:]),
  )

  return sig, result == 1
}

verify_schnorr :: proc(ctx: ^Context, sig: []byte, msg_hash: []byte, pubkey: ^XOnlyPublicKey) -> bool {
  if len(sig) != 64 || len(msg_hash) != 32 {
    return false //Need to treat better this error latter
  }

  result := secp256k1_schnorrsig_verify(
    ctx,
    raw_data(sig),
    raw_data(msg_hash),
    len(msg_hash),
    pubkey,
  )

  return result == 1
}
