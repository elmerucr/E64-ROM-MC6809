_ROM_START	= 0xe000;
_RAM_START	= 0x0400;

SECTIONS {
	. = _ROM_START;

	TEXT : {
		_TEXT_START = .;
		*(TEXT);
		*(RODATA);
		_TEXT_END = .;
	}

	DATA _RAM_START : AT(ADDR(TEXT) + SIZEOF(TEXT)) {
		_DATA_START = (. - _RAM_START) + _TEXT_END;
		*(DATA);
		_DATA_END = (. - _RAM_START) + _TEXT_END;
	}

	BSS : {
		_BSS_START = .;
		*(COMMON);
		*(BSS);
		_BSS_END = .;
	}

	VECTORS 0xfffa : AT(0xfffa) {
		*(VECTORS);
	}
}
