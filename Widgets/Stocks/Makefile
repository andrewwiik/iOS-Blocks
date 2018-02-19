include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Stocks
Stocks_BUNDLE_NAME = com.iosblocks.stocks
Stocks_BUNDLE_EXTENSION = block
Stocks_CFLAGS =  -fobjc-arc
Stocks_FILES = $(wildcard *.m) $(wildcard IBKTableView/*.m)
Stocks_FRAMEWORKS = Foundation UIKit CoreGraphics QuartzCore
Stocks_LDFLAGS = $(THEOS)/vendor/lib/libsubstrate.tbd ./Stocks.tbd
Stocks_INSTALL_PATH = /Library/Curago/Widgets/

include $(THEOS_MAKE_PATH)/bundle.mk
