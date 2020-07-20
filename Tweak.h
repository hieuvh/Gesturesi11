#import <UIKit/UIKit.h>

#define CGRectSetY(rect, y) CGRectMake(rect.origin.x, y, rect.size.width, rect.size.height)
#define pREFS [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.hius.Gesturesi11Prefs.plist"]

@interface CSQuickActionsView : UIView
- (UIEdgeInsets)_buttonOutsets;
@property (nonatomic, retain) UIControl *flashlightButton;
@property (nonatomic, retain) UIControl *cameraButton;
@end

double ScreenRounded;
NSInteger BottomInset;
CGFloat AppDockRounded;
short StatusBarMode;

BOOL HomeBarAutoHideEnabled;
BOOL HomeBarSBEnabled;
BOOL HomeBarLSEnabled;

BOOL ReachabilityEnabled;
BOOL BatteryPercentEnabled;
BOOL StaticColor;
BOOL HideChargingIndicator;
BOOL HideStockPercentage;
BOOL StockPercentCharging;
BOOL ShortcutsEnabled;
BOOL NoBreadcumEnabled;
BOOL XCombinationEnabled;
BOOL CCStatusbarEnabled;
BOOL ReduceRowsEnabled;

BOOL HigherKeyboardEnabled;
BOOL NoSwipeKBEnabled;
BOOL NoGesturesKeyboard;
BOOL NonLatinEnabled;

BOOL MiniatureGesturesEnabled;

//Handle Preferences:
static BOOL boolValueForKey(NSString *key) {
    return [[pREFS objectForKey:key] boolValue];
}

static int intValueForKey(NSString *key) {
    return [[pREFS objectForKey:key] integerValue];
}

static void updatePrefs() {
    NSString *path = @"/User/Library/Preferences/com.hius.Gesturesi11Prefs.plist";
    NSString *pathDefault = @"/Library/PreferenceBundles/Gesturesi11Prefs.bundle/defaults.plist";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager copyItemAtPath:pathDefault toPath:path error:nil];
    }
    StatusBarMode = intValueForKey(@"statusBarMode");
    ScreenRounded = intValueForKey(@"screenRounded");
    AppDockRounded = intValueForKey(@"appDockRounded");
    BottomInset = intValueForKey(@"bottomInset");
    CCStatusbarEnabled = boolValueForKey(@"ccStatusBar");
    HomeBarAutoHideEnabled = boolValueForKey(@"homeBarAutoHide");
    HomeBarSBEnabled = boolValueForKey(@"homeBarSB");
    HomeBarLSEnabled = boolValueForKey(@"homeBarLS");
    ShortcutsEnabled = boolValueForKey(@"lsShortcuts");
    NoBreadcumEnabled = boolValueForKey(@"noBreadcum");
    ReachabilityEnabled = boolValueForKey(@"noReachability");
    BatteryPercentEnabled = boolValueForKey(@"batteryPercent");
    StaticColor = boolValueForKey(@"staticColor");
    HideChargingIndicator = boolValueForKey(@"hideChargingIndicator");
    HideStockPercentage = boolValueForKey(@"hideStockPercent");
    StockPercentCharging = boolValueForKey(@"stockPercentCharging");
    XCombinationEnabled = boolValueForKey(@"xCombination");
    ReduceRowsEnabled = boolValueForKey(@"reduceRows");
    MiniatureGesturesEnabled = boolValueForKey(@"minimalGestures");
    HigherKeyboardEnabled =  boolValueForKey(@"highKeyboard");
    NoSwipeKBEnabled = boolValueForKey(@"noSwipeKeyboard");
    NonLatinEnabled = boolValueForKey(@"nonLatinKeyboard");
}