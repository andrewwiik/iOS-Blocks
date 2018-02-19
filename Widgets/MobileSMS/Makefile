include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = MobileSMS
MobileSMS_BUNDLE_NAME = com.iosblocks.mobilesms
MobileSMS_BUNDLE_EXTENSION = block
MobileSMS_CFLAGS =  -fobjc-arc
MobileSMS_FILES = $(wildcard *.m)
MobileSMS_FRAMEWORKS = Foundation UIKit
MobileSMS_LDFLAGS = -lsqlite3
MobileSMS_INSTALL_PATH = /Library/Curago/Widgets/

include $(THEOS_MAKE_PATH)/bundle.mk
