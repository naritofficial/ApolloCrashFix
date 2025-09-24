TARGET := iphone:clang:latest:11.0
INSTALL_TARGET_PROCESSES = Apollo


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ApolloFix

ApolloFix_FILES = Tweak.x
ApolloFix_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
