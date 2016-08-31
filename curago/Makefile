# THEOS_PACKAGE_DIR_NAME = debs
# TARGET = simulator:clang:latest:10.0
# ARCHS = x86_64
GO_EASY_ON_ME = 1
# FINALPACKAGE = 1
# THEOS_DEVICE_IP = 192.168.33.112
# THEOS_DEVICE_PORT=22
# HOPPN_USE_SUBSTRATE = 0
Curago_CFLAGS = -fobjc-arc
SBWDXPlaceholderIcon.xm_CFLAGS = -fno-objc-arc

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Curago
Curago_FILES = $(wildcard *.xm) $(wildcard *.m) $(wildcard Progress/*.m)
Curago_FRAMEWORKS = UIKit CoreGraphics QuartzCore Foundation MobileCoreServices CoreImage AudioToolbox

# HOPPN_PRIVATE_FRAMEWORKS = MobileWiFi

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += ../Settings/curago/curago
include $(THEOS_MAKE_PATH)/aggregate.mk