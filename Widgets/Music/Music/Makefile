ARCHS = armv7 arm64

THEOS_BUILD_DIR = Packages

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Music
BUNDLE_AUTHOR = Matchstic
Music_BUNDLE_NAME = com.$(BUNDLE_AUTHOR).$(BUNDLE_NAME)
Music_BUNDLE_EXTENSION = block
Music_CFLAGS =  -fobjc-arc
Music_FILES = $(wildcard *.m)
Music_FRAMEWORKS = Foundation UIKit MediaPlayer CoreGraphics CoreImage QuartzCore
Music_PRIVATE_FRAMEWORKS = MediaRemote
Music_INSTALL_PATH = /var/mobile/Library/Curago/Widgets/

include $(THEOS_MAKE_PATH)/bundle.mk