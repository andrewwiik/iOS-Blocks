# THEOS_PACKAGE_DIR_NAME = debs
# GO_EASY_ON_ME = 1
# ARCHS = armv7 arm64
Curago_CFLAGS = -fobjc-arc -I../headers -Wno-deprecated-declarations
Simulator = 0

ifeq ($(SIMULATOR),1)
	TARGET = simulator:clang:latest:7.0
	ARCHS = x86_64
else
	TARGET = iphone:latest
	ARCHS = armv7 arm64
endif

include $(THEOS)/makefiles/common.mk
TWEAK_NAME = Curago
Curago_FILES = $(wildcard *.m) $(wildcard Progress/*.m) $(wildcard *.xm)
Curago_FRAMEWORKS = UIKit CoreGraphics QuartzCore Foundation MobileCoreServices CoreImage AudioToolbox
Curago_PRIVATE_FRAMEWORKS = BulletinBoard

# HOPPN_PRIVATE_FRAMEWORKS = MobileWiFi

include $(THEOS_MAKE_PATH)/tweak.mk

ifeq ($(THEOS_TARGET_NAME),iphone_simulator)
after-all::
	@echo Copying .dylib to /opt/simject
	@cp $(THEOS_OBJ_DIR)/Curago.dylib /opt/simject
	@cp Curago.plist /opt/simject
	@ldid -S /opt/simject/Curago.dylib
	@/usr/sbin/respring_simulator
endif


after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += ../Settings/curago/curago
include $(THEOS_MAKE_PATH)/aggregate.mk