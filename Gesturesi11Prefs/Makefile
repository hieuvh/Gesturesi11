include $(THEOS)/makefiles/common.mk

ARCHS = arm64 arm64e

BUNDLE_NAME = Gesturesi11Prefs

Gesturesi11Prefs_FILES = $(wildcard *.m)
Gesturesi11Prefs_INSTALL_PATH = /Library/PreferenceBundles
Gesturesi11Prefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Gesturesi11Prefs.plist$(ECHO_END)