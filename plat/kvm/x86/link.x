/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2023, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

/*
 * Executable 0x01
 * Writeable  0x02
 * Readable   0x04
 */

PHDRS {
    text   PT_LOAD FLAGS(0x04 | 0x01); /* R/X */
    data   PT_LOAD FLAGS(0x04 | 0x02); /* R/W */
    rodata PT_LOAD FLAGS(0x04);        /* R   */
}

SECTIONS {
	. = 0x100000;

	.boot : {
		KEEP (*(.data.boot))
		KEEP (*(.data.boot.*))

		*(.text.boot)
		*(.text.boot.*)
	}

	.text :
	{
		*(.text)
		*(.text.*)
	} :text

	.bss :
	{
	    *(.bss)
	    *(.bss.*)
	} :data

	.data :
	{
		*(.data)
		*(.data.*)
	} :data

	.rodata :
	{
		*(.rodata)
		*(.rodata.*)
	} :rodata
}
