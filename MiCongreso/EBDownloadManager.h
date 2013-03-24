//
//  EBDownloadManager.h
//  MiCongreso
//
//  Created by Edu on 22/03/13.
//  Copyright (c) 2013 Eduardo Blancas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "EBCongresista.h"

@protocol EBDownloadManagerDelegate
-(void)seDescargaronDiputados:(NSDictionary *)diputadosDic;
-(void)sedescargaronSenadores:(NSDictionary *)senadoresDic;
@end

@interface EBDownloadManager : NSObject{
    NSMutableDictionary *diputados;
    NSMutableDictionary *senadores;
    id <EBDownloadManagerDelegate> delegate;
    int count;
    NSMutableArray *diputadosArray;
    
}

@property(nonatomic,retain) id <EBDownloadManagerDelegate> delegate;

-(void)descargarDiputados;
-(void)descargarSenadores;
-(void)countUpSenadores;
-(void)countUpDiputados;

-(void)guardarDiputados;
-(void)guardarSenadores;




@end
