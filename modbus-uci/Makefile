# $Id$

include $(TOPDIR)/rules.mk

PKG_NAME:=modbus-uci
PKG_VERSION:=0.8
PKG_RELEASE:=3

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)
PKG_BUILD_DEPENDS:=libmodbus

include $(INCLUDE_DIR)/package.mk

define Package/modbus-uci/default
  SECTION:=net
  CATEGORY:=Network
  TITLE:=modbus-uci gateway
  DEPENDS:=+libmodbus +libuci
endef

define Package/modbus-uci
  $(Package/modbus-uci/default)
  MENU:=1
endef

define Package/modbus-uci/description
 modbus-uci-gateway
 use libmodbus https://github.com/stephane/libmodbus
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Package/bacnet-stack/postinst
#!/bin/sh

[ -n $${IPKG_INSTROOT} ] || {
	/etc/init.d/modbus enable
	/etc/init.d/modbus restart
}
endef

define Package/modbus-uci/install
	$(INSTALL_DIR) $(1)/etc/init.d $(1)/etc/config $(1)/etc/uci-defaults
	$(INSTALL_DATA) ./files/modbus.config $(1)/etc/config/modbus
	$(INSTALL_BIN) ./files/modbus.init $(1)/etc/init.d/modbus
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/modbus-uci $(1)/usr/sbin/modbus-uci
endef

$(eval $(call BuildPackage,modbus-uci))

