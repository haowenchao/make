#specify the subdirs which need to build in here, such as dir1/
subdir  :=

#specify you cross compiler here. this Makefile using gcc compiler default
#you might want to change the compiler, just change the following variables
CROSS_COMPILER =

CC      := $(CROSS_COMPILER)gcc
LD      := $(CROSS_COMPILER)ld
CPP     := $(CROSS_COMPILER)gcc
AR      := $(CROSS_COMPILER)ar
OBJDUMP := $(CROSS_COMPILER)objdump
OBJCOPY := $(CROSS_COMPILER)objcopy
export CC LD CPP AR OBJDUMP OBJCOPY

#FLAGS for compiler other tools. define your own flags here. such -Ixxx to
#add a include path.
CFLAGS  := 
LDFLAGS :=
OBJCOPYFLAGS := -O binary -S
OBJDUMPFLAGS := -D -S
export CFLAGS LDFLAGS OBJCOPYFLAGS OBJDUMPFLAGS

# Beautify output
# ---------------------------------------------------------------------------
#
# Normally, we echo the whole command before executing it. By making
# that echo $($(quiet)$(cmd)), we now have the possibility to set
# $(quiet) to choose other forms of output instead, e.g.
#
#         quiet_cmd_cc_o_c = Compiling $(RELDIR)/$@
#         cmd_cc_o_c       = $(CC) $(c_flags) -c -o $@ $<
#
# If $(quiet) is empty, the whole command will be printed.
# If it is set to "quiet_", only the short version will be printed.
# If it is set to "silent_", nothing will be printed at all, since
# the variable $(silent_cmd_cc_o_c) doesn't exist.
#
# A simple variant is to prefix commands with $(Q) - that's useful
# for commands that shall be hidden in non-verbose mode.
#
#	$(Q)ln $@ :<
#
# If KBUILD_VERBOSE equals 0 then the above command will be hidden.
# If KBUILD_VERBOSE equals 1 then the above command is displayed.
#
# To put more focus on warnings, be less verbose as default
# Use 'make V=1' to see the full commands
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

#system variables, you should not modify these variables
MAKEFLAGS += --no-print-directory
TOPDIR := $(shell pwd)
SCRIPT := $(TOPDIR)/script
build  := -f $(SCRIPT)/Makefile.build -C
MAKE   := make
export TOPDIR SCRIPT build MAKE

PHONY    =
subdir-y := $(foreach v, $(filter %/, $(subdir)), $(patsubst %/, %/built-in.o, $v))
subdir   := $(foreach v, $(filter %/, $(subdir)), $(patsubst %/, %, $(v)))

#recipe to make your target file, is should be modify according to the situation.
all : $(subdir-y)

$(subdir-y) : $(subdir)

#recipe to build subdir objects, it is not recommend to modify
PHONY += $(subdir)
$(subdir) :
	$(Q) $(MAKE) $(build) $@

#clean, add you specific pieces here
PHONY += clean
clean:
	find . -name "*.o"  | xargs rm -f
	find . -name "*.a"  | xargs rm -f

.PHONY : $(PHONY)

