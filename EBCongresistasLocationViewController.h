//
//  EBCongresistasLocationViewController.h
//  MiCongreso
//
//  Created by Edu on 22/03/13.
//  Copyright (c) 2013 Eduardo Blancas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBCongresista.h"
#import "EBCongresistaDetailViewController.h"

@interface EBCongresistasLocationViewController : UITableViewController{
    NSDictionary *diputados;
    NSDictionary *senadores;
    
    NSMutableArray *diputadosLocation;
    NSMutableArray *senadoresLocation;
    
    
    NSString *estado;
}

@property(nonatomic, retain)NSDictionary *diputados;
@property(nonatomic, retain)NSDictionary *senadores;
@property(nonatomic, retain)NSString *estado;

@end
