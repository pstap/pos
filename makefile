EXENAME=boot.img
CC=nasm
OPTIONS=-f bin -o $(EXENAME)

all:
	nasm -f bin -o boot.bin bootloader.asm

run: img
	qemu -m 1m -fda $(EXENAME)

img:
	nasm -f bin -o bootloader.bin bootloader.asm
	nasm -f bin -o stage2.bin stage2.asm
	dd if=/dev/zero	of=raw_floppy.bin bs=1024 count=1440 conv=notrunc
	cat bootloader.bin stage2.bin raw_floppy.bin > boot.img

clean:
	rm $(EXENAME)
	rm bootloader.bin
	rm stage2.bin
	rm raw_floppy.bin
