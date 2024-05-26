/* SPDX-License-Identifier: MPL-2.0 */
/* Copyright (c) 2023, Pribess (Heewon Cho).
 * Licensed under the MPL-2.0 License.
 * You may not use this file except in compliance with the License.
 */

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
	}
}