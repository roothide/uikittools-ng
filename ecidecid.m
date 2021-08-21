#import <CoreFoundation/CoreFoundation.h>

CFNumberRef MGCopyAnswer(CFStringRef string);

int main() {
	uint64_t ecid;
	CFNumberRef ecidRef = MGCopyAnswer(CFSTR("UniqueChipID"));
	CFNumberGetValue(ecidRef, kCFNumberSInt64Type, &ecid);
	printf("0x%llX\n", ecid);
	return 0;
}
