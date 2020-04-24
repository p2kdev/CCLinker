#import <Preferences/Preferences.h>
#import "SparkAppListTableViewController.h"

#define cclinkerPath @"/User/Library/Preferences/com.imkpatil.cclinker.plist"

@interface CCLinkerListController : PSListController
// - (void)visitPaypal;
// - (void)visitTwitter;
- (void)respring;
@end

@implementation CCLinkerListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"CCLinker" target:self] retain];
	}
	return _specifiers;
}

-(id) readPreferenceValue:(PSSpecifier*)specifier {
    NSDictionary *cclinkersettings = [NSDictionary dictionaryWithContentsOfFile:cclinkerPath];
    if (!cclinkersettings[specifier.properties[@"key"]]) {
        return specifier.properties[@"default"];
    }
    return cclinkersettings[specifier.properties[@"key"]];
}

-(void) setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:cclinkerPath]];
    [defaults setObject:value forKey:specifier.properties[@"key"]];
    [defaults writeToFile:cclinkerPath atomically:YES];
    //  NSDictionary *powercolorSettings = [NSDictionary dictionaryWithContentsOfFile:powercolorPath];
    CFStringRef toPost = (CFStringRef)specifier.properties[@"PostNotification"];
    if(toPost) CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
}

- (void)selectMusicWidgetApp {
    SparkAppListTableViewController* s = [[SparkAppListTableViewController alloc] initWithIdentifier:@"com.imkpatil.cclinker" andKey:@"musicAppID"];

    [self.navigationController pushViewController:s animated:YES];
    self.navigationItem.hidesBackButton = FALSE;
}

// - (void)visitPaypal {
// 	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://paypal.me/patilkiran08/5"]];
// }
// 
// - (void)visitTwitter {
//   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/imkpatil"]];
// }

- (void)respring {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.imkpatil.cclinker.respring"), NULL, NULL, YES);
		//[(SpringBoard *)[UIApplication sharedApplication] _relaunchSpringBoardNow];
		// #pragma GCC diagnostic push
		// #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    // system("cd /var/mobile/Library/Caches/com.apple.UIStatusBar; rm -R -f images; rm -f version; killall -9 SpringBoard");  //clears status bar cache + respring.
		// #pragma GCC diagnostic pop
}

@end



// vim:ft=objc
