// In this file we only add the data definitions, consts and enums
package secp256k1

// Opaque context structure
Context :: struct {}

// Translated macros from C (secp256k1.h)
CONTEXT_VERIFY :: 0x0001
CONTEXT_SIGN   :: 0x0101
CONTEXT_NONE   :: 0x0201

SCHNORR_SIG_SIZE :: 64

KeyPair :: struct { data: [96]byte } // official size of the internal struct
PublicKey :: struct { data: [64]byte } // internal representation
