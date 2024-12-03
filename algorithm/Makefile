RISCV_XLEN    ?= 64
RISCV_ARCH    ?= rv$(RISCV_XLEN)gcv
RISCV_ABI     ?= lp64d
RISCV_TARGET  ?= riscv$(RISCV_XLEN)-linux-gnu

# Use LLVM
RISCV_PREFIX  ?= $(LLVM_INSTALL_DIR)/bin/
RISCV_CC      ?= $(RISCV_PREFIX)clang
RISCV_CXX     ?= $(RISCV_PREFIX)clang++
RISCV_OBJDUMP ?= $(RISCV_PREFIX)llvm-objdump
RISCV_OBJCOPY ?= $(RISCV_PREFIX)llvm-objcopy
RISCV_AS      ?= $(RISCV_PREFIX)llvm-as
RISCV_AR      ?= $(RISCV_PREFIX)llvm-ar
RISCV_LD      ?= $(RISCV_PREFIX)ld.lld
RISCV_STRIP   ?= $(RISCV_PREFIX)llvm-strip

RISCV_CC_GCC  ?= $(RISCV_TARGET)-gcc
RISCV_CC_OBJDUMP  ?= $(RISCV_TARGET)-objdump

# LLVM Flags
LLVM_FLAGS     ?= -march=$(RISCV_ARCH) -menable-experimental-extensions -mabi=$(RISCV_ABI) -mno-relax
RISCV_FLAGS    ?= $(LLVM_FLAGS) -mcmodel=medany -O3 -ffast-math -fno-common -fno-builtin-printf
RISCV_CCFLAGS  ?= $(RISCV_FLAGS) -ffunction-sections -fdata-sections
RISCV_CXXFLAGS ?= $(RISCV_FLAGS) -ffunction-sections -fdata-sections
RISCV_LDFLAGS  ?= -static -nostartfiles -lm -Wl,--gc-sections

# GCC Flags
RISCV_FLAGS_GCC    ?= -mcmodel=medany -march=$(RISCV_ARCH) -mabi=$(RISCV_ABI) -I$(CURDIR)/common -static -std=gnu99 -O3 -ffast-math -fno-common -fno-builtin-printf -Wno-unused-result
RISCV_CCFLAGS_GCC  ?= $(RISCV_FLAGS_GCC)
RISCV_CXXFLAGS_GCC ?= $(RISCV_FLAGS_GCC)
RISCV_LDFLAGS_GCC  ?= -static -nostartfiles -lm -lgcc $(RISCV_FLAGS_GCC)

RISCV_OBJDUMP_FLAGS ?= -S

all: x86 rvv 
x86: topk-max-heap-x86 topk-min-heap-x86 topk-max-quickselect-x86 topk-min-quickselect-x86
topk-max-heap-x86: csrc/topk-max-heap.c
	gcc -o bin/$@ $<
topk-min-heap-x86: csrc/topk-min-heap.c
	gcc -o bin/$@ $<
topk-max-quickselect-x86: csrc/topk-max-quickselect.c
	gcc -o bin/$@ $<
topk-min-quickselect-x86: csrc/topk-min-quickselect.c
	gcc -o bin/$@ $<

rvv: topk-max-heap-rvv topk-min-heap-rvv topk-max-quickselect-rvv topk-min-quickselect-rvv
topk-max-heap-rvv: csrc/topk-max-heap.c
	$(RISCV_CC_GCC) $(RISCV_FLAGS_GCC) $(RISCV_LDFLAGS_GCC) -o bin/$@ $<
	$(RISCV_CC_OBJDUMP) $(RISCV_OBJDUMP_FLAGS) -D bin/$@ > dump/topk-max-heap-rvv.dump
	rm bin/$@
topk-min-heap-rvv: csrc/topk-min-heap.c
	$(RISCV_CC_GCC) $(RISCV_FLAGS_GCC) $(RISCV_LDFLAGS_GCC) -o bin/$@ $<
	$(RISCV_CC_OBJDUMP) $(RISCV_OBJDUMP_FLAGS) -D bin/$@ > dump/topk-min-heap-rvv.dump
	rm bin/$@
topk-max-quickselect-rvv: csrc/topk-max-quickselect.c
	$(RISCV_CC_GCC) $(RISCV_FLAGS_GCC) $(RISCV_LDFLAGS_GCC) -o bin/$@ $<
	$(RISCV_CC_OBJDUMP) $(RISCV_OBJDUMP_FLAGS) -D bin/$@ > dump/topk-max-quickselect-rvv.dump
	rm bin/$@
topk-min-quickselect-rvv: csrc/topk-min-quickselect.c
	$(RISCV_CC_GCC) $(RISCV_FLAGS_GCC) $(RISCV_LDFLAGS_GCC) -o bin/$@ $<
	$(RISCV_CC_OBJDUMP) $(RISCV_OBJDUMP_FLAGS) -D bin/$@ > dump/topk-min-quickselect-rvv.dump
	rm bin/$@

clean:
	rm bin/* dump/*
