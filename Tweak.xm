@interface SBAppSwitcherController

-(BOOL)switcherScroller:(id)arg1 isDisplayItemRemovable:(id)arg2 ;

-(void)switcherScroller:(id)arg1 displayItemWantsToBeRemoved:(id)arg2 ;

-(void)launchAppWithIdentifier:(id)arg1 url:(id)arg2 actions:(id)arg3 ;

@end



@interface SBDisplayItem : NSObject

@property (nonatomic,readonly) NSString* displayIdentifier;

@end



@interface SBAppSliderController

-(BOOL)sliderScroller:(id)arg1 isIndexRemovable:(unsigned NSInteger)arg2 ;

-(id)_displayIDAtIndex:(unsigned NSInteger)arg1 ;

@end



@interface SBApplicationPlaceHolder

-(BOOL)icon:(id)arg1 launchFromLocation:(int)arg2 ;

@end



static void PreferencesChanged() {

	 CFPreferencesAppSynchronize(CFSTR("com.dgh0st.whitelistswitcher"));

}



static BOOL PreferencesGetSwitchAppEnabled() {

    Boolean keyExists;

    Boolean enabled = CFPreferencesGetAppBooleanValue(CFSTR("isEnabled"), CFSTR("com.dgh0st.whitelistswitcher"), &keyExists);

    return (enabled);

}



static BOOL PreferencesGetMSIrremoveable() {

    Boolean keyExists;

    Boolean enabled = CFPreferencesGetAppBooleanValue(CFSTR("msIrremoveable"), CFSTR("com.dgh0st.whitelistswitcher"), &keyExists);

    return (enabled);

}



static BOOL PreferencesGetMSRestartable() {

    Boolean keyExists;

    Boolean enabled = CFPreferencesGetAppBooleanValue(CFSTR("msRestartable"), CFSTR("com.dgh0st.whitelistswitcher"), &keyExists);

    return (enabled);

}



static BOOL PreferencesGetMSLaunchable() {

    Boolean keyExists;

    Boolean enabled = CFPreferencesGetAppBooleanValue(CFSTR("msLaunchable"), CFSTR("com.dgh0st.whitelistswitcher"), &keyExists);

    return (enabled);

}



static BOOL PreferencesGetIrremovable(NSString *appId) {

    BOOL result = NO;

    NSArray *allKeys = (NSArray *)CFPreferencesCopyKeyList(CFSTR("com.dgh0st.whitelistswitcher"), kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);

    for (NSString *key in allKeys) {

	if ([key hasPrefix:@"Irremovable-"] && CFPreferencesGetAppIntegerValue((CFStringRef)key, CFSTR("com.dgh0st.whitelistswitcher"), NULL)) {

	    NSString *tempId = [key substringFromIndex:[@"Irremovable-" length]];

	    if ([tempId isEqual:appId]) {

		result = YES;

		break;

	    }

	}

    }

    [allKeys release];

    return result;

}



static BOOL PreferencesGetRestart(NSString *appId) {

    BOOL result = NO;

    NSArray *allKeys = (NSArray *)CFPreferencesCopyKeyList(CFSTR("com.dgh0st.whitelistswitcher"), kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);

    for (NSString *key in allKeys) {

	if ([key hasPrefix:@"Restart-"] && CFPreferencesGetAppIntegerValue((CFStringRef)key, CFSTR("com.dgh0st.whitelistswitcher"), NULL)) {

	    NSString *tempId = [key substringFromIndex:[@"Restart-" length]];

	    if ([tempId isEqual:appId]) {

		result = YES;

		break;

	    }

	}

    }

    [allKeys release];

    return result;

}



static BOOL PreferencesGetLaunch(NSString *appId) {

    BOOL result = NO;

    NSArray *allKeys = (NSArray *)CFPreferencesCopyKeyList(CFSTR("com.dgh0st.whitelistswitcher"), kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);

    for (NSString *key in allKeys) {

	if ([key hasPrefix:@"Launch-"] && CFPreferencesGetAppIntegerValue((CFStringRef)key, CFSTR("com.dgh0st.whitelistswitcher"), NULL)) {

	    NSString *tempId = [key substringFromIndex:[@"Launch-" length]];

	    if ([tempId isEqual:appId]) {

		result = YES;

		break;

	    }

	}

    }

    [allKeys release];

    return result;

}



%group ios8plus

%hook SBAppSwitcherController

-(BOOL)switcherScroller:(id)arg1 isDisplayItemRemovable:(SBDisplayItem *)arg2 {

    if(PreferencesGetSwitchAppEnabled() && (PreferencesGetLaunch(arg2.displayIdentifier) || PreferencesGetMSLaunchable() || PreferencesGetRestart(arg2.displayIdentifier) || PreferencesGetMSRestartable())){

	return YES;

    } else if(PreferencesGetSwitchAppEnabled() && (PreferencesGetIrremovable(arg2.displayIdentifier) || PreferencesGetMSIrremoveable())){

		return NO;

	}

	return %orig;

}

-(void)switcherScroller:(id)arg1 displayItemWantsToBeRemoved:(SBDisplayItem *)arg2 {

	if(PreferencesGetSwitchAppEnabled() && (PreferencesGetRestart(arg2.displayIdentifier) || PreferencesGetMSRestartable())){

		%orig;

		[self launchAppWithIdentifier:arg2.displayIdentifier url:nil actions:nil];

	} else if(PreferencesGetSwitchAppEnabled() && (PreferencesGetLaunch(arg2.displayIdentifier) || PreferencesGetMSLaunchable())){

		[self launchAppWithIdentifier:arg2.displayIdentifier url:nil actions:nil];

	} else {

		%orig;

	}

}

%end

%end



%group ios7

%hook SBAppSliderController

-(BOOL)sliderScroller:(id)arg1 isIndexRemovable:(unsigned NSInteger)arg2 {

    if(PreferencesGetSwitchAppEnabled() && (PreferencesGetLaunch([self _displayIDAtIndex:arg2]) || PreferencesGetMSLaunchable() || PreferencesGetRestart([self _displayIDAtIndex:arg2]) || PreferencesGetMSRestartable())){

	return YES;

    } else if(PreferencesGetSwitchAppEnabled() && (PreferencesGetIrremovable([self _displayIDAtIndex:arg2]) || PreferencesGetMSIrremoveable())){

	return NO;

    }

    return %orig;

}

-(void)sliderScroller:(id)arg1 itemWantsToBeRemoved:(unsigned NSInteger)arg2 {

    if(PreferencesGetSwitchAppEnabled() && (PreferencesGetRestart([self _displayIDAtIndex:arg2]) || PreferencesGetMSRestartable())){

	%orig;

	[%c(SBApplicationPlaceHolder) icon:[self _displayIDAtIndex:arg2] launchFromLocation:1];

    } else if(PreferencesGetSwitchAppEnabled() && (PreferencesGetLaunch([self _displayIDAtIndex:arg2]) || PreferencesGetMSLaunchable())){

	[%c(SBApplicationPlaceHolder) icon:[self _displayIDAtIndex:arg2] launchFromLocation:1];

    } else {

	%orig;

    }

}

%end

%end



%ctor{

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)PreferencesChanged, CFSTR("com.dgh0st.whitelistswitcher-preferecesChanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

    if(%c(SBAppSwitcherController)){

		%init(ios8plus);

    } else if(%c(SBAppSliderController)){

		%init(ios7);

    }

}
