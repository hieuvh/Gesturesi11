#import "Tweak.h"

// Enable Gestures
%hook BSPlatform
- (NSInteger)homeButtonType {
    if (MiniatureGesturesEnabled) return %orig;
    return 2;
}
%end

//Mini Gestures
%group MiniatureGestures
static BOOL nopas = YES;
@interface CSPasscodeViewController
-(void)passcodeLockViewCancelButtonPressed:(id)arg1 ;
@end
//Fix Lock Appear Passcode
%hook CSPasscodeViewController
-(void)viewWillAppear:(BOOL)arg1 {
    %orig;
    if(nopas){
        [self passcodeLockViewCancelButtonPressed:nil];
        nopas = NO;
    }
}
%end
%hook SBControlCenterController
-(NSUInteger)presentingEdge {
    return 1;
}
%end
%hook CCSControlCenterDefaults
-(NSUInteger)_defaultPresentationGesture {
    return 1;
}
%end
%hook SBHomeGestureSettings
-(BOOL)isHomeGestureEnabled {
    return YES;
}
%end
%end
// LockScreen Shortcuts
%hook CSQuickActionsViewController
+ (BOOL)deviceSupportsButtons {
	return ShortcutsEnabled;
}
- (BOOL)hasCamera {
	return ShortcutsEnabled;
}
- (BOOL)hasFlashlight {
	return ShortcutsEnabled;
}
%end
%hook CSQuickActionsView
- (void)_layoutQuickActionButtons {
    CGRect const screenBounds = [UIScreen mainScreen].bounds;
    int const y = screenBounds.size.height - 70 - [self _buttonOutsets].top;
    [self flashlightButton].frame = CGRectMake(46, y, 46, 46);
	[self cameraButton].frame = CGRectMake(screenBounds.size.width - 96, y, 46, 46);
}
%end

//No Reachability == NO
%hook SBReachabilityManager
-(BOOL)gestureRecognizerShouldBegin:(id)arg1{
    return ReachabilityEnabled;
}
%end

//Battery Percent
%group BatteryPercentage
@interface _UIBatteryView : UIView
@property (nonatomic, copy, readwrite) UIColor *fillColor;
@end
%hook _UIBatteryView
-(void)setShowsPercentage:(BOOL)arg1 {
    %orig(YES);
}
-(UIColor *)bodyColor {
    if (StaticColor) return self.fillColor;
    return %orig;
}
-(UIColor *)pinColor {
    if (StaticColor) return self.fillColor;
    return %orig;
}
-(void)setShowsInlineChargingIndicator:(BOOL)arg1 {
    if(HideChargingIndicator) {
        arg1 = NO;
    }
    %orig(arg1);
}
%end
%hook _UIStatusBarStringView
-(void)setText:(NSString *)text {
    if ([text containsString:@"%"]) {
        if (HideStockPercentage) return;
        else if (StockPercentCharging) {
            if (!([[UIDevice currentDevice] batteryState]==2)) return;
            else %orig;
        }
        else %orig;
    }
    else %orig(text);
}
%end
%end

//HomeBar SB
%group HomeBar
%hook SBFHomeGrabberSettings
- (BOOL)isEnabled {
    return HomeBarSBEnabled;
}
%end
%end
// HomeBar Auto Hide
%group HomeBarAutoHide
%hook UIViewController
-(BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}
%end
%end
//No HomeBar LS
%group NoHomeBarLS
%hook CSTeachableMomentsContainerView
-(void)setHomeAffordanceContainerView:(UIView *)arg1 {
    return;
}
-(void)setHomeAffordanceView:(UIView *)arg1 {
    return;
}
%end
%end
// No HomeBar
%group NoHomeBar
%hook MTLumaDodgePillSettings
-(void)setHeight:(double)arg1 {
    return %orig(0);
}
%end
%end

//StatusBar Switch
%group SwitchStatusBar
%hook _UIStatusBarVisualProvider_iOS
+ (Class)class {
    if (StatusBarMode==3 || (ScreenRounded > 15 && StatusBarMode == 2))
        return NSClassFromString(@"_UIStatusBarVisualProvider_RoundedPad_ForcedCellular");
    if (StatusBarMode==2)
        return NSClassFromString(@"_UIStatusBarVisualProvider_Pad_ForcedCellular");
    return NSClassFromString(@"_UIStatusBarVisualProvider_Split58");
}
%end
%end

//StatusBar X Calibrate
%group StatusBarXCalibrate
%hook _UIStatusBarVisualProvider_Split58
+(double)height {
    return 20;
}
+(CGSize)notchSize{
    CGSize const notSize = %orig;
    return CGSizeMake(notSize.width, 18);
}
+(CGSize)pillSize {
    return CGSizeMake(48, 18);
}
%end
%end

