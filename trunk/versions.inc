FIRMWARE_ROOTFS_VER=3.9
FIRMWARE_BUILDS_VER=116
FIRMWARE_BUILDS_REV=$(shell git rev-parse --short HEAD 2>/dev/null)
FIRMWARE_BUILDS_TIME=$(shell LC_ALL=C date 2>/dev/null)
FIRMWARE_BUILDS_TIME2=$(shell date +%Y%m%d%H%M 2>/dev/null)
