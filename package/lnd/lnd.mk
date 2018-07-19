LND_VERSION = 0.4.2-beta
LND_SITE = $(call github,lightningnetwork,lnd,v$(LND_VERSION))
LND_LICENSE = BSD-3-Clause
LND_LICENSE_FILES = LICENSE

define LND_DEP
	$(GO_BIN) get -u github.com/golang/dep/cmd/dep
        #dep ensure -v
endef

define LND_BUILD_CMDS
	GOROOT=$(HOST_GO_ROOT) /home/vagrant/buildroot-2018.05/output/host/bin/go get -u github.com/golang/dep/cmd/dep

        $(foreach d,$(LND_BUILD_TARGETS),\
                cd $(LND_SRC_PATH); $(GO_TARGET_ENV) GOPATH="$(@D)/$(LND_WORKSPACE)" /home/vagrant/go/bin/dep ensure -v
                cd $(LND_SRC_PATH); \
                $(GO_TARGET_ENV) \
                        GOPATH="$(@D)/$(LND_WORKSPACE)" \
                        $(LND_GO_ENV) \
                        $(GO_BIN) build -v -ldflags "-s -w" \
                        -o $(@D)/bin/$(or $(LND_BIN_NAME),$(notdir $(d))) \
                        ./$(d)
        )
endef

$(eval $(golang-package))
