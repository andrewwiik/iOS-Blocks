include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Music
Music_BUNDLE_NAME = com.iosblocks.music
Music_BUNDLE_EXTENSION = block
Music_CFLAGS =  -fobjc-arc
Music_FILES = $(wildcard *.m)
Music_FRAMEWORKS = Foundation UIKit MediaPlayer CoreGraphics CoreImage QuartzCore
Music_LDFLAGS = $(THEOS)/vendor/lib/libsubstrate.tbd ./MediaRemote.tbd
Music_INSTALL_PATH = /Library/Curago/Widgets/

include $(THEOS_MAKE_PATH)/bundle.mk
