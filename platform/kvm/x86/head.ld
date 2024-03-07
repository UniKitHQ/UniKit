/* SPDX-License-Identifier: MPL-2.0 */
/* Copyright (c) 2023, Pribess (Heewon Cho).
 * Licensed under the MPL-2.0 License.
 * You may not use this file except in compliance with the License.
 */

OUTPUT_FORMAT(elf32-i386)

SECTIONS {
	. = 0x00;
	.head :
	{
		*(.text.head)
		*(.data.head)
	}

	. = 0x1F1;
	.data.lxboot.header	: { *(.data.lxboot.header) }

	.text :
	{
		*(.text.boot)
		*(.text)
	}

	. = ALIGN(16);
	.data			: { *(.data) }
	.rodata			: { *(.rodata) }
	.bss :
	{
		_bss_start = .;
		*(.bss)
		. = ALIGN(4);
		_bss_end = .;
	}

	.meta			: {}

	.padding		: { *(.padding) }
}