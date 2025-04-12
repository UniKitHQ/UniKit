SECTIONS {
    . = 0x100000;
    
    .boot : {
        KEEP (*(.data.boot))
        KEEP (*(.data.boot.*))

        *(.text.boot)
        *(.text.boot.*)
    }
}