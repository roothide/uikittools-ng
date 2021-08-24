#import <CoreFoundation/CoreFoundation.h>

CFNumberRef MGCopyAnswer(CFStringRef string);

int handle_ecid(void) {
	uint64_t ecid;
	CFNumberRef ecidRef = MGCopyAnswer(CFSTR("UniqueChipID"));
	CFNumberGetValue(ecidRef, kCFNumberSInt64Type, &ecid);
	printf("0x%llX\n", ecid);
	return 0;
}
