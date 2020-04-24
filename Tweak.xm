#import "SparkAppList.h"

@interface CCUIContentModuleContainerView : UIView
  @property (nonatomic,copy,readonly) NSString * moduleIdentifier;
@end

@interface CCUILabeledRoundButton : UIView
  @property (nonatomic,copy) NSString * title;
  -(NSString *)title;
@end

@interface CCUIRoundButton : UIControl
  -(void)getControlAndPerformAction;
@end

@interface FBSystemService : NSObject
  +(id)sharedInstance;
  -(void)exitAndRelaunch:(BOOL)arg1;
@end

@interface UIApplication (TEST)
  +(id)sharedApplication;
  -(BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;
  -(BOOL)openURL:(id)arg1;
@end

static BOOL isEnabled = YES;
static CGFloat minHoldDuration = 0.8;
int gestureCode = 0;
//NSString* defaultconnApp = @"Show Menu";

static void performAction(NSString* currModule)
{
  if ([currModule isEqualToString:@"com.apple.control-center.DoNotDisturbModule"])
  {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=DO_NOT_DISTURB"]];
  }
  else if ([currModule isEqualToString:@"com.apple.control-center.LowPowerModule"])
  {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=BATTERY_USAGE"]];
  }
  else if ([currModule isEqualToString:@"com.laughingquoll.noctis.noctistoggle"])
  {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=NoctisXI"]];
  }
  else if ([currModule isEqualToString:@"com.ichitaso.locationservicecc"])
  {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=LOCATION"]];
  }
  else if ([currModule isEqualToString:@"com.apple.mediaremote.controlcenter.nowplaying"])
  {
    NSArray *musicApp = [NSArray arrayWithArray:[SparkAppList getAppListForIdentifier:@"com.imkpatil.cclinker" andKey:@"musicAppID"]];
    if ([musicApp count] > 0)
    {
      // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"addAlarm Handler" message:musicAppIdentifier delegate:[[UIApplication sharedApplication] keyWindow].rootViewController cancelButtonTitle:@"OK" otherButtonTitles:nil];
      // [alert show];
      [[UIApplication sharedApplication] launchApplicationWithIdentifier:[musicApp objectAtIndex:[musicApp count] - 1] suspended:NO];
      //[[%c(LSApplicationWorkspace) defaultWorkspace] openApplicationWithBundleID:musicAppIdentifier];
      //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:musicAppIdentifier]];
    }

  }
  else if ([currModule isEqualToString:@"com.apple.control-center.DisplayModule"])
  {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=DISPLAY_&_BRIGHTNESS"]];
  }
  else if ([currModule isEqualToString:@"com.apple.control-center.AudioModule"])
  {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Sounds"]];
  }
  else if ([currModule isEqualToString:@"com.apple.accessibility.controlcenter.general"])
  {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=ACCESSIBILITY"]];
  }
  else if ([currModule isEqualToString:@"com.apple.control-center.CarModeModule"])
  {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=DO_NOT_DISTURB"]];
  }
  else if ([currModule isEqualToString:@"com.apple.accessibility.controlcenter.guidedaccess"])
  {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=ACCESSIBILITY"]];
  }
  else if ([currModule isEqualToString:@"com.apple.control-center.MagnifierModule"])
  {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=ACCESSIBILITY"]];
  }
  else if ([currModule isEqualToString:@"com.apple.accessibility.controlcenter.text.size"])
  {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=ACCESSIBILITY"]];
  }
  else if ([currModule isEqualToString:@"com.apple.control-center.WalletModule"])
  {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"shoebox://"]];
  }
  else if ([currModule isEqualToString:@"Bluetooth"])
  {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Bluetooth"]];
  }
  else if ([currModule isEqualToString:@"Wi-Fi"])
  {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
  }
  else if ([currModule isEqualToString:@"Cellular Data"])
  {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=MOBILE_DATA_SETTINGS_ID"]];
  }
  else if ([currModule isEqualToString:@"Airplane Mode"])
  {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root"]];
  }
  else if ([currModule isEqualToString:@"Personal Hotspot"])
  {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=INTERNET_TETHERING"]];
  }
  else if ([currModule isEqualToString:@"com.KingPuffdaddi.control-center.CCVPN"])
  {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=VPN"]];
  }
  else if ([currModule isEqualToString:@"AirDrop"])
  {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root"]];
  }

}

%hook CCUIRoundButton

