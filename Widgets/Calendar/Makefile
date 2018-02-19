include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Calendar
Calendar_BUNDLE_NAME = com.iosblocks.mobilecal
Calendar_BUNDLE_EXTENSION = block
Calendar_CFLAGS =  -fobjc-arc
Calendar_FILES = $(wildcard *.m)
Calendar_FRAMEWORKS = Foundation UIKit EventKitUI CoreGraphics
Calendar_LDFLAGS += ./CalendarFoundation.tbd
Calendar_INSTALL_PATH = /bootstrap/Library/Curago/Widgets/

include $(THEOS_MAKE_PATH)/bundle.mk