// No CC StatusBar
%group NoCCStatusBar
%hook CCUIStatusBar
-(id)initWithFrame:(CGRect)arg1 {
    return NULL;
}
%end
//No Blurring Status Bar in CC
%hook CCUIHeaderPocketView
-(void)setBackgroundAlpha:(double)arg1 {
    %orig(0.0);
}
%end
%end

//Fix CC Status Bar Overlay
%hook CCUIModularControlCenterOverlayViewController
- (void)setOverlayStatusBarHidden:(BOOL)arg1 {
    if (StatusBarMode==0 || !CCStatusbarEnabled) return;
    %orig;
}
%end

//Fix CC StatusBar conflict
%group CCStatusBar
%hook CCUIHeaderPocketView
- (void)setFrame:(CGRect)frame {
    if (MiniatureGesturesEnabled) {
        if (StatusBarMode==3 || (ScreenRounded > 15 && StatusBarMode==2))
            %orig(CGRectSetY(frame, -11));
        else if (StatusBarMode==0)
            %orig(CGRectSetY(frame, -32));
        else
            %orig(CGRectSetY(frame, -15));
    }
    else {
        if(StatusBarMode==3 || (ScreenRounded > 15 && StatusBarMode==2))
            %orig(CGRectSetY(frame, -20));
        else if (StatusBarMode==0)
            %orig(CGRectSetY(frame, -40));
        else
            %orig(CGRectSetY(frame, -24));
    }
}
%end
%end

//No breadcum
%group NoBreadcum
%hook _UIStatusBarData
-(void)setBackNavigationEntry:(id)arg1 {
        return;
}
%end
%end

//Reduce Rows
%group ReduceRows
%hook SBIconListGridLayoutConfiguration
-(NSUInteger)numberOfPortraitRows {
    if (%orig < 4) return %orig;
    return 5;
}
%end
%end

//Default Keyboard
%group DefaultKeyboard
%hook UIKeyboardImpl
+(UIEdgeInsets)deviceSpecificPaddingForInterfaceOrientation:(NSInteger)arg1 inputMode:(id)arg2 {
    UIEdgeInsets const orig = %orig;
    if(!NonLatinEnabled) return UIEdgeInsetsMake(orig.top, 0, 0, 0);
    return UIEdgeInsetsMake(orig.top, orig.left, 0, orig.right);
}
%end
%end

//Higher Keyboard X
%group HigherKeyboard
%hook UIKeyboardImpl
+(UIEdgeInsets)deviceSpecificPaddingForInterfaceOrientation:(NSInteger)arg1 inputMode:(id)arg2 {
	UIEdgeInsets orig = %orig;
    orig.bottom = 48;
	if(!NonLatinEnabled){
        if (orig.left == 75) {
            orig.left = 0;
            orig.right = 0;
	    }
    }
	return orig;
}
%end
%hook UIKeyboardDockView
- (CGRect)bounds {
    CGRect bounds = %orig;
    if (bounds.origin.y == 0) {
        NSClassFromString(@"BarmojiCollectionView");
        bounds.origin.y -= 12;
    }
    return bounds;
}
%end
%end

// New Zoom and Flip controls
%group CamAppSet
%hook CAMFlipButton
-(BOOL)_useCTMAppearance {
    return YES;
}
%end
%hook CAMViewfinderViewController
-(BOOL)_shouldUseZoomControlInsteadOfSlider {
    return YES;
}
%end
%end

//No Gestures Keyboard
%hook SBHomeGesturePanGestureRecognizer
-(void)touchesBegan:(NSSet *)touches withEvent:(id)event {
    if (NoGesturesKeyboard) return;
    return %orig;
}
%end

// Modern Dock
%group AppDock
%hook UITraitCollection
- (CGFloat)displayCornerRadius {
    return AppDockRounded;
}
%end
%end

//RoundCorners
%group RoundCorners
@interface _UIRootWindow : UIView
@property (setter=_setContinuousCornerRadius:, nonatomic) double _continuousCornerRadius;
@end
%hook _UIRootWindow
-(id)initWithDisplay:(id)arg1 {
    %orig;
    self.clipsToBounds = YES;
    self._continuousCornerRadius = ScreenRounded;
    return self;
}
%end
%hook SBReachabilityBackgroundView
- (double)_displayCornerRadius {
    return ScreenRounded;
}
%end
%end

//Bottom Inset
%hook UIWindow
- (UIEdgeInsets)safeAreaInsets {
    UIEdgeInsets const x = %orig;
    return UIEdgeInsetsMake(x.top, x.left, BottomInset, x.right);
}
%end