-(void)layoutSubviews
{
  if (isEnabled)
  {
    if (gestureCode == 1)
    {
      UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]
      initWithTarget:self action:@selector(handleSwipe:)];
      swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
      [self addGestureRecognizer:swipeLeft];
      [swipeLeft release];
    }
    else if (gestureCode == 2)
    {
      UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]
      initWithTarget:self action:@selector(handleSwipe:)];
      swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
      [self addGestureRecognizer:swipeRight];
      [swipeRight release];
    }
    else
    {
      UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
      initWithTarget:self action:@selector(handleLongPress:)];
      longPressGestureRecognizer.minimumPressDuration = minHoldDuration;
      [self addGestureRecognizer:longPressGestureRecognizer];
      [longPressGestureRecognizer release];
    }
  }

  return %orig;

}

%new
-(void)getControlAndPerformAction
{
  NSString *tmp = @"";

  for (UIView *next = [self superview]; next; next = next.superview)
  {
    UIResponder* nextResponder = [next nextResponder];
    if ([nextResponder isKindOfClass:NSClassFromString(@"CCUIConnectivityWifiViewController")])
    {
      tmp = @"Wi-Fi";
      break;
    }
    else if ([nextResponder isKindOfClass:NSClassFromString(@"CCUIConnectivityBluetoothViewController")])
    {
      tmp = @"Bluetooth";
      break;
    }
    else if ([nextResponder isKindOfClass:NSClassFromString(@"CCUIConnectivityCellularDataViewController")])
    {
      tmp = @"Cellular Data";
      break;
    }
    else if ([nextResponder isKindOfClass:NSClassFromString(@"CCUIConnectivityAirplaneViewController")])
    {
      tmp = @"Airplane Mode";
      break;
    }
    else if ([nextResponder isKindOfClass:NSClassFromString(@"CCUIConnectivityHotspotViewController")])
    {
      tmp = @"Personal Hotspot";
      break;
    }
    else if ([nextResponder isKindOfClass:NSClassFromString(@"CCUIConnectivityAirdropViewController")])
    {
      tmp = @"Airdrop";
      break;
    }
  }

  performAction(tmp);
}

%new
-(void)handleLongPress:(UILongPressGestureRecognizer *)gesture
{
  if (gesture.state == UIGestureRecognizerStateBegan)
  {
    if (isEnabled)
    {
      [self getControlAndPerformAction];
    }
  }

}

%new
-(void)handleSwipe:(UISwipeGestureRecognizer*)swipe
{
  if (isEnabled)
  {
    [self getControlAndPerformAction];
  }

}

%end

%hook CCUIContentModuleContainerView

-(id)initWithModuleIdentifier:(id)arg1 options:(unsigned long long)arg2
{
  if (isEnabled)
  {
    if (gestureCode == 1)
    {
      UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]
      initWithTarget:self action:@selector(handleSwipe:)];
      swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
      [self addGestureRecognizer:swipeLeft];
      [swipeLeft release];
    }
    else if (gestureCode == 2)
    {
      UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]
      initWithTarget:self action:@selector(handleSwipe:)];
      swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
      [self addGestureRecognizer:swipeRight];
      [swipeRight release];
    }
    else
    {
      UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
      initWithTarget:self action:@selector(handleLongPress:)];
      longPressGestureRecognizer.minimumPressDuration = minHoldDuration;
      [self addGestureRecognizer:longPressGestureRecognizer];
      [longPressGestureRecognizer release];
    }

  }

  return %orig;
}

%new
-(void)handleLongPress:(UILongPressGestureRecognizer *)gesture
{
  if (gesture.state == UIGestureRecognizerStateBegan)
  {
    if (isEnabled)
    {
      performAction(self.moduleIdentifier);
    }
  }

}

%new
-(void)handleSwipe:(UISwipeGestureRecognizer*)swipe
{
  if (isEnabled)
  {
    performAction(self.moduleIdentifier);
  }

}

%end

static void reloadSettings() {

  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.imkpatil.cclinker.plist"];
  if(prefs)
  {
      isEnabled = [prefs objectForKey:@"twkEnabled"] ? [[prefs objectForKey:@"twkEnabled"] boolValue] : isEnabled;
      //minduration = [prefs objectForKey:@"waitDur"] ? [[prefs objectForKey:@"waitDur"] intValue] : minduration;
      gestureCode = [prefs objectForKey:@"gestureType"] ? [[prefs objectForKey:@"gestureType"] intValue] : gestureCode;
      //defaultconnApp = [prefs objectForKey:@"connApp"] ? [[prefs objectForKey:@"connApp"] stringValue] : defaultconnApp;
      //musicAppIdentifier = [prefs objectForKey:@"musicAppID"] ? [[prefs objectForKey:@"musicAppID"] stringValue] : musicAppIdentifier;
  }
  [prefs release];
}

static void respring(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  //reloadSettings();
  [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
}

%ctor {
  if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.springboard"])
  {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadSettings, CFSTR("com.imkpatil.cclinker.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, respring, CFSTR("com.imkpatil.cclinker.respring"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    reloadSettings();
  }
}
