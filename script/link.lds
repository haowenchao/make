ENTRY(_start)

SECTIONS
{
	. = 0x30000000;
	code_start = .;
	.init	:
	{
		init/built-in.o(.text)
	}
	.text	:
	{
		*(.text)
	__init0_start = .;
		*(init0)
	__init0_end = .;
	__init1_start = .;
		*(init1)
	__init1_end = .;
	__init2_start = .;
		*(init2)
	__init2_end = .;
	}
	__fstart = .;
	func	:
	{
		*(func)
	}
	__fend = .;

	.rodata	:	{*(.rodata)}
	.data	:
	{
		*(.data)
	}
	__bss_start = .;
	.bss	:
	{
		*(.bss)
	}
	__bss_end = .;
}

