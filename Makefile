# odin-secp256k1 Makefile
#
# Builds a pinned static libsecp256k1 for the Odin bindings.
# Pinned upstream release:
#   tag:    v0.8.0
#   commit: 6e2c8bc
#
# Requirements:
#   git, cmake, C compiler
#
# Typical usage:
#   make
#   make example EXAMPLE=examples/start_context.odin
#   make clean
#   make distclean

.DEFAULT_GOAL := all
.DELETE_ON_ERROR:

SECP_REPO       := https://github.com/bitcoin-core/secp256k1.git
SECP_TAG        := v0.8.0
SECP_COMMIT     := 6e2c8bc

DEPS_DIR        := .deps
SECP_SOURCE_DIR := $(DEPS_DIR)/secp256k1

BUILD_DIR       := build
SECP_BUILD_DIR  := $(BUILD_DIR)/secp256k1

LIB_DIR         := lib
SECP_LIB        := $(LIB_DIR)/libsecp256k1.a

ODIN            ?= odin
EXAMPLE         ?=

CMAKE_FLAGS := \
	-DCMAKE_BUILD_TYPE=Release \
	-DBUILD_SHARED_LIBS=OFF \
	-DSECP256K1_INSTALL=OFF \
	-DSECP256K1_BUILD_TESTS=OFF \
	-DSECP256K1_BUILD_EXHAUSTIVE_TESTS=OFF \
	-DSECP256K1_BUILD_CTIME_TESTS=OFF \
	-DSECP256K1_BUILD_BENCHMARK=OFF \
	-DSECP256K1_BUILD_EXAMPLES=OFF \
	-DSECP256K1_ENABLE_MODULE_ECDH=OFF \
	-DSECP256K1_ENABLE_MODULE_RECOVERY=OFF \
	-DSECP256K1_ENABLE_MODULE_EXTRAKEYS=ON \
	-DSECP256K1_ENABLE_MODULE_SCHNORRSIG=ON \
	-DSECP256K1_ENABLE_MODULE_MUSIG=OFF \
	-DSECP256K1_ENABLE_MODULE_ELLSWIFT=OFF \
	-DSECP256K1_ENABLE_MODULE_SILENTPAYMENTS=OFF

.PHONY: all deps fetch verify configure secp example test clean distclean info help

all: secp

deps:
	@command -v git >/dev/null 2>&1 || { echo "error: git is required"; exit 1; }
	@command -v cmake >/dev/null 2>&1 || { echo "error: cmake is required"; exit 1; }
	@command -v cc >/dev/null 2>&1 || { echo "error: a C compiler is required"; exit 1; }

fetch: deps
	@if [ ! -d "$(SECP_SOURCE_DIR)/.git" ]; then \
		echo "==> Fetching libsecp256k1 $(SECP_TAG)"; \
		mkdir -p "$(DEPS_DIR)"; \
		git clone --depth 1 --branch "$(SECP_TAG)" "$(SECP_REPO)" "$(SECP_SOURCE_DIR)"; \
	else \
		echo "==> libsecp256k1 source already present"; \
	fi

verify: fetch
	@actual="$$(git -C "$(SECP_SOURCE_DIR)" rev-parse --short=7 HEAD)"; \
	if [ "$$actual" != "$(SECP_COMMIT)" ]; then \
		echo "error: expected libsecp256k1 commit $(SECP_COMMIT), got $$actual"; \
		echo "run 'make distclean' and then 'make'"; \
		exit 1; \
	fi
	@echo "==> Verified libsecp256k1 $(SECP_TAG) ($(SECP_COMMIT))"

configure: verify
	@echo "==> Configuring libsecp256k1"
	cmake -S "$(SECP_SOURCE_DIR)" -B "$(SECP_BUILD_DIR)" $(CMAKE_FLAGS)

secp: configure
	@echo "==> Building libsecp256k1"
	cmake --build "$(SECP_BUILD_DIR)" --config Release

	@mkdir -p "$(LIB_DIR)"

	@artifact="$$(find "$(SECP_BUILD_DIR)" -type f -name 'libsecp256k1.a' -print -quit)"; \
	if [ -z "$$artifact" ]; then \
		echo "error: libsecp256k1.a was not found"; \
		exit 1; \
	fi; \
	cp "$$artifact" "$(SECP_LIB)"

	@echo "==> Ready: $(SECP_LIB)"

example: secp
	@if [ -z "$(EXAMPLE)" ]; then \
		echo "error: choose an example, e.g."; \
		echo "  make example EXAMPLE=examples/start_context.odin"; \
		exit 1; \
	fi
	$(ODIN) run "$(EXAMPLE)" -file

test: secp
	$(ODIN) test tests

clean:
	rm -rf "$(BUILD_DIR)"
	rm -f "$(SECP_LIB)"

distclean: clean
	rm -rf "$(DEPS_DIR)"

info:
	@echo "libsecp256k1 tag:       $(SECP_TAG)"
	@echo "libsecp256k1 commit:    $(SECP_COMMIT)"
	@echo "source directory:       $(SECP_SOURCE_DIR)"
	@echo "build directory:        $(SECP_BUILD_DIR)"
	@echo "static library output:  $(SECP_LIB)"

help:
	@echo "Targets:"
	@echo "  make / make secp   Fetch, verify, configure and build libsecp256k1"
	@echo "  make fetch         Download the pinned upstream release"
	@echo "  make verify        Check the expected commit"
	@echo "  make configure     Configure the CMake build"
	@echo "  make example EXAMPLE=path/to/file.odin"
	@echo "  make test          Run Odin tests"
	@echo "  make clean         Remove build artifacts"
	@echo "  make distclean     Also remove downloaded libsecp256k1 source"
	@echo "  make info          Show pinned version and paths"
