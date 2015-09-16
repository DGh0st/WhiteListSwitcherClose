#import <Preferences/Preferences.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface PSListController (WhitelistSwitcher)
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;
- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;
- (UINavigationController*)navigationController;
@end

@interface WhitelistSwitcherListController: PSListController <MFMailComposeViewControllerDelegate>{
	NSMutableArray *_irremovableExtraSpecifiers;
	NSMutableArray *_restartExtraSpecifiers;
	NSMutableArray *_launchExtraSpecifiers;
}
@end

@implementation WhitelistSwitcherListController
- (id)specifiers {
	if(_specifiers == nil) {
		NSMutableArray *specifiers = [[self loadSpecifiersFromPlistName:@"WhitelistSwitcher" target:self] mutableCopy];
		_irremovableExtraSpecifiers = [[NSMutableArray alloc] init];
		for(int i = [specifiers indexOfObject:[specifiers specifierForID:@"SWITCH_GROUP"]]+1; i < specifiers.count; i++){
			PSSpecifier *currentSpec = specifiers[i];
			if([PSTableCell cellTypeFromString:@"PSGroupCell"] == currentSpec->cellType)
				break;
			[_irremovableExtraSpecifiers addObject:currentSpec];
		}
		_restartExtraSpecifiers = [[NSMutableArray alloc] init];
		for(int i = [specifiers indexOfObject:[specifiers specifierForID:@"SWITCH_GROUP"]]+1; i < specifiers.count; i++){
			PSSpecifier *currentSpec = specifiers[i];
			if([PSTableCell cellTypeFromString:@"PSGroupCell"] == currentSpec->cellType)
				break;
			[_restartExtraSpecifiers addObject:currentSpec];
		}
		_launchExtraSpecifiers = [[NSMutableArray alloc] init];
		for(int i = [specifiers indexOfObject:[specifiers specifierForID:@"SWITCH_GROUP"]]+1; i < specifiers.count; i++){
			PSSpecifier *currentSpec = specifiers[i];
			if([PSTableCell cellTypeFromString:@"PSGroupCell"] == currentSpec->cellType)
				break;
			[_launchExtraSpecifiers addObject:currentSpec];
		}
		       
        _specifiers = specifiers.copy;
        [specifiers release];
	}
	return _specifiers;
}
-(void)email{
	if([MFMailComposeViewController canSendMail]){
		MFMailComposeViewController *email = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
		[email setSubject:@"WhitelistSwitcher Support"];
		[email setToRecipients:[NSArray arrayWithObjects:@"deeppwnage@yahoo.com", nil]];
		[email addAttachmentData:[NSData dataWithContentsOfFile:@"/var/mobile/Library/Preferences/com.dgh0st.whitelistswitcher.plist"] mimeType:@"application/xml" fileName:@"Prefs.plist"];
		#pragma GCC diagnostic push
		#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
		system("/usr/bin/dpkg -l >/tmp/dpkgl.log");
		#pragma GCC diagnostic pop
		[email addAttachmentData:[NSData dataWithContentsOfFile:@"/tmp/dpkgl.log"] mimeType:@"text/plain" fileName:@"dpkgl.txt"];
		[self.navigationController presentViewController:email animated:YES completion:nil];
		[email setMailComposeDelegate:self];
		[email release];
	}
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self dismissViewControllerAnimated: YES completion: nil];
}
- (void)donate{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=deeppwnage%40yahoo%2ecom&lc=US&item_name=DGh0st&item_number=DGh0st%20Tweak%20Inc%20%28Wow%20I%20own%20a%20company%29&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donate_LG%2egif%3aNonHostedGuest"]];
}
- (void)follow{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/D_Gh0st"]];
}
@end

// vim:ft=objc
