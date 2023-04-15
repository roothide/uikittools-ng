#include <CoreFoundation/CFString.h>
#include <CoreFoundation/CoreFoundation.h>

CFTypeRef MGCopyAnswer(CFStringRef);

int serial(void) {
	CFStringRef serialRef = MGCopyAnswer(CFSTR("SerialNumber"));
	printf("%s\n", CFStringGetCStringPtr(serialRef, kCFStringEncodingASCII));
	CFRelease(serialRef);
	return 0;
}
