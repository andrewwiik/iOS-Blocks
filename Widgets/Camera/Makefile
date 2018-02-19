include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Camera
Camera_BUNDLE_NAME = com.iosblocks.camera
Camera_BUNDLE_EXTENSION = block
Camera_CFLAGS =  -fobjc-arc
Camera_FILES = $(wildcard *.m)
Camera_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore CoreVideo CoreMedia MediaToolbox AssetsLibrary AVFoundation
Camera_LDFLAGS = $(THEOS)/vendor/lib/libsubstrate.tbd
Camera_INSTALL_PATH = /Library/Curago/Widgets/

include $(THEOS_MAKE_PATH)/bundle.mk
