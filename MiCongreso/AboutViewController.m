//

//  Copyright (c) 2013 Eduardo Blancas https://github.com/edublancas
//
//  MIT LICENSE
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.

#import "AboutViewController.h"


@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *buttonImage = [[UIImage imageNamed:@"greyButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"greyButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    // Set the background for any states you plan to use
    [facebookButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [facebookButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    
    [twitterButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [twitterButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    
    [emailButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [emailButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    
}


- (IBAction)facebookLink:(id)sender {
    NSURL *myURL;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
        myURL = [NSURL URLWithString:@"fb://profile/212905425403278"];
        
    }else{
        myURL = [NSURL URLWithString:@"http://www.facebook.com/cacaolabs"];
    }
    [[UIApplication sharedApplication] openURL:myURL];
}

- (IBAction)emailUs:(id)sender{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil){
		if ([mailClass canSendMail]){
			[self displayComposerSheet];
		}
		else{
			[self launchMailAppOnDevice];
		}
	}
	else{
		[self launchMailAppOnDevice];
	}
}

- (IBAction)twitterPerfil:(id)sender{
    NSURL *myURL;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
        myURL = [NSURL URLWithString:@"twitter:///user?screen_name=cacaolabses"];
    }else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot://"]]){
        myURL = [NSURL URLWithString:@"tweetbot:///user_profile/cacaolabses"];
    }else{
        myURL = [NSURL URLWithString:@"http://www.twitter.com/cacaolabses"];
    }
    [[UIApplication sharedApplication] openURL:myURL];
}

#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet 
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"Mi Congreso app"];
	[picker setToRecipients:[NSArray arrayWithObject:@"cacao.labs@gmail.com"]];
	[self presentViewController:picker animated:YES completion:nil];
}

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:cacao.labs@gmail.com&subject=Mi Congreso app";
	NSString *email = [NSString stringWithFormat:@"%@", recipients];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

//Send files as plist
- (IBAction)exportFiles:(id)sender{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	[picker setSubject:@"Archivos de Mi Congreso"];
    
    NSData *dataDiputados = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"diputados" ofType:@"plist"]];
    NSData *dataSenadores = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"senadores" ofType:@"plist"]];
    NSData *dataComisionesDiputdos = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"comisionesOrdinariasDiputados" ofType:@"plist"]];
    NSData *dataComisionesSenadores = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"comisionesOrdinariasSenadores" ofType:@"plist"]];
    
    [picker addAttachmentData:dataDiputados mimeType:@"application/x-plist" fileName:@"diputados.plist"];
    [picker addAttachmentData:dataSenadores mimeType:@"application/x-plist" fileName:@"senadores.plist"];
    [picker addAttachmentData:dataComisionesDiputdos mimeType:@"application/x-plist" fileName:@"comisionesOrdinariasDiputados.plist"];
    [picker addAttachmentData:dataComisionesSenadores mimeType:@"application/x-plist" fileName:@"comisionesOrdinariasSenadores.plist"];
    
	[self presentViewController:picker animated:YES completion:nil];
}


- (IBAction)doneButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	if (error)
        NSLog(@"Error: %@", error);
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (UIInterfaceOrientationPortrait == interfaceOrientation);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
}

@end
