multiboot.elf: link.x multiboot.S multiboot.c boot.S ../../../arch/x86/serial.c pagetable.S console.c ../../bootinfo.c
	zig cc -I../include -I../../../include -I../../../arch/x86/include -masm=intel -target x86_64-freestanding -D__ASSEMBLY__ -c multiboot.S -o multiboot.S.o
	zig cc -I../include -I../../../include -I../../../arch/x86/include -masm=intel -target x86_64-freestanding -c multiboot.c
	zig cc -I../include -I../../../include -I../../../arch/x86/include -masm=intel -target x86_64-freestanding -D__ASSEMBLY__ -c pagetable.S -o pagetable.S.o
	zig cc -I../include -I../../../include -I../../../arch/x86/include -masm=intel -target x86_64-freestanding -D__ASSEMBLY__ -c boot.S -o boot.S.o
	zig cc -I../include -I../../../include -I../../../arch/x86/include -masm=intel -target x86_64-freestanding -c ../../../arch/x86/serial.c
	zig cc -I../include -I../../../include -I../../../arch/x86/include -masm=intel -target x86_64-freestanding -c console.c
	zig cc -I../include -I../../../include -I../../../arch/x86/include -masm=intel -target x86_64-freestanding -c multiboot.c
	zig cc -I../include -I../../../include -I../../../arch/x86/include -masm=intel -target x86_64-freestanding -c ../../bootinfo.c
	zig ld.lld -T link.x --entry=_multiboot_entry -o multiboot.elf multiboot.o serial.o multiboot.S.o boot.S.o pagetable.S.o console.o bootinfo.o
	llvm-objcopy --output-target=elf32-i386 multiboot.elf

.PHONY: run
run: multiboot.elf
	qemu-system-x86_64 -nographic -kernel multiboot.elf

.PHONY: clean
clean:
	rm -f *.o
	rm -f *.elf
	rm -f *.bin
