include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Weather
Weather_BUNDLE_NAME = com.iosblocks.weather
Weather_BUNDLE_EXTENSION = block
Weather_CFLAGS =  -fobjc-arc
Weather_FILES = $(wildcard *.m)
Weather_FRAMEWORKS = Foundation UIKit
Weather_PRIVATE_FRAMEWORKS = Weather
Weather_INSTALL_PATH = /var/mobile/Library/Curago/Widgets/

include $(THEOS_MAKE_PATH)/bundle.mk
