#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#include <spawn.h>

@interface Gesturesi11RootListController : PSListController
@property (nonatomic, retain) UIBarButtonItem *respringButton;
- (void)respring:(id)sender;
@end

@implementation Gesturesi11RootListController
- (instancetype)init {
    self = [super init];
    if (self) {
        self.respringButton = [[UIBarButtonItem alloc] initWithTitle:@"Respring"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(respring:)];
        self.respringButton.tintColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1.0];
        self.navigationItem.rightBarButtonItem = self.respringButton;

    }
    return self;
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}
	return _specifiers;
}

- (void)respring:(id)sender {
    pid_t pid;
    const char* args[] = {"sbreload", NULL};
    posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char* const*)args, NULL);
}

-(void)openTwitter:(id)arg1 {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/helios017"] options:@{} completionHandler:nil];
}
-(void)openPayPal:(id)arg1 {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://paypal.me/hius017"] options:@{} completionHandler:nil];
}

- (id)readPreferenceValue:(PSSpecifier*)specifier {
    NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
    return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
    NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
    [settings setObject:value forKey:specifier.properties[@"key"]];
    [settings writeToFile:path atomically:YES];
    CFStringRef notificationName = (__bridge CFStringRef)specifier.properties[@"PostNotification"];
    if (notificationName) {
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), notificationName, NULL, NULL, YES);
    }
}
@end