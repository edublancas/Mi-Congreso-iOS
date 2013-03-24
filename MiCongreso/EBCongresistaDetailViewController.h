//
//  EBCongresistaDetailViewController.h
//  MiCongreso
//
//  Created by Edu on 22/03/13.
//  Copyright (c) 2013 Eduardo Blancas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBCongresista.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <QuartzCore/QuartzCore.h>

@interface EBCongresistaDetailViewController : UITableViewController <EBCongresistaDelegate, MFMailComposeViewControllerDelegate>{
    EBCongresista *congresista;
}

@property(nonatomic, retain)EBCongresista *congresista;


-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;
-(void)downloadImage;

@end
