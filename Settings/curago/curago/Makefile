GO_EASY_ON_ME = 1
THEOS_BUILD_DIR = test
SHARED_CFLAGS = -fobjc-arc
CFLAGS = -fobjc-arc
ADDITIONAL_OBJCFLAGS = -fobjc-arc
include $(THEOS)/makefiles/common.mk
THEOS_BUILD_DIR = test
BUNDLE_NAME = curago
curago_FILES = $(wildcard *.m)
curago_INSTALL_PATH = /Library/PreferenceBundles
curago_FRAMEWORKS = UIKit MobileCoreServices CoreGraphics SafariServices QuartzCore CoreImage MessageUI
curago_LDFLAGS += ./Preferences.tbd ./SpringBoardServices.tbd
curago_LIBRARIES = MobileGestalt
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
