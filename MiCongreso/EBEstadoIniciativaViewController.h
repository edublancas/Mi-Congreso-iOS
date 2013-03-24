//
//  EBEstadoIniciativaViewController.h
//  MiCongreso
//
//  Created by Edu on 23/03/13.
//  Copyright (c) 2013 Eduardo Blancas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBEstadoIniciativaViewController : UITableViewController{
    NSString *estado;
    NSUInteger index;
}

@property(nonatomic,copy)NSString *estado;

@end
