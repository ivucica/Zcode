ifeq ($(GNUSTEP_MAKEFILES),)
 GNUSTEP_MAKEFILES := $(shell gnustep-config --variable=GNUSTEP_MAKEFILES 2>/dev/null)
endif
ifeq ($(GNUSTEP_MAKEFILES),)
 $(error You need to set GNUSTEP_MAKEFILES before compiling!)
endif

include $(GNUSTEP_MAKEFILES)/common.make

BUNDLE_NAME=ProductTypes
BUNDLE_EXTENSION=.zcplugin

ProductTypes_OBJC_FILES=PBXApplicationProductType.m PBXBundleProductType.m
ProductTypes_RESOURCE_FILES=Application.xcspec Bundle.xcspec

include $(GNUSTEP_MAKEFILES)/bundle.make
