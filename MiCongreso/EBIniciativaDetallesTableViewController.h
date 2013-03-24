//
//  EBIniciativaDetallesTableViewController.h
//  MiCongreso
//
//  Created by Edu on 17/03/13.
//  Copyright (c) 2013 Eduardo Blancas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBIniciativa.h"
#import "EBEstadoIniciativaViewController.h"

@interface EBIniciativaDetallesTableViewController : UITableViewController<EBIniciativaDelegate>{
    EBIniciativa *iniciativa;
    BOOL didVote;
    
}

@property(nonatomic, retain)EBIniciativa *iniciativa;

@end
