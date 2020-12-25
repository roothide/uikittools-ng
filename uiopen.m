#include <stdio.h>
#import <getopt.h>
#include <dlfcn.h>
#include <Foundation/Foundation.h>

@interface LSApplicationWorkspace : NSObject
+ (id)defaultWorkspace;
- (BOOL)openSensitiveURL:(NSURL *)url withOptions:(NSDictionary *)options;
- (BOOL)openApplicationWithBundleID:(NSString *)bundleId;
@end

void help(char *name) {
	printf(
		"Usage: %s [OPTION...]\n"
		"Open URLs and open iOS applications by bundle ID\n\n"

		"  <URL>           Open the specified URL\n"
		"                     (replicates the old uiopen behavior)\n"
		"  --url <URL>     Open the specified URL\n"
		"  --bundleid <id> Open iOS application with the\n"
		"                     specified bundle id.\n"
		"  --help          Give this help list.\n", name);
}

int main(int argc, char *argv[]) {
    char *url = NULL;
    char *bundleId = NULL;
    int showhelp = 0;

    struct option longOptions[] = {
        { "url" , required_argument, 0, 'u'},
        { "bundleid", required_argument, 0, 'b'},
        { "help", no_argument, 0, 'h' },
        { NULL, 0, NULL, 0 }
    };

    int index = 0, code = 0;

    int opterr = 0; // silence getopt errors, allow us to replicate old behaviour

    while ((code = getopt_long(argc, argv, "u:b:h", longOptions, &index)) != -1) {
        switch (code) {
            case 'u':
                url = strdup(optarg);
                break;
            case 'b':
                bundleId = strdup(optarg);
                break;
            case 'h':
                showhelp = 1;
                break;
        }
    }

    if (argc == 1) {
        help(argv[0]);
        return 1;
    }

    // replicate old behaviour
    if (!url && !bundleId && !showhelp) {
        url = strdup(argv[1]);
    }

    if (showhelp == 1) {
        help(argv[0]);
    }
    else if (url) {
        NSURL *urlObj = [NSURL URLWithString:[NSString stringWithUTF8String:url]];

        void *fbs = dlopen("/System/Library/PrivateFrameworks/FrontBoardServices.framework/FrontBoardServices", RTLD_NOW);
        NSString **FBSOpenApplicationOptionKeyUnlockDevice = dlsym(fbs, "FBSOpenApplicationOptionKeyUnlockDevice");
        [[LSApplicationWorkspace defaultWorkspace] openSensitiveURL:urlObj withOptions:@{*FBSOpenApplicationOptionKeyUnlockDevice:@YES}];
    }
    else if (bundleId) {
        [[LSApplicationWorkspace defaultWorkspace] openApplicationWithBundleID:[NSString stringWithUTF8String:bundleId]];
    }
    return 0;
}
