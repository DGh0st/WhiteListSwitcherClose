export ARCHS = armv7 arm64
export TARGET = iphone:clang:latest:latest

PACKAGE_VERSION = 1.1

include theos/makefiles/common.mk

TWEAK_NAME = WhitelistSwitcher
WhitelistSwitcher_FILES = Tweak.xm
WhitelistSwitcher_LDFLAGS += -Wl,-segalign,4000
WhitelistSwitcher_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += whitelistswitcher
include $(THEOS_MAKE_PATH)/aggregate.mk
