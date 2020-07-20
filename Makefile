ARCHS = arm64 arm64e
FINALPACKAGE = 1

export TARGET = iphone:13.3
export ADDITIONAL_CFLAGS = -DTHEOS_LEAN_AND_MEAN -fobjc-arc

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Gesturesi11
Gesturesi11_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += Gesturesi11Prefs

include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "sbreload"