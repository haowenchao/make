ifndef target
  target = a.out
endif

CROSS_COMPILE := 
CC      := $(CROSS_COMPILE)gcc
LD      := $(CROSS_COMPILE)ld
CPP     := $(CROSS_COMPILE)gcc
AR      := $(CROSS_COMPILE)ar
OBJDUMP := $(CROSS_COMPILE)objdump
OBJCOPY := $(CROSS_COMPILE)objcopy
export CC LD CPP AR OBJDUMP OBJCOPY

CFLAG  := -Wall -O2 -g
LDFLAG :=
export CFLAG LDFLAG

ifeq ("$(origin V)", "command line")
  BUILD_VERBOSE = $(V)
endif

ifndef BUILD_VERBOSE
  BUILD_VERBOSE = 0
endif

ifeq ($(BUILD_VERBOSE),1)
  quiet =
  Q =
else
  quiet=quiet_
  Q = @
endif
export BUILD_VERBOSE quiet Q

MAKEFLAGS += --no-print-directory
TOPDIR := $(shell pwd)
SCRIPT := $(TOPDIR)/script
build  := -f $(SCRIPT)/Makefile.build -C
MAKE   := make
export TOPDIR SCRIPT build MAKE

PHONY    :=
subdir   := dir1/ dir2/ dir3/
subdir-y := $(foreach v, $(filter %/, $(subdir)), $(patsubst %/, %/built-in.o, $v))
subdir   := $(foreach v, $(filter %/, $(subdir)), $(patsubst %/, %, $(v)))

all : $(subdir)

PHONY += $(subdir)
$(subdir) :
	$(Q) $(MAKE) $(build) $@

.PHONY : $(PHONY)

