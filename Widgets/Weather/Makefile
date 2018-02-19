include $(THEOS)/makefiles/common.mk

PZFileBrowser.m_CFLAGS = -fno-objc-arc

BUNDLE_NAME = Weather
Weather_BUNDLE_NAME = com.iosblocks.weather
Weather_BUNDLE_EXTENSION = block
Weather_CFLAGS +=  -fobjc-arc -I../headers
Weather_FILES = $(wildcard *.m)
Weather_FRAMEWORKS = Foundation UIKit CoreGraphics QuartzCore
Weather_LIBRARIES = z
Weather_LDFLAGS = $(THEOS)/vendor/lib/libsubstrate.tbd ./Weather.tbd
Weather_INSTALL_PATH = /Library/Curago/Widgets/

include $(THEOS_MAKE_PATH)/bundle.mk