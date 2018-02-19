include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = MobileTimer
MobileTimer_BUNDLE_NAME = com.iosblocks.mobiletimer
MobileTimer_BUNDLE_EXTENSION = block
MobileTimer_CFLAGS =  -fobjc-arc
MobileTimer_FILES = $(wildcard *.m)
MobileTimer_FRAMEWORKS = Foundation UIKit CoreGraphics QuartzCore
MobileTimer_LDFLAGS = $(THEOS)/vendor/lib/libsubstrate.tbd
MobileTimer_INSTALL_PATH = /Library/Curago/Widgets/

include $(THEOS_MAKE_PATH)/bundle.mk
