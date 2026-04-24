## To be functional (minimally) we need to expose:

- context: secp256k1_context_create => initiate pre-computation tables
- keys: secp256k1_ec_pubkey_create => derive public key from private key
- signing: secp256k1_ecdsa_sign => sign with the key
- verification: secp256k1_ecdsa_verify => verify a signature
- serialization: secp256k1_ec_pubkey_serialize => convert the key to sending format (33 or 65 bytes)
