SECTIONS {
    . = 0x100000;
    
    .boot : {
        *(.data.boot)
        *(.data.boot.*)

        *(.text.boot)
        *(.text.boot.*)
    }
}