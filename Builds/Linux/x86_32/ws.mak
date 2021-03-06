ifeq "$(X11BUILD)" "1"

ifeq "$(shell getconf LONG_BIT)" "32"
SYSTEM_LIBS = $(X11ROOT)/lib
else
# On 64-bit systems, 32-bit libraries are placed in /lib32.
SYSTEM_LIBS = $(X11ROOT)/lib32 
endif

WS_LIBS = -L$(SYSTEM_LIBS) -lX11 -lXau
WS_INC  = $(X11ROOT)/include
WS = X11

ifneq (,$(filter OGL,$(APIS)))
WS_LIBS += -lXxf86vm -lXext
WS_INC += /usr/include
endif

else
ifeq "$(EWSBUILD)" "1"

PLAT_CFLAGS += -DEWS
WS_LIBS = -lews
WS_INC =
WS=EWS
PLAT_LINK += -L"$(SDKDIR)/Builds/Linux/x86_32/Lib"

else
ifeq "$(DRMBUILD)" "1"

WS_LIBS = -L$(DRMROOT)/lib -ldrm -lgbm -ludev -ldl -Wl,--rpath-link,$(DRMROOT)/lib
WS_INC = $(DRMROOT)/include $(DRMROOT)/include/libdrm $(DRMROOT)/include/gbm
WS=DRM

else
   ifeq "$(WAYLANDBUILD)" "1"

    WS_LIBS = -L$(WAYLANDROOT)/lib -lwayland-egl -lwayland-client -lffi
    WS_INC  = $(WAYLANDROOT)/include
    WS = Wayland
    PLAT_CFLAGS += -DWAYLAND
    WS_INC += /usr/include
else
WS_LIBS =
WS_INC  =
WS = NullWS
endif
endif
endif
endif
PLAT_LINK += $(WS_LIBS)
PLAT_INC  += $(WS_INC)
