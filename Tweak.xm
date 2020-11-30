#import "Tweak.h"
#include <sys/sysctl.h>

// Fix icons list ios 14
%group FixiOS14
%hook SBHDefaultIconListLayoutProvider
-(NSUInteger)screenType {
    CGFloat const screenHeight = UIScreen.mainScreen.bounds.size.height;
    if (screenHeight == 568) {
        return 0;
    } else if (screenHeight == 667) {
        return 1;
    } else if (screenHeight == 736) {
        return 2;
    }
    return %orig;
}
%end
%end

// Fix Alarm screen for Modern gesture on iOS 14
%hook CSFullscreenNotificationView
- (void)setFrame:(CGRect)frame {
    if (@available(iOS 14.0, *)) {
        %orig(CGRectSetY(frame, -44));
    }
}
%end

// Enable Gestures
%hook BSPlatform
- (long long)homeButtonType {
    if (isMiniatureGesture) return %orig;
    return 2;
}
%end

//Mini Gestures
%group MiniatureGesture
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
	return isLSShortcuts;
}
- (BOOL)hasCamera {
	return isLSShortcuts;
}
- (BOOL)hasFlashlight {
	return isLSShortcuts;
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
    return isReachability;
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
    if (isStaticColor) return self.fillColor;
    return %orig;
}
-(UIColor *)pinColor {
    if (isStaticColor) return self.fillColor;
    return %orig;
}
-(void)setShowsInlineChargingIndicator:(BOOL)arg1 {
    if(isHideChargingIndicator) {
        arg1 = NO;
    }
    %orig(arg1);
}
%end

