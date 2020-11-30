#import <UIKit/UIKit.h>

#define CGRectSetY(rect, y) CGRectMake(rect.origin.x, y, rect.size.width, rect.size.height)

@interface CSQuickActionsView : UIView
- (UIEdgeInsets)_buttonOutsets;
@property (nonatomic, retain) UIControl *flashlightButton;
@property (nonatomic, retain) UIControl *cameraButton;
@end

NSInteger ScreenRounded;
NSInteger BottomInset;
NSInteger AppDockRounded;
NSInteger StatusBarMode;

BOOL isHomeBarAutoHide;
BOOL isHomeBarSB;
BOOL isHomeBarLS;

BOOL isReachability;
BOOL isBatteryPercent;
BOOL isStaticColor;
BOOL isHideChargingIndicator;
BOOL isHideStockPercentage;
BOOL isStockPercentCharging;
BOOL isLSShortcuts;
BOOL isNoBreadcum;
BOOL isXCombination;
BOOL isCCStatusbar;
BOOL isReduceRows;

BOOL isHigherKeyboard;
BOOL isNoSwipeKB;
BOOL isNoGesturesKB;
BOOL isNonLatin;

BOOL isMiniatureGesture;

BOOL isNoDockBackgroud;
BOOL isMakeSBClean;
BOOL isSwipeScreenshot;

//Handle Preferences:
static BOOL boolValueForKey(NSString *key, NSDictionary const *prefs) {
    return [[prefs objectForKey:key] boolValue];
}

static int intValueForKey(NSString *key, NSDictionary const *prefs) {
    return [[prefs objectForKey:key] integerValue];
}

static void updatePrefs() {
    @autoreleasepool {
        NSString *path = @"/User/Library/Preferences/com.hius.Gesturesi11Prefs.plist";
        NSString *pathDefault = @"/Library/PreferenceBundles/Gesturesi11Prefs.bundle/defaults.plist";
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:path]) {
            [fileManager copyItemAtPath:pathDefault toPath:path error:nil];
        }
        NSDictionary const *prefs = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.hius.Gesturesi11Prefs.plist"];
        if(prefs) {
            StatusBarMode = intValueForKey(@"statusBarMode", prefs);
            ScreenRounded = intValueForKey(@"screenRounded", prefs);
            AppDockRounded = intValueForKey(@"appDockRounded", prefs);
            BottomInset = intValueForKey(@"bottomInset", prefs);
            isCCStatusbar = boolValueForKey(@"ccStatusBar", prefs);
            isHomeBarAutoHide = boolValueForKey(@"homeBarAutoHide", prefs);
            isHomeBarSB = boolValueForKey(@"homeBarSB", prefs);
            isHomeBarLS = boolValueForKey(@"homeBarLS", prefs);
            isLSShortcuts = boolValueForKey(@"lsShortcuts", prefs);
            isNoBreadcum = boolValueForKey(@"noBreadcum", prefs);
            isReachability = boolValueForKey(@"noReachability", prefs);
            isBatteryPercent = boolValueForKey(@"batteryPercent", prefs);
            isStaticColor = boolValueForKey(@"staticColor", prefs);
            isHideChargingIndicator = boolValueForKey(@"hideChargingIndicator", prefs);
            isHideStockPercentage = boolValueForKey(@"hideStockPercent", prefs);
            isStockPercentCharging = boolValueForKey(@"stockPercentCharging", prefs);
            isXCombination = boolValueForKey(@"xCombination", prefs);
            isReduceRows = boolValueForKey(@"reduceRows", prefs);
            isMiniatureGesture = boolValueForKey(@"minimalGestures", prefs);
            isHigherKeyboard =  boolValueForKey(@"highKeyboard", prefs);
            isNoSwipeKB = boolValueForKey(@"noSwipeKeyboard", prefs);
            isNonLatin = boolValueForKey(@"nonLatinKeyboard", prefs);
            isMakeSBClean = boolValueForKey(@"makeSBClean", prefs);
            isNoDockBackgroud = boolValueForKey(@"noDockBackground", prefs);
            isSwipeScreenshot = boolValueForKey(@"swipeScreenshot", prefs);
        }
    }
}