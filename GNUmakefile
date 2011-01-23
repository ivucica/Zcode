#
# GNUmakefile - Generated by ProjectCenter
#
ifeq ($(GNUSTEP_MAKEFILES),)
 GNUSTEP_MAKEFILES := $(shell gnustep-config --variable=GNUSTEP_MAKEFILES 2>/dev/null)
endif
ifeq ($(GNUSTEP_MAKEFILES),)
 $(error You need to set GNUSTEP_MAKEFILES before compiling!)
endif

include $(GNUSTEP_MAKEFILES)/common.make

#
# Application
#
VERSION = 1.0
PACKAGE_NAME = Zcode
APP_NAME = Zcode
Zcode_APPLICATION_ICON = apple-green.png


#
# Resource files
#
Zcode_RESOURCE_FILES = \
$(wildcard Resources/*.xib) \
Resources/Zcode.gorm \
Resources/Main.gsmarkup \
Resources/MainMenu-GNUstep.gsmarkup \
Resources/MainMenu-OSX.gsmarkup \
Resources/ProjectDocument.gorm \
Resources/apple-green.png 


#
# Header files
#
Zcode_HEADER_FILES = \
PBXProjLib/PBXFileReference.h \
PBXProjLib/PBXGroup.h \
PBXProjLib/PBXProject.h \
PBXProjLib/PBXProjectReader.h \
PBXProjLib/PBXVariantGroup.h \
AppController.h \
ProjectDocument.h \
GAFContainer.h \
NSDictionary+SmartUnpack.h \
PBXGroup+ViewRelated.h \
PBXFileReference+ViewRelated.h \
ImageAndTextCell.h \
ZCEditorViewController.h \
ZCTextEditorViewController.h

#
# Class files
#
Zcode_OBJC_FILES = \
PBXProjLib/PBXFileReference.m \
PBXProjLib/PBXGroup.m \
PBXProjLib/PBXProject.m \
PBXProjLib/PBXProjectReader.m \
PBXProjLib/PBXVariantGroup.m \
AppController.m \
ProjectDocument.m \
GAFContainer.m \
NSDictionary+SmartUnpack.m \
PBXGroup+ViewRelated.m \
PBXFileReference+ViewRelated.m \
ImageAndTextCell.m \
ZCEditorViewController.m \
ZCTextEditorViewController.m

#
# Other sources
#
Zcode_OBJC_FILES += \
Zcode_main.m 

#
# Subprojects
#
SUBPROJECTS = \
check

#
# Makefiles
#
-include GNUmakefile.preamble
include $(GNUSTEP_MAKEFILES)/aggregate.make
include $(GNUSTEP_MAKEFILES)/application.make
-include GNUmakefile.postamble
