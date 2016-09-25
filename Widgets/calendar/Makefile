include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Calendar
Calendar_BUNDLE_NAME = com.iosblocks.calendar
Calendar_BUNDLE_EXTENSION = block
Calendar_CFLAGS =  -fobjc-arc
Calendar_FILES = $(wildcard *.m)
Calendar_FRAMEWORKS = Foundation UIKit EventKitUI CoreGraphics
Calendar_PRIVATE_FRAMEWORKS = CalendarFoundation
Calendar_INSTALL_PATH = /var/mobile/Library/Curago/Widgets/

include $(THEOS_MAKE_PATH)/bundle.mk
