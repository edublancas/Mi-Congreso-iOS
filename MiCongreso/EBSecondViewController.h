//
//  EBSecondViewController.h
//  MiCongreso
//
//  Created by Edu on 16/03/13.
//  Copyright (c) 2013 Eduardo Blancas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "EBCongresista.h"

@interface EBSecondViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>{
    //NSMutableArray *senadores;
    NSMutableDictionary *senadores;
    UISegmentedControl *segmented;
    NSMutableDictionary *tableData;
    NSMutableDictionary *senadoresFiltradosDic;
}


-(void)descargarDiputados;
-(void)descargarSenadores;
-(void)filtrar;

@end
