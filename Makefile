CC = xcrun -sdk iphoneos clang -arch arm64 -miphoneos-version-min=11.0
STRIP = strip
LDID = ldid

all: cfversion gssc ldrestart sbdidlaunch sbreload uicache uiduid uiopen

cfversion: cfversion.c ent.plist
	$(CC) cfversion.c -o cfversion -framework CoreFoundation -O3 $(CFLAGS)
	$(STRIP) cfversion
	$(LDID) -Sent.plist cfversion

gssc: gssc.m gssc.plist
	$(CC) gssc.m -o gssc -framework Foundation -lMobileGestalt -O3 $(CFLAGS)
	$(STRIP) gssc
	$(LDID) -Sgssc.plist gssc

ldrestart: ldrestart.c ent.plist
	$(CC) ldrestart.c -o ldrestart -O3 $(CFLAGS)
	$(STRIP) ldrestart
	$(LDID) -Sent.plist ldrestart

sbdidlaunch: sbdidlaunch.c ent.plist
	$(CC) sbdidlaunch.c -o sbdidlaunch -framework CoreFoundation -O3 $(CFLAGS)
	$(STRIP) sbdidlaunch
	$(LDID) -Sent.plist sbdidlaunch

sbreload: sbreload.m sbreload-launchd.c sbreload.plist
	$(CC) sbreload.m sbreload-launchd.c -o sbreload -framework Foundation -fobjc-arc -O3 $(CFLAGS)
	$(STRIP) sbreload
	$(LDID) -Ssbreload.plist sbreload

uicache: uicache.m uicache.plist
	$(CC) uicache.m -o uicache -framework Foundation -framework MobileCoreServices -fobjc-arc -O3 $(CFLAGS)
	$(STRIP) uicache
	$(LDID) -Suicache.plist uicache

uiduid: uiduid.m ent.plist
	$(CC) uiduid.m -o uiduid -framework Foundation -lMobileGestalt -fobjc-arc -O3 $(CFLAGS)
	$(STRIP) uiduid
	$(LDID) -Sent.plist uiduid

uiopen: uiopen.m ent.plist
	$(CC) uiopen.m -o uiopen -framework Foundation -framework MobileCoreServices -O3 $(CFLAGS)
	$(STRIP) uiopen
	$(LDID) -Suiopen.plist uiopen

clean:
	rm -f cfversion	gssc ldrestart sbdidlaunch sbreload uicache uiduid uiopen
