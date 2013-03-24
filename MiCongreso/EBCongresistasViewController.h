//
//  EBSecondViewController.h
//  MiCongreso
//
//  Created by Edu on 16/03/13.
//  Copyright (c) 2013 Eduardo Blancas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "EBCongresista.h"
#import "EBDownloadManager.h"
#import "EBCongresistaDetailViewController.h"
#import "EBCongresistasLocationViewController.h"

@interface EBCongresistasViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate, EBDownloadManagerDelegate, CLLocationManagerDelegate>{
    //NSMutableArray *senadores;
    NSDictionary *senadores;
    UISegmentedControl *segmented;
    NSMutableDictionary *tableData;
    NSMutableDictionary *senadoresFiltradosDic;
    
    NSDictionary *diputados;
    NSMutableDictionary *diputadosFiltradosDic;
    
    NSMutableDictionary *resultados;
    
    EBDownloadManager *downloadManager;
    
    CLLocationManager *locationManager;
    
    NSUInteger diputadosFiltradosCount;
    NSUInteger senadoresFiltradosCount;
    
}



-(void)filtrar;
-(void)mostrarCongresistasParaMiUbicacion;

@end
