.DEFAULT_GOAL := default
.PHONY: default
default:
	@echo "No target platform specified. Please specify a target platform."

ARCH ?= $(shell uname -m)

ifeq ($(ARCH), x86_64)
	ARCH_DIR = x86
else
	ARCH_DIR = $(ARCH)
endif

ifeq ($(MAKECMDGOALS), kvm)
	include plat/kvm/$(ARCH_DIR)/Makefile
	SRCS_PATH = plat/kvm/$(ARCH_DIR)
endif

BUILD_DIR = build

CC = clang
AS = clang
LD = ld.lld
OBJCOPY = llvm-objcopy

CFLAGS = -nostdlib -masm=intel
CFLAGS += $(addprefix -I$(SRCS_PATH)/, $(INCLUDE_DIRS)) -target $(ARCH)-freestanding

ASFLAGS = -masm=intel -D__ASSEMBLY__
ASFLAGS += $(addprefix -I$(SRCS_PATH)/, $(INCLUDE_DIRS)) -target $(ARCH)-freestanding

LDFLAGS = --entry=$(ENTRYPOINT)

OBJS = $(addprefix $(BUILD_DIR)/$(SRCS_PATH)/, $(addsuffix .o, $(SRCS)))


kvm: $(BUILD_DIR)/$(TARGET)

$(BUILD_DIR)/%.c.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/%.S.o: %.S
	@mkdir -p $(dir $@)
	$(AS) $(ASFLAGS) -c $< -o $@

$(BUILD_DIR)/$(TARGET): $(SRCS_PATH)/$(LINKER_SCRIPT) $(OBJS)
	@mkdir -p $(dir $@)
	$(LD) $(LDFLAGS) $^ -o $@
ifdef ELF64_TO_32
	llvm-objcopy --output-target=elf32-$(ELF64_TO_32) $(BUILD_DIR)/$(TARGET)
endif

.PHONY: run
run: $(BUILD_DIR)/unikit.elf
	qemu-system-x86_64 -nographic -kernel $(BUILD_DIR)/unikit.elf

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