%hook _UIStatusBarStringView
-(void)setText:(NSString *)text {
    if ([text containsString:@"%"]) {
        if (isHideStockPercentage) return;
        else if (isStockPercentCharging) {
            if (!([[UIDevice currentDevice] batteryState] == 2)) return;
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
    return isHomeBarSB;
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
%group LegacyStatusBar
%hook _UIStatusBarVisualProvider_iOS
+(Class)class {
    return NSClassFromString(@"_UIStatusBarVisualProvider_LegacyPhone");
}
%end
%end

%group iPhoneStatusBar
%hook _UIStatusBarVisualProvider_iOS
+(Class)class {
    if (StatusBarMode == 5) return NSClassFromString(@"_UIStatusBarVisualProvider_Split61");
    return NSClassFromString(@"_UIStatusBarVisualProvider_Split58");
}
%end
%end

%group iPadStatusBar
%hook _UIStatusBarVisualProvider_iOS
+(Class)class {
    if (StatusBarMode == 2 || (StatusBarMode == 1 && ScreenRounded > 15))
        return NSClassFromString(@"_UIStatusBarVisualProvider_RoundedPad_ForcedCellular");
    return NSClassFromString(@"_UIStatusBarVisualProvider_Pad_ForcedCellular");
}
%end
%end
// end

//StatusBar X Calibrate
%group StatusBarXCalibrate58
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

// Split 61 Calibrate
%group StatusBarXCalibrate61
%hook _UIStatusBarVisualProvider_Split61
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

// Fix StatusBar X:
%group StatusBarXFix
%hook SBIconListGridLayoutConfiguration
- (UIEdgeInsets)portraitLayoutInsets {
    UIEdgeInsets const x = %orig;
    NSUInteger const rows = MSHookIvar<NSUInteger>(self, "_numberOfPortraitRows");
    if (rows <= 3) return %orig;
    return UIEdgeInsetsMake(x.top+10, x.left, x.bottom, x.right);
}
%end
%end

%group FixInstagram
%hookf(int, sysctlbyname, const char *name, void *oldp, size_t *oldlenp, void *newp, size_t newlen) {
	if (strcmp(name, "hw.machine") == 0) {
        int ret = %orig;
        if (oldp) {
            const char *mechine1 = "iPhone12,1";
            strcpy((char *)oldp, mechine1);
        }
        return ret;
    } else {
        return %orig;
    }
}
%end

// Fix for Tiktok, ViettelPay, Instagram, Twitter
%group FixStatusBarInApp
%hook UIStatusBarManager
-(double)statusBarHeight {
    return 20;
}
%end
%end

// Fix Youtube
%group FixYouTube
%hook UIStatusBarManager
-(BOOL)isStatusBarHidden {
    return YES;
}
%end

%hook YTWrapperView
- (void)setFrame:(CGRect)frame {
    if (StatusBarMode == 3)
        %orig(CGRectSetY(frame, frame.origin.y + 10));
    else
        %orig;
}
%end

%hook YTSearchView
- (void)setFrame:(CGRect)frame {
    if (StatusBarMode == 3)
        %orig(CGRectSetY(frame, 40));
    else
        %orig(CGRectSetY(frame, 20));
}
%end
%end

// Fix Twitter
%group FixTwitter
%hook TFNNavigationBarOverlayView
- (void)setFrame:(CGRect)frame {
    if (StatusBarMode == 3) {
        %orig(CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + 6));
    } else {
        %orig;
    }
}
%end
%end
//end fix

// No CC StatusBar
%group NoCCStatusBar
%hook CCUIStatusBar
-(id)initWithFrame:(CGRect)arg1 {
    return nil;
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
    if (!isCCStatusbar || StatusBarMode == 0) return;
    %orig;
}
%end

// CC StatusBar Animate
%hook CCUIModularControlCenterOverlayViewController
- (void)dismissAnimated:(bool)arg1 withCompletionHandler:(id)arg2 {
    if (isCCStatusbar && (isMiniatureGesture || StatusBarMode == 0)) {
        arg1 = 0;
    }
    %orig;
}
%end

//Fix CC StatusBar conflict
%group CCStatusBar
%hook CCUIHeaderPocketView
- (void)setFrame:(CGRect)frame {
    if (!isMiniatureGesture) {
        if(StatusBarMode == 2 || (StatusBarMode == 1 && ScreenRounded > 15))
            %orig(CGRectSetY(frame, -20));
        else if (StatusBarMode==0)
            %orig(CGRectSetY(frame, -40));
        else if (StatusBarMode==3)
            %orig;
        else
            %orig(CGRectSetY(frame, -24));
    }
    %orig;
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
    if(!isNonLatin) return UIEdgeInsetsMake(orig.top, 0, 0, 0);
    return UIEdgeInsetsMake(orig.top, orig.left, 0, orig.right);
}
%end
%end

//Higher Keyboard X
%group HigherKeyboard
%hook UIKeyboardImpl
+(UIEdgeInsets)deviceSpecificPaddingForInterfaceOrientation:(NSInteger)arg1 inputMode:(id)arg2 {
	UIEdgeInsets const orig = %orig;
    if(!isNonLatin) return UIEdgeInsetsMake(orig.top, 0, 48, 0);
    return UIEdgeInsetsMake(orig.top, orig.left, 48, orig.right);
}
%end

%hook UIKeyboardDockView
- (CGRect)bounds {
    CGRect const bounds = %orig;
    return CGRectSetY(bounds, -15);
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
    if (isNoGesturesKB) return;
    return %orig;
}
%end

// Modern Dock
%hook UITraitCollection
- (CGFloat)displayCornerRadius {
    return AppDockRounded;
}
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
-(UIEdgeInsets)safeAreaInsets {
    UIEdgeInsets orig = %orig;
    if (@available(iOS 14.0, *)) {
        if (StatusBarMode != 3) {
            CGFloat const screenHeight = UIScreen.mainScreen.bounds.size.height;
            if (screenHeight >= 568 && screenHeight <= 736) {
                orig.top = 20;
            }
        }
    }
    orig.bottom = BottomInset;
    return orig;
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

%group MakeSBClean
// No Page Dot
%hook CSPageControl
-(id)initWithFrame:(struct CGRect)arg1 {
	return nil;
}
%end

// No App Labels
%hook SBMutableIconLabelImageParameters
-(void)setTextColor:(id)arg1 {
    %orig([UIColor clearColor]);
}
%end

// No Press/Swipe to Unlock Text
%hook SBUICallToActionLabel
-(id)initWithFrame:(struct CGRect)arg1 {
	return nil;
}
%end
%end

%group MakeSBClean13
// NoWidgetFooter
@interface WGWidgetAttributionView
@property (nonatomic, assign, readwrite, getter=isHidden) BOOL hidden;
@end

%hook WGWidgetAttributionView
-(void)didMoveToWindow {
    %orig;
    self.hidden = YES;
}
%end

%hook SBIconListPageControl
- (id)initWithFrame:(struct CGRect)arg1 {
	return nil;
}
%end
%end

%group MakeSBClean14
%hook _UIPageControlIndicatorContentView
-(id)initWithFrame:(struct CGRect)arg1 {
	return nil;
}
%end
%end

// No Dock Background : Normal Dock
%group NoNomalDockBG
%hook SBDockView
-(void)setBackgroundAlpha:(double)arg1 {
    %orig(0);
}
-(void)setBackgroundView:(UIView *)view {
    %orig;
    view.hidden = YES;
}
%end
%end

//Swipe To Screenshot
%group SwipeScreenshot
@interface UIWindow(SS)
@property (nonatomic, retain) UIPanGestureRecognizer *ssGestureRecognizer;
- (void)ssScreenshot;
@end

@interface UIStatusBar_Modern : UIWindow
@end

@interface SpringBoard
-(void)takeScreenshot;
@end

%hook UIStatusBar_Modern
%property (nonatomic, retain) UIPanGestureRecognizer *ssGestureRecognizer;
%new
-(void)ssScreenshot {
    if (self.ssGestureRecognizer.state != UIGestureRecognizerStateBegan) return;
    [(SpringBoard *)[UIApplication sharedApplication] takeScreenshot];
}

-(void)layoutSubviews {
    %orig;
    if (self.ssGestureRecognizer) return;
    self.ssGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(ssScreenshot)];
    self.ssGestureRecognizer.minimumNumberOfTouches = 2;
    self.ssGestureRecognizer.cancelsTouchesInView = YES;
    [self addGestureRecognizer:self.ssGestureRecognizer];
}
%end
%end

static bool appID(NSString *keyString) {
    return [[[NSBundle mainBundle] bundleIdentifier] isEqualToString:keyString];
}

//Handle
%ctor {
    @autoreleasepool {
        %init;
        updatePrefs();
        CFNotificationCenterAddObserver(
            CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)updatePrefs, 
            CFSTR("com.hius.Gesturesi11Prefs.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce
        );

        bool const isSpringBoard = [@"SpringBoard" isEqualToString:[NSProcessInfo processInfo].processName];
        if (isSpringBoard) {
            if (StatusBarMode != 0) {
                if (StatusBarMode == 1 || StatusBarMode == 2) {
                    %init(iPadStatusBar);
                } else {
                    %init(iPhoneStatusBar);
                    if (StatusBarMode == 5) {
                        if(@available(iOS 14.0, *))
                            StatusBarMode = 4;
                        else
                            %init(StatusBarXCalibrate61);
                    }
                    if (StatusBarMode == 4)
                        %init(StatusBarXCalibrate58);
                    else
                        %init(StatusBarXFix);
                }
            } else {
                %init(LegacyStatusBar);
            }
            if (isMiniatureGesture) {
                %init(MiniatureGesture);
            } else {
                if (@available(iOS 14.0, *)) {
                    %init(FixiOS14);
                }
            }
            if (isNoBreadcum) %init(NoBreadcum);
            if (!isXCombination) %init(OriginalButtons);
            if (isReduceRows) %init(ReduceRows);
            if (ScreenRounded > 0) %init(RoundCorners);
            if (isBatteryPercent) %init(BatteryPercentage);
            if (!isCCStatusbar) %init(NoCCStatusBar);
            else %init(CCStatusBar);

            if (isMakeSBClean) {
                %init(MakeSBClean);
                if(@available(iOS 14.0, *)) {
                    %init(MakeSBClean14);
                } else {
                    %init(MakeSBClean13);
                }
            }

            if (isSwipeScreenshot) %init(SwipeScreenshot);

            if (isNoDockBackgroud) {
                %init(NoNomalDockBG);
            }

        } else {
            if (StatusBarMode == 3 || StatusBarMode == 2) {
                if (appID(@"com.ss.iphone.ugc.Ame") || appID(@"com.viettel.viettelpay") || appID(@"com.atebits.Tweetie2") || (StatusBarMode == 2 && appID(@"com.burbn.instagram")))
                    %init(FixStatusBarInApp);
                else if (appID(@"com.google.ios.youtube"))
                    %init(FixYouTube);
                else if (appID(@"com.facebook.Facebook"))
                    BottomInset += 5;
                else if (StatusBarMode == 3 && appID(@"com.burbn.instagram"))
                    %init(FixInstagram);
            }

            if (appID(@"com.apple.camera")) %init(CamAppSet);
            if (appID(@"com.atebits.Tweetie2")) {
                %init(FixTwitter);
                BottomInset += 5;
            }
        }

        if (isHomeBarAutoHide) {
            isHomeBarSB = YES;
            %init(HomeBarAutoHide);
        }

        if (!isHomeBarLS) {
            %init(NoHomeBarLS);
            if (!isHomeBarSB) %init(NoHomeBar);
        } else %init(HomeBar);

        if (isHigherKeyboard) %init(HigherKeyboard);
        else %init(DefaultKeyboard);

        if (isNoSwipeKB) {
            [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidShowNotification object:nil queue:nil usingBlock:^(NSNotification *n) {isNoGesturesKB = true;}];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification *n) {isNoGesturesKB = false;}];
        }
    }
}