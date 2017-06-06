# THEOS_PACKAGE_DIR_NAME = debs
# GO_EASY_ON_ME = 1
# ARCHS = armv7 arm64
export SIMULATOR = 0
Curago_CFLAGS = -fobjc-arc

ifeq ($(SIMULATOR),1)
	export TARGET = simulator:clang:latest:7.0
	export ARCHS = x86_64
else
	export TARGET = iphone:latest:7.0
	export ARCHS = armv7 arm64
endif

export ADDITIONAL_CFLAGS = -I$(THEOS_PROJECT_DIR)/../headers

TWEAK_NAME = Curago
Curago_FILES = $(wildcard *.m) $(wildcard Progress/*.m) $(wildcard *.xm)
Curago_FRAMEWORKS = UIKit CoreGraphics QuartzCore Foundation MobileCoreServices CoreImage AudioToolbox
Curago_LDFLAGS += ./BulletinBoard.tbd
# Curago_PRIVATE_FRAMEWORKS = BulletinBoard

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

ifeq ($(THEOS_TARGET_NAME),iphone_simulator)
after-all::
	@echo Copying .dylib to /opt/simject
	@cp $(THEOS_OBJ_DIR)/Curago.dylib /opt/simject
	@cp Curago.plist /opt/simject
	@ldid -S /opt/simject/Curago.dylib
endif


after-install::
	install.exec "killall -9 SpringBoard"

ifeq ($(SIMULATOR),0)
SUBPROJECTS += ../Settings/curago/curago
SUBPROJECTS += ../Widgets/Weather
SUBPROJECTS += ../Widgets/Stocks
SUBPROJECTS += ../Widgets/Music
SUBPROJECTS += ../Widgets/MobileTimer
SUBPROJECTS += ../Widgets/Calendar
SUBPROJECTS += ../Widgets/MobileSMS
SUBPROJECTS += ../Widgets/Fitness
SUBPROJECTS += ../Widgets/Cydia
SUBPROJECTS += ../Widgets/Camera
include $(THEOS_MAKE_PATH)/aggregate.mk
endif