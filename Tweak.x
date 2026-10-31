// JBHelloTweak — proof-of-life tweak for the iOS 27 simulator jailbreak.
// Uses logos' internal hook generator so the .deb needs no Substrate runtime
// (fine on the sim, where the loader ships its own shims anyway).

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static void JBHelloNote(const char *what) {
    @autoreleasepool {
        NSString *line = [NSString stringWithFormat:@"%@ %s (pid %d)\n",
                          [NSProcessInfo processInfo].processName,
                          what,
                          [[NSProcessInfo processInfo] processIdentifier]];
        NSString *path = @"/Users/spencer/jb-hello-proof.txt";
        NSFileHandle *fh = [NSFileHandle fileHandleForWritingAtPath:path];
        if (!fh) {
            [@"" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
            fh = [NSFileHandle fileHandleForWritingAtPath:path];
        }
        [fh seekToEndOfFile];
        [fh writeData:[line dataUsingEncoding:NSUTF8StringEncoding]];
        [fh closeFile];
        NSLog(@"[JBHelloTweak] %s", what);
    }
}

// Real logos hook — proves %hook/%orig codegen works against the sim SDK.
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
