export ARCHS = armv7 arm64
export TARGET = iphone:clang:latest:latest

include theos/makefiles/common.mk

TWEAK_NAME = WhitelistSwitcher
WhitelistSwitcher_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += whitelistswitcher
include $(THEOS_MAKE_PATH)/aggregate.mk
