include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Fitness
Fitness_BUNDLE_NAME = com.iosblocks.fitness
Fitness_BUNDLE_EXTENSION = block
Fitness_CFLAGS =  -fobjc-arc
Fitness_FILES = $(wildcard *.m)
Fitness_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore
Fitness_LDFLAGS = $(THEOS)/vendor/lib/libsubstrate.tbd -lsqlite3
Fitness_INSTALL_PATH = /Library/Curago/Widgets/

include $(THEOS_MAKE_PATH)/bundle.mk
