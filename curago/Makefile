# THEOS_PACKAGE_DIR_NAME = debs
# TARGET = simulator:clang:latest:10.0
# ARCHS = x86_64
Curago_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Curago
Curago_FILES = $(wildcard *.m) $(wildcard Progress/*.m) $(wildcard *.xm)
Curago_FRAMEWORKS = UIKit CoreGraphics QuartzCore Foundation MobileCoreServices CoreImage AudioToolbox

# HOPPN_PRIVATE_FRAMEWORKS = MobileWiFi

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += ../Settings/curago/curago
include $(THEOS_MAKE_PATH)/aggregate.mk