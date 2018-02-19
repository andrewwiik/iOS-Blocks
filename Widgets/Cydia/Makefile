include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Cydia
Cydia_BUNDLE_NAME = com.iosblocks.cydia
Cydia_BUNDLE_EXTENSION = block
Cydia_CFLAGS =  -fobjc-arc -I./Progress
Cydia_FILES = $(wildcard Progress/*.m) $(wildcard *.m)
Cydia_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore
Cydia_LDFLAGS = $(THEOS)/vendor/lib/libsubstrate.tbd
Cydia_INSTALL_PATH = /Library/Curago/Widgets/

include $(THEOS_MAKE_PATH)/bundle.mk
