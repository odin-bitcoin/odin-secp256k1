#!/bin/bash

mkdir -p lib

git clone https://github.com/bitcoin-core/secp256k1.git
cd secp256k1

./autogen.sh
./configure --enable-module-schnorrsig --enable-module-extrakeys
make

cp .libs/libsecp256k1.a ../lib/

cd ..
rm -rf secp256k1

echo "Build done! libsecp256k1.a was generated and is now in /lib. The temporary files were deleted."
