CC ?= xcrun -sdk iphoneos clang -arch arm64 -miphoneos-version-min=11.0
CFLAGS ?=
LDFLAGS ?=

STRIP ?= strip
LDID ?= ldid

ALL := cfversion ecidecid gssc ldrestart sbdidlaunch sbreload uicache uiduid uiopen

sign: $(ALL)
	$(STRIP) $(ALL)
	$(LDID) -Sent.plist cfversion ecidecid ldrestart sbdidlaunch uiduid
	$(LDID) -Sgssc.plist gssc
	$(LDID) -Ssbreload.plist sbreload
	$(LDID) -Suicache.plist uicache
	$(LDID) -Suiopen.plist uiopen

all: sign

cfversion: cfversion.c ent.plist
	$(CC) -O3 $(CFLAGS) cfversion.c -o cfversion $(LDFLAGS) -framework CoreFoundation

ecidecid: ecidecid.m ent.plist
	$(CC) -fobjc-arc -O3 $(CFLAGS) ecidecid.m -o ecidecid $(LDFLAGS) -framework CoreFoundation -lMobileGestalt

gssc: gssc.m gssc.plist
	$(CC) -fobjc-arc -O3 $(CFLAGS) gssc.m -o gssc $(LDFLAGS) -framework Foundation -lMobileGestalt
	
ldrestart: ldrestart.c ent.plist
	$(CC) -O3 $(CFLAGS) ldrestart.c -o ldrestart $(LDFLAGS)

sbdidlaunch: sbdidlaunch.c ent.plist
	$(CC) -O3 $(CFLAGS) sbdidlaunch.c -o sbdidlaunch $(LDFLAGS) -framework CoreFoundation

sbreload: sbreload.m sbreload-launchd.c sbreload.plist
	$(CC) -fobjc-arc -O3 $(CFLAGS) sbreload.m sbreload-launchd.c -o sbreload $(LDFLAGS) -framework Foundation

uicache: uicache.m uicache.plist
	$(CC) -fobjc-arc -O3 $(CFLAGS) uicache.m -o uicache -framework Foundation $(LDFLAGS) -framework MobileCoreServices

uiduid: uiduid.m ent.plist
	$(CC) -fobjc-arc -O3 $(CFLAGS) uiduid.m -o uiduid $(LDFLAGS) -framework Foundation -lMobileGestalt

uiopen: uiopen.m ent.plist
	$(CC) -fobjc-arc -O3 $(CFLAGS) uiopen.m -o uiopen $(LDFLAGS) -framework Foundation -framework MobileCoreServices

clean:
	rm -f cfversion ecidecid gssc ldrestart sbdidlaunch sbreload uicache uiduid uiopen
