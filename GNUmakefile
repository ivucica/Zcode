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
Resources/Zcode.gorm \
Resources/Main.gsmarkup \
Resources/MainMenu-GNUstep.gsmarkup \
Resources/MainMenu-OSX.gsmarkup \
Resources/ProjectDocument.gorm \
Resources/ZCEditorViewController.gorm \
Resources/apple-green.png \
Resources/app.png \
Resources/build.png \
Resources/run.png \
Resources/target.png

#
# PBXProjLib Header files
#
Zcode_HEADER_FILES = \
PBXProjLib/PBXFileReference.h \
PBXProjLib/PBXBuildPhase.h \
PBXProjLib/PBXShellScriptBuildPhase.h \
PBXProjLib/PBXGroup.h \
PBXProjLib/PBXProject.h \
PBXProjLib/ZCPathedItem.h \
PBXProjLib/ZCPBXProjectReader.h \
PBXProjLib/ZCPBXTargetList.h \
PBXProjLib/PBXVariantGroup.h \
PBXProjLib/PBXNativeTarget.h

#
# IDE Header Files
#
Zcode_HEADER_FILES += \
IDE/AppController.h \
IDE/ProjectDocument.h \
IDE/GAFContainer.h \
IDE/PBXGroup+ViewRelated.h \
IDE/PBXFileReference+ViewRelated.h \
IDE/XCConfigurationList+ViewRelated.h \
IDE/ZCPBXTargetList+ViewRelated.h \
IDE/PBXNativeTarget+ViewRelated.h \
IDE/ImageAndTextCell.h \
IDE/ProjectDetailListDataSource.h \
IDE/ZCTextEditorViewController.h \
IDE/ZCEditorViewController.h \
IDE/ZCInspectorViewController.h

#
# PBXProjLib Class files
#
Zcode_OBJC_FILES = \
PBXProjLib/PBXFileReference.m \
PBXProjLib/PBXBuildPhase.m \
PBXProjLib/PBXShellScriptBuildPhase.m \
PBXProjLib/PBXGroup.m \
PBXProjLib/PBXProject.m \
PBXProjLib/ZCPathedItem.m \
PBXProjLib/ZCPBXProjectReader.m \
PBXProjLib/PBXVariantGroup.m \
PBXProjLib/ZCPBXTargetList.m \
PBXProjLib/PBXNativeTarget.m

#
# IDE Class Files
#
Zcode_OBJC_FILES += \
IDE/AppController.m \
IDE/ProjectDocument.m \
IDE/GAFContainer.m \
IDE/PBXGroup+ViewRelated.m \
IDE/PBXFileReference+ViewRelated.m \
IDE/ZCPBXTargetList+ViewRelated.m \
IDE/PBXNativeTarget+ViewRelated.m \
IDE/ImageAndTextCell.m \
IDE/ProjectDetailListDataSource.m \
IDE/ZCTextEditorViewController.m \
IDE/ZCEditorViewController.m \
IDE/ZCInspectorViewController.m \
IDE/gnustep_more.m \
IDE/Zcode_main.m 

#
# Subprojects
#
SUBPROJECTS = \
check

#
# Makefiles
#
include GNUmakefile.preamble
include $(GNUSTEP_MAKEFILES)/aggregate.make
include $(GNUSTEP_MAKEFILES)/application.make
include GNUmakefile.postamble
