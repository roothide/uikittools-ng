#include <CoreFoundation/CoreFoundation.h>
#include <CoreFoundation/CFString.h>

CFStringRef MGCopyAnswer(CFStringRef string);

int handle_serial(void) {
	uint64_t serial;
	CFStringRef serialRef = MGCopyAnswer(CFSTR("SerialNumber"));
	printf("%s\n", CFStringGetCStringPtr(serialRef, kCFStringEncodingASCII));
	return 0;
}
