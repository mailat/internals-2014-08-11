#inherit from the emulator, much simpler structure
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_x86.mk)

PRODUCT_NAME := full_marakana_alpha
PRODUCT_DEVICE := alpha
PRODUCT_MODEL := Full Marakana Alpha Image made for Emulator
#PRODUCT_BRAND := Android_Marakana
#PRODUCT_MANUFACTURER := Marakana

#include the common.mk for "global variables"
include $(LOCAL_PATH)/common.mk