// Original Buttons
%group OriginalButtons
%hook SBLockHardwareButtonActions
-(id)initWithHomeButtonType:(NSInteger)arg1 proximitySensorManager:(id)arg2 {
    return %orig(1, arg2);
}
%end
%hook SBHomeHardwareButtonActions
-(id)initWitHomeButtonType:(NSInteger)arg1 {
    return %orig(1);
}
%end

int applicationDidFinishLaunching;
%hook SpringBoard
-(void)applicationDidFinishLaunching:(id)application{
    applicationDidFinishLaunching = 2;
    %orig;
}
%end
%hook SBPressGestureRecognizer
- (void)setAllowedPressTypes:(NSArray *)arg1 {
    NSArray * lockHome = @[@104, @101];
    NSArray * lockVol = @[@104, @102, @103];
    if (applicationDidFinishLaunching == 2 && [arg1 isEqual:lockVol]) {
        %orig(lockHome);
        applicationDidFinishLaunching--;
        return;
    }
    %orig;
}
%end
%hook SBClickGestureRecognizer
- (void)addShortcutWithPressTypes:(id)arg1 {
    if (applicationDidFinishLaunching == 1) {
        applicationDidFinishLaunching--;
        return;
    }

    %orig;
}
%end
%hook SBHomeHardwareButton
- (id)initWithScreenshotGestureRecognizer:(id)arg1 homeButtonType:(NSInteger)arg2 {
    return %orig(arg1, 1);
}
%end
%hook SBLockHardwareButton
- (id)initWithScreenshotGestureRecognizer:(id)arg1 shutdownGestureRecognizer:(id)arg2 proximitySensorManager:(id)arg3 homeHardwareButton:(id)arg4 volumeHardwareButton:(id)arg5 buttonActions:(id)arg6 homeButtonType:(NSInteger)arg7 createGestures:(_Bool)arg8 {
    return %orig(arg1,arg2,arg3,arg4,arg5,arg6,1,arg8);
}
- (id)initWithScreenshotGestureRecognizer:(id)arg1 shutdownGestureRecognizer:(id)arg2 proximitySensorManager:(id)arg3 homeHardwareButton:(id)arg4 volumeHardwareButton:(id)arg5 homeButtonType:(NSInteger)arg6 {
    return %orig(arg1,arg2,arg3,arg4,arg5,1);
}
%end
%hook SBVolumeHardwareButton
- (id)initWithScreenshotGestureRecognizer:(id)arg1 shutdownGestureRecognizer:(id)arg2 homeButtonType:(NSInteger)arg3 {
    return %orig(arg1,arg2,1);
}
%end
%end

//Handle
%ctor {
    %init;
    updatePrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)updatePrefs, CFSTR("com.hius.Gesturesi11Prefs.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    bool const isSpringBoard = [@"SpringBoard" isEqualToString:[NSProcessInfo processInfo].processName];
    if (isSpringBoard) {
        if (StatusBarMode != 0) {
            %init(SwitchStatusBar);
            if (StatusBarMode == 1) %init(StatusBarXCalibrate);
        }
        if (MiniatureGesturesEnabled) %init (MiniatureGestures);
        if (NoBreadcumEnabled) %init(NoBreadcum);
        if (!XCombinationEnabled) %init(OriginalButtons);
        if (ReduceRowsEnabled) %init(ReduceRows);
        if (AppDockRounded > 5) %init(AppDock);
        if (ScreenRounded > 0) %init(RoundCorners);
        if (BatteryPercentEnabled) %init(BatteryPercentage);
        if (!CCStatusbarEnabled) %init(NoCCStatusBar);
        else %init(CCStatusBar);
    } else {
        NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        if ([bundleIdentifier isEqualToString:@"com.apple.camera"]) %init(CamAppSet);
        if ([bundleIdentifier isEqualToString:@"com.atebits.Tweetie2"]) BottomInset = 0;
        if ([bundleIdentifier isEqualToString:@"com.facebook.Facebook"]) BottomInset += 1;
    }
    if (HomeBarAutoHideEnabled) {
        HomeBarSBEnabled = YES;
        %init(HomeBarAutoHide);
    }
    if (!HomeBarLSEnabled) {
        %init(NoHomeBarLS);
        if (!HomeBarSBEnabled) %init(NoHomeBar);
    }
    else %init(HomeBar);
    if (HigherKeyboardEnabled) %init(HigherKeyboard);
    else %init(DefaultKeyboard);
    if (NoSwipeKBEnabled) {
        [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidShowNotification object:nil queue:nil usingBlock:^(NSNotification *n) {NoGesturesKeyboard = true;}];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification *n) {NoGesturesKeyboard = false;}];
    }
}