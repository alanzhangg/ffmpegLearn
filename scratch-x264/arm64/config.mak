SRCPATH=../../x264
prefix=/Users/zyyk-ioskf1/Desktop/demos/ffmpegLearn/thin-x264/arm64
exec_prefix=${prefix}
bindir=${exec_prefix}/bin
libdir=${exec_prefix}/lib
includedir=${prefix}/include
SYS_ARCH=AARCH64
SYS=MACOSX
CC=xcrun -sdk iphoneos clang
CFLAGS=-Wshadow -O3 -ffast-math  -Wall -I. -I$(SRCPATH) -arch arm64 -mios-version-min=9.0 -std=gnu99 -D_GNU_SOURCE -fPIC -fomit-frame-pointer -fno-tree-vectorize
COMPILER=GNU
COMPILER_STYLE=GNU
DEPMM=-MM -g0
DEPMT=-MT
LD=xcrun -sdk iphoneos clang -o 
LDFLAGS= -arch arm64 -mios-version-min=9.0 -lm -lpthread -ldl
LIBX264=libx264.a
AR=ar rc 
RANLIB=ranlib
STRIP=strip
INSTALL=install
AS=
ASFLAGS= -I. -I$(SRCPATH) -arch arm64 -mios-version-min=9.0 -DPREFIX -DPIC -DSTACK_ALIGNMENT=16
RC=
RCFLAGS=
EXE=
HAVE_GETOPT_LONG=1
DEVNULL=/dev/null
PROF_GEN_CC=-fprofile-generate
PROF_GEN_LD=-fprofile-generate
PROF_USE_CC=-fprofile-use
PROF_USE_LD=-fprofile-use
HAVE_OPENCL=yes
CC_O=-o $@
SOSUFFIX=dylib
SONAME=libx264.157.dylib
SOFLAGS=-shared -dynamiclib -Wl,-single_module -Wl,-read_only_relocs,suppress -install_name $(DESTDIR)$(libdir)/$(SONAME) 
default: lib-shared
install: install-lib-shared
default: lib-static
install: install-lib-static
LDFLAGSCLI = 
CLI_LIBX264 = $(LIBX264)
