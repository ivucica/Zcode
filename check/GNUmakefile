
ifeq ($(GNUSTEP_MAKEFILES),)
 GNUSTEP_MAKEFILES := $(shell gnustep-config --variable=GNUSTEP_MAKEFILES 2>/dev/null)
endif
ifeq ($(GNUSTEP_MAKEFILES),)
 $(error You need to set GNUSTEP_MAKEFILES before compiling!)
endif

include $(GNUSTEP_MAKEFILES)/common.make

TOOL_NAME		= check_Zcode

check_Zcode_OBJC_FILES	= \
$(wildcard ../PBXProjLib/*.m) \
$(wildcard check_*.m) \
main.m

-include GNUmakefile.preamble
include $(GNUSTEP_MAKEFILES)/tool.make

main.m:: index.h
index.h: $(wildcard check_*.m)
	grep ^CHECK $^ | sed 's/^check_.*\.m:CHECK/CHECK/' > index.h

# `make check' is not documented, but we seem to have the hooks here for this purpose.
internal-check:: $(addprefix $(GNUSTEP_OBJ_DIR)/,$(TOOL_NAME))
	for t in $^; do $$t || exit $$?; done
