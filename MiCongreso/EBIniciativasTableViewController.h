//
//  EBIniciativasTableViewController.h
//  MiCongreso
//
//  Created by Edu on 17/03/13.
//  Copyright (c) 2013 Eduardo Blancas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFHpple.h"
#import "EBIniciativa.h"
#import "EBIniciativaDetallesTableViewController.h"
#import "SVStatusHUD.h"

@interface EBIniciativasTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *iniciativas;
    UIFont *font;
    int numeroDePaginasMostradas;
    BOOL isLoading;
}


-(void)cargarIniciativas;

@end
