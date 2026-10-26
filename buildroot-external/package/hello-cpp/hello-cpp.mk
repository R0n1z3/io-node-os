################################################################################
#
# hello-cpp
#
################################################################################

HELLO_CPP_SITE = $(BR2_EXTERNAL_IO_NODE_PATH)/../../embedded-linux-industrial
HELLO_CPP_SITE_METHOD = local
HELLO_CPP_OVERRIDE_SRCDIR_RSYNC_EXCLUSIONS = --exclude /build

define HELLO_CPP_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) CROSS_COMPILE=$(TARGET_CROSS) build/app-cpp-arm
endef

define HELLO_CPP_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/build/app-cpp-arm $(TARGET_DIR)/usr/bin/hello-cpp
endef

$(eval $(generic-package))
