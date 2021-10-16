#include <err.h>
#include <getopt.h>
#include <stdlib.h>
#include <stdio.h>
#include <CoreFoundation/CoreFoundation.h>
#include <Foundation/Foundation.h>

void usage() {
	printf(
		"Usage: uialert [-b body] [-p primary] [-s second] [-t third] [--timeout seconds] title\n"
		"Copyright (C) 2021, Procursus Team. All Rights Reserved.\n\n"
		"Display an alert\n\n"

		"  -b, --body <text>        Text for alert body\n"
		"  -p, --primary <text>     Default button text instead of \"OK\"\n"
		"  -s, --secondary <text>   Second button text\n"
		"  -t, --tertiary <text>    Third button text\n"
		"      --timeout <num>      Number of seconds to wait before exiting (0-120)\n\n"
		"Output:\n"
		"  0 - primary button\n"
		"  1 - secondary button\n"
		"  2 - tertiary button\n"
		"  3 - timeout/cancel\n\n"
		"Contact the Procursus Team for support.\n");
	exit(1);
}

int main(int argc, char **argv)
{
	CFOptionFlags cfRes;
	double timeout = 0;
	char *message = NULL;
	char *defaultButton = NULL;
	char *alternativeButton = NULL;
	char *otherButton = NULL;
	int ch;
	const char *errstr;

	static struct option longopts[] = {
		{ "body",	required_argument,	NULL,		'b' },
		{ "primary",	required_argument,	NULL,		'p' },
		{ "secondary",	required_argument,	NULL,		's' },
		{ "tertiary",	required_argument,	NULL,		't' },
		{ "timeout",	required_argument,	NULL,		0 },
		{ NULL,		0,			NULL, 		0 }
	};

	while ((ch = getopt_long(argc, argv, "b:p:s:t:", longopts, NULL)) != -1) {
		switch (ch) {
		case 'b':
			message = optarg;
			break;
		case 'p':
			defaultButton = optarg;
			break;
		case 's':
			alternativeButton = optarg;
			break;
		case 't':
			otherButton = optarg;
			break;
		case 0:
			timeout = strtonum(optarg, 0, 120, &errstr);
			if (errstr != NULL)
				errx(1, "the timout is %s: %s", errstr, optarg);
			break;
		default:
			usage();
		}
	}
	argc -= optind;
	argv += optind;

	if (argc != 1)
		usage();

	if (argv[0] == NULL)
		usage();

	CFUserNotificationDisplayAlert(timeout, kCFUserNotificationNoteAlertLevel,
				NULL, NULL, NULL,
				(__bridge CFStringRef)[NSString stringWithUTF8String:argv[0]],
				message == NULL ? NULL : (__bridge CFStringRef)[NSString stringWithUTF8String:message],
				defaultButton == NULL ? NULL : (__bridge CFStringRef)[NSString stringWithUTF8String:defaultButton],
				alternativeButton == NULL ? NULL : (__bridge CFStringRef)[NSString stringWithUTF8String:alternativeButton],
				otherButton == NULL ? NULL : (__bridge CFStringRef)[NSString stringWithUTF8String:otherButton],
				&cfRes);
	printf("%lu\n", cfRes);
	return 0;
}
