SDK_IPHONEOS_PATH = /Applications/Xcode11.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk
XCODE_TOOLCHAIN_PATH = /Applications/Xcode11.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin

CC := $(XCODE_TOOLCHAIN_PATH)/clang
AR := $(XCODE_TOOLCHAIN_PATH)/ar

ARCHS = -arch armv7 -arch armv7s -arch arm64 -arch arm64e

CFLAGS = $(ARCHS) -isysroot $(SDK_IPHONEOS_PATH) -miphoneos-version-min=9.0

#======================================

NAME = lua

TARGET = lib$(NAME).a

COPY_LIB_TO = ../../lib

CFLAGS += -Wno-string-plus-int -fembed-bitcode -DLUA_USE_MACOSX # We need -DLUA_USE_MACOSX to enable io.popen

SRC = $(wildcard *.c)

OBJS = $(SRC:.c=.o)

$(TARGET): $(OBJS)
	@$(AR) rcs $@ $^

.c.o:
	$(info ==> Compiling $<)
	@$(CC) $(CFLAGS) -o $@ -c $<

.PHONY: install clean

install:
	install -m644 $(TARGET) $(COPY_LIB_TO)

clean:
	$(info ==> Cleanning $<)
	@rm -f $(OBJS) $(TARGET)
