TARGET = simulator:clang::12.0
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = JBHelloTweak
JBHelloTweak_FILES = Tweak.x
JBHelloTweak_GENERATOR = internal
JBHelloTweak_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

# Apple Silicon sims SIGKILL stale signatures ("Invalid Page") — sign the
# final staged bytes last, per theos/simject community gotcha.
after-stage::
	codesign --force --sign - "$(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/JBHelloTweak.dylib"
