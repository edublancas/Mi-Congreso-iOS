//
//  EBIniciativaDetallesTableViewController.h
//  MiCongreso
//
//  Created by Edu on 17/03/13.
//  Copyright (c) 2013 Eduardo Blancas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBIniciativa.h"

@interface EBIniciativaDetallesTableViewController : UITableViewController{
    EBIniciativa *iniciativa;
    
}

@property(nonatomic, retain)EBIniciativa *iniciativa;

@end
