TARGET = unikit.elf

INCLUDE_DIRS = 	../include \
				../../../include \
				../../../arch/x86/include

SRCS = 	multiboot.S \
		multiboot.c \
		boot.S \
		boot.c \
		pagetable.S \
		console.c \
		../../bootinfo.c \
		../../memory.c \
		../../nostd.c \
		../../../arch/x86/serial.c \
 		../../../arch/x86/traps.c \
		../../../arch/x86/traps.S \
		../../../arch/x86/gdt.c

LINKER_SCRIPT = link.x
ENTRYPOINT = _multiboot_entry

ELF64_TO_32 = i386

