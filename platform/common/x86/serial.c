/* SPDX-License-Identifier: MPL-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the MPL-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#include <common/x86/serial.h>

#include <common/x86/asm.h>

#define COM1 0x3f8

#define COM1_INTR   (COM1 + 1)
#define COM1_CTRL   (COM1 + 3)
#define COM1_STATUS (COM1 + 5)

/* DLAB == 1 */
#define COM1_DIV_LO (COM1 + 0)
#define COM1_DIV_HI (COM1 + 1)

#define DLAB 0x80
#define PROT 0x03 /* 8 bits, no parity, one stop bit */

void serial_init() {
	outb(COM1_INTR, 0x00); /* disable all interrupts */
	outb(COM1_CTRL, DLAB); /* enable DLAB (set baud rate divisor) */

	/* set divisor to 3 */
	outb(COM1_DIV_LO, 0x01); /* low */
	outb(COM1_DIV_HI, 0x00); /* high */

	outb(COM1_CTRL, PROT);
}

static int serial_tx_empty() {
	return inb(COM1_STATUS) & 0x20;
}

static void serial_write(char i) {
	while (!serial_tx_empty());

	outb(COM1, i);
}

void serial_putc(char i) {
	if (i == '\n') 
		serial_write('\r');
	serial_write(i);
}

static int serial_rx_ready(void) {
	return inb(COM1_STATUS) & 0x01;
}

static int serial_read() {
	while (!serial_rx_ready());

	return inb(COM1);
}

int serial_getc() {
	return serial_read();
}