/* SPDX-License-Identifier: MPL-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the MPL-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#ifndef __LXBOOT_H__
#define __LXBOOT_H__

#define ROOT_RDONLY 1

#define NORMAL_VGA		0xffff		/* 80x25 mode */
#define EXTENDED_VGA	0xfffe		/* 80x50 mode */
#define ASK_VGA			0xfffd

/* loadflags */
#define LOADED_HIGH		(1 << 0)
#define KASLR_FLAG		(1 << 1)
#define QUIET_FLAG		(1 << 5)
#define KEEP_SEGMENTS	(1 << 6)
#define CAN_USE_HEAP	(1 << 7)

/* xloadflags */
#define XLF_KERNEL_64 				(1 << 0)
#define XLF_CAN_BE_LOADED_ABOVE_4G	(1 << 1)
#define XLF_EFI_HANDOVER_32 		(1 << 2)
#define XLF_EFI_HANDOVER_64 		(1 << 3)
#define XLF_EFI_KEXEC 				(1 << 4)

#ifndef __ASSEMBLY__

#include <unikit/essentials.h>

extern struct lxboot_params boot_params;
extern struct lxboot_setup_header hdr;

struct lxboot_setup_header {
	u8  setup_sects;
	u16 root_flags;
	u32 syssize;
	u16 ram_size;
	u16 vid_mode;
	u16 root_dev;
	u16 boot_flag;
	u16 jump;
	u32 header;
	u16 version;
	u32 realmode_swtch;
	u16 start_sys_seg;
	u16 kernel_version;
	u8  type_of_loader;
	u8  loadflags;
	u16 setup_move_size;
	u32 code32_start;
	u32 ramdisk_image;
	u32 ramdisk_size;
	u32 bootsect_kludge;
	u16 heap_end_ptr;
	u8  ext_loader_ver;
	u8  ext_loader_type;
	u32 cmd_line_ptr;
	u32 initrd_addr_max;
	u32 kernel_alignment;
	u8  relocatable_kernel;
	u8  min_alignment;
	u16 xloadflags;
	u32 cmd_line_size;
	u32 hardware_subarch;
	u64 hardware_subarch_data;
	u32 payload_offset;
	u32 payload_length;
	u64 setup_data;
	u64 pref_address;
	u32 init_size;
	u32 handover_offset;
	u32 kernel_info_offset;
} __packed;

struct lxboot_screen_info {
	u8 orig_x;
	u8 orig_y;
	u16 ext_mem_k;
	u16 orig_video_page;
	u8 orig_video_mode;
	u8 orig_video_cols;
	u8 flags;
	u8 unused2;
	u16 orig_video_ega_bx;
	u16 unused3;
	u8 orig_video_lines;
	u8 orig_video_isVGA;
	u16 orig_video_points;
	u16 lfb_width;
	u16 lfb_height;
	u16 lfb_depth;
	u32 lfb_base;
	u32 lfb_size;
	u16 cl_magic;
	u16 cl_offset;
	u16 lfb_linelength;
	u8 red_size;
	u8 red_pos;
	u8 green_size;
	u8 green_pos;
	u8 blue_size;
	u8 blue_pos;
	u8 rsvd_size;
	u8 rsvd_pos;
	u16 vesapm_seg;
	u16 vesapm_off;
	u16 pages;
	u16 vesa_attributes;
	u32 capabilities;
	u32 ext_lfb_base;
	u8 reserved[2];
} __packed;

struct lxboot_apm_bios_info {
	u16 version;
	u16 cseg;
	u32 offset;
	u16 cseg_16;
	u16 dseg;
	u16 flags;
	u16 cseg_len;
	u16 cseg_16_len;
	u16 dseg_len;
} __packed;

struct lxboot_ist_info {
	u32 signature;
	u32 command;
	u32 event;
	u32 perf_level;
} __packed;

struct lxboot_sys_desc_table {
	u16 length;
	u8 table[14];
} __packed;

struct lxboot_olpc_ofw_header {
	u32 ofw_magic;	/* OFW signature */
	u32 ofw_version;
	u32 cif_handler;	/* callback into OFW */
	u32 irq_desc_table;
} __packed;

#define LXBOOT_E820_TYPE_RAM		1
#define LXBOOT_E820_TYPE_RESERVED	2
#define LXBOOT_E820_TYPE_ACPI		3
#define LXBOOT_E820_TYPE_NVS		4
#define LXBOOT_E820_TYPE_UNUSABLE	5
#define LXBOOT_E820_TYPE_PMEM		7

struct lxboot_e820_entry {
	u64 addr;
	u64 size;
	u32 type;
} __packed;

struct lxboot_edid_info {
	unsigned char dummy[128];
} __packed;

struct lxboot_efi_info {
	u32 efi_loader_signature;
	u32 efi_systab;
	u32 efi_memdesc_size;
	u32 efi_memdesc_version;
	u32 efi_memmap;
	u32 efi_memmap_size;
	u32 efi_systab_hi;
	u32 efi_memmap_hi;
} __packed;

struct lxboot_edd_device_params {
	u16 length;
	u16 info_flags;
	u32 num_default_cylinders;
	u32 num_default_heads;
	u32 sectors_per_track;
	u64 number_of_sectors;
	u16 bytes_per_sector;
	u32 dpte_ptr;		/* 0xFFFFFFFF for our purposes */
	u16 key;		/* = 0xBEDD */
	u8  device_path_info_length;	/* = 44 */
	u8  reserved2;
	u16 reserved3;
	u8  host_bus_type[4];
	u8  interface_type[8];
	union {
		struct {
			u16 base_address;
			u16 reserved1;
			u32 reserved2;
		} __packed isa;
		struct {
			u8 bus;
			u8 slot;
			u8 function;
			u8 channel;
			u32 reserved;
		} __packed pci;
		/* pcix is same as pci */
		struct {
			u64 reserved;
		} __packed ibnd;
		struct {
			u64 reserved;
		} __packed xprs;
		struct {
			u64 reserved;
		} __packed htpt;
		struct {
			u64 reserved;
		} __packed unknown;
	} interface_path;
	union {
		struct {
			u8 device;
			u8 reserved1;
			u16 reserved2;
			u32 reserved3;
			u64 reserved4;
		} __packed ata;
		struct {
			u8 device;
			u8 lun;
			u8 reserved1;
			u8 reserved2;
			u32 reserved3;
			u64 reserved4;
		} __packed atapi;
		struct {
			u16 id;
			u64 lun;
			u16 reserved1;
			u32 reserved2;
		} __packed scsi;
		struct {
			u64 serial_number;
			u64 reserved;
		} __packed usb;
		struct {
			u64 eui;
			u64 reserved;
		} __packed i1394;
		struct {
			u64 wwid;
			u64 lun;
		} __packed fibre;
		struct {
			u64 identity_tag;
			u64 reserved;
		} __packed i2o;
		struct {
			u32 array_number;
			u32 reserved1;
			u64 reserved2;
		} __packed raid;
		struct {
			u8 device;
			u8 reserved1;
			u16 reserved2;
			u32 reserved3;
			u64 reserved4;
		} __packed sata;
		struct {
			u64 reserved1;
			u64 reserved2;
		} __packed unknown;
	} device_path;
	u8 reserved4;
	u8 checksum;
} __packed;

struct lxboot_edd_info {
	u8  device;
	u8  version;
	u16 interface_support;
	u16 legacy_max_cylinder;
	u8  legacy_max_head;
	u8  legacy_sectors_per_track;
	struct lxboot_edd_device_params params;
} __packed;

#define LXBOOT_E820_MAX_ENTRIES 128
#define LXBOOT_EDD_MBR_SIG_MAX 16
#define LXBOOT_EDDMAXNR 6

struct lxboot_params {
	struct lxboot_screen_info screen_info;
	struct lxboot_apm_bios_info apm_bios_info;
	u8  _pad2[4];
	u64  tboot_addr;
	struct lxboot_ist_info ist_info;
	u64 acpi_rsdp_addr;
	u8  _pad3[8];
	u8  hd0_info[16];
	u8  hd1_info[16];
	struct lxboot_sys_desc_table sys_desc_table;
	struct lxboot_olpc_ofw_header olpc_ofw_header;
	u32 ext_ramdisk_image;
	u32 ext_ramdisk_size;
	u32 ext_cmd_line_ptr;
	u8  _pad4[112];
	u32 cc_blob_address;
	struct lxboot_edid_info edid_info;
	struct lxboot_efi_info efi_info;
	u32 alt_mem_k;
	u32 scratch;
	u8  e820_entries;
	u8  eddbuf_entries;
	u8  edd_mbr_sig_buf_entries;
	u8  kbd_status;
	u8  secure_boot;
	u8  _pad5[2];
	u8  sentinel;
	u8  _pad6[1];
	struct lxboot_setup_header hdr;
	u8  _pad7[0x290 - 0x1f1 - sizeof(struct lxboot_setup_header)];
	u32 edd_mbr_sig_buffer[LXBOOT_EDD_MBR_SIG_MAX];
	struct lxboot_e820_entry e820_table[LXBOOT_E820_MAX_ENTRIES];
	u8  _pad8[48];
	struct lxboot_edd_info eddbuf[LXBOOT_EDDMAXNR];
	u8  _pad9[276];
} __packed;

#endif /* __ASSEMBLY__ */

#endif /* __LXBOOT_H__ */