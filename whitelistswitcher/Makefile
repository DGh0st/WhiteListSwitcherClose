include theos/makefiles/common.mk

BUNDLE_NAME = WhitelistSwitcher
WhitelistSwitcher_FILES = WhitelistSwitcher.mm
WhitelistSwitcher_INSTALL_PATH = /Library/PreferenceBundles
WhitelistSwitcher_FRAMEWORKS = UIKit MessageUI
WhitelistSwitcher_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/WhitelistSwitcher.plist$(ECHO_END)
