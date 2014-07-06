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

#import "EBBrowserViewController.h"

@interface EBBrowserViewController ()

@end

@implementation EBBrowserViewController

@synthesize showMobilizerSwitch;


- (id)initWithTitle:(NSString *)title andURL:(NSURL *)URL{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
        self.navigationItem.title = title;
        
        theURL = URL;
        
        
        NSLog(@"URL: %@", [theURL absoluteString]);
        
    }
    return self;
}

- (IBAction)openIn:(id)sender {
    //Open with Safari
    [[UIApplication sharedApplication] openURL:theURL];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    theWebView.scalesPageToFit = YES;
    theWebView.delegate = self;
    
    [theWebView loadRequest:[NSURLRequest requestWithURL:theURL]];
    [shareButton setTintColor:[UIColor whiteColor]];
    [compassButton setTintColor:[UIColor whiteColor]];
    
    if (showMobilizerSwitch) {
        mobilizerSwitch.hidden = NO;
    }else{
        mobilizerSwitch.hidden = YES;
    }
    
    //Config switch
    mobilizerSwitch.onTintColor = [UIColor colorWithRed:0.694 green:0.510 blue:0.243 alpha:1.000];

}

//Back button was pressed
-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [[EBProgressIndicator sharedProgressIndicator]removeProcessFromQueue];
    }
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Sharing

- (IBAction)mobilizeSwitch:(id)sender {
    UISwitch *theSwitch = (UISwitch *)sender;
    if (!theSwitch.isOn) {
        //Unmobilize
        NSString *string = [[theWebView.request.URL absoluteString]stringByReplacingOccurrencesOfString:@"http://www.instapaper.com/m?u=" withString:@""];
        [theWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string]]];
        
        [theWebView loadRequest:[NSURLRequest requestWithURL:theURL]];
    }else{
        //Mobilize
        NSString *mstring = [NSString stringWithFormat:@"http://www.instapaper.com/m?u=%@", [theWebView.request.URL absoluteString]];
        [theWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:mstring]]];
    }
}

- (IBAction)shareDocument:(id)sender {
    NSLog(@"Share document...");
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Comparte este documento"
                          message:@"¿Dónde deseas compartir?"
                          delegate:self
                          cancelButtonTitle:@"Cancelar"
                          otherButtonTitles:@"Twitter",
                          @"Facebook", nil];
    
    alert.tag = 1;
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1) {
        if (buttonIndex==1) {
            //Twitter
            [self postVoteTo:SLServiceTypeTwitter];
        }else if(buttonIndex==2){
            //Facebook
            [self postVoteTo:SLServiceTypeFacebook];
        }
    }
    
}


-(void)postVoteTo:(NSString *)socialNetwork{
    
    if ([SLComposeViewController isAvailableForServiceType:socialNetwork]) {
        
        SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:socialNetwork];
        
        NSString *text;
        
#warning cambiar texto al momento de postear
        
        text = self.navigationItem.title;
        
        [composeViewController setInitialText:text];
        
        NSString *urlString = [theURL absoluteString];
        
        [composeViewController addURL:[NSURL URLWithString:urlString]];
        
        SLComposeViewControllerCompletionHandler handler = ^(SLComposeViewControllerResult result){
            [composeViewController dismissViewControllerAnimated:YES completion:Nil];
        };
        
        [composeViewController setCompletionHandler:handler];
        
        [self presentViewController:composeViewController animated:YES completion:nil];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Aviso"
                              message:@"Debes configurar una cuenta primero"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        
        [alert show];
    }
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //NSLog(@"Did finish loading...");
    [[EBProgressIndicator sharedProgressIndicator]removeProcessFromQueue];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    //NSLog(@"Did start loading: %@", [webView.request.URL absoluteString]);
    if (!didShowProgress) {
        [[EBProgressIndicator sharedProgressIndicator]addProcessToQueue];
        didShowProgress = YES;
    }
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}


@end
