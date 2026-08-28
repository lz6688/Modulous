ifeq ($(THEOS_PACKAGE_SCHEME),rootless)
ARCHS := arm64 arm64e
TARGET := iphone:clang:16.4:15.0
else
ARCHS := armv7 arm64 arm64e
TARGET := iphone:clang:14.5:8.0
endif

include $(THEOS)/makefiles/common.mk

FRAMEWORK_NAME = Modulous

Modulous_FILES = Loader.m Module.m
Modulous_INSTALL_PATH = /Library/Frameworks
Modulous_CFLAGS = -fobjc-arc -IHeaders
Modulous_LDFLAGS = -install_name @rpath/Modulous.framework/Modulous
Modulous_FRAMEWORKS = Foundation

include $(THEOS_MAKE_PATH)/framework.mk
