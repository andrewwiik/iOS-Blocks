include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Weather
Weather_BUNDLE_NAME = com.iosblocks.weather
Weather_BUNDLE_EXTENSION = block
Weather_CFLAGS =  -fobjc-arc
Weather_FILES = $(wildcard *.m)
Weather_FRAMEWORKS = Foundation UIKit CoreGraphics QuartzCore
Weather_PRIVATE_FRAMEWORKS = Weather
Weather_OBJ_FILES = libAnimatedWeatherUI.a
Weather_LDFLAGS = libAnimatedWeatherUI.a $(THEOS_LIBRARY_PATH)/libsubstrate.dylib
Weather_INSTALL_PATH = /var/mobile/Library/Curago/Widgets/

include $(THEOS_MAKE_PATH)/bundle.mk
