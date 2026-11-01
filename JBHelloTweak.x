// JBHelloTweak — proof-of-life tweak for the iOS 27 jailbreak pipeline.
// Works on the jailbroken simulator (rootful) and on rootless devices: hooks go
// through logos' internal generator, resolved at runtime by whatever provides
// `mobilesubstrate`. No hardcoded jailbreak paths.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <TargetConditionals.h>

static void JBHelloNote(const char *what) {
    @autoreleasepool {
        NSLog(@"[JBHelloTweak] %s (pid %d)", what,
              [[NSProcessInfo processInfo] processIdentifier]);
#if TARGET_OS_SIMULATOR
        // The sim test loop verifies injection via this host-visible proof file.
        NSString *path = @"/Users/spencer/jb-hello-proof.txt";
        NSString *line = [NSString stringWithFormat:@"%s (pid %d)\n", what,
                          [[NSProcessInfo processInfo] processIdentifier]];
        NSFileHandle *fh = [NSFileHandle fileHandleForWritingAtPath:path];
        if (!fh) {
            [@"" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
            fh = [NSFileHandle fileHandleForWritingAtPath:path];
        }
        [fh seekToEndOfFile];
        [fh writeData:[line dataUsingEncoding:NSUTF8StringEncoding]];
        [fh closeFile];
#endif
    }
}

// Real logos hook — proves %hook/%orig codegen works against both SDKs.
%hook UIApplication
+ (UIApplication *)sharedApplication {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ JBHelloNote("hooked UIApplication"); });
    return %orig;
}
%end

%ctor {
    JBHelloNote("ctor ran — tweak injected");
}
