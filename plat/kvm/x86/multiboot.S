#include <unikit/plat/kvm/multiboot.h>

.section .text.boot, "a"
.code32
.globl _multiboot_entry
_multiboot_entry:
	cmp	eax, MULTIBOOT_BOOTLOADER_MAGIC

	jne magic_mismatch

	call setup_32

magic_mismatch:
	cli
1:
	hlt
	jmp	1b