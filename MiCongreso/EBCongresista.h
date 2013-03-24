//
//  EBCongresista.h
//  MiCongreso
//
//  Created by Edu on 16/03/13.
//  Copyright (c) 2013 Eduardo Blancas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHppleElement.h"
#import "TFHpple.h"
#import <Foundation/Foundation.h>

@protocol EBCongresistaDelegate
-(void)didUpdateDetails;
@end


@interface EBCongresista : NSObject{
    
    //Básicos
    NSString *nombre;
    NSString *partido;
    NSString *estado;
    unsigned int tipo;
    BOOL detallesDisponibles;
    
    //URl para descargar más información
    NSString *detallesString;
    
    //Detalles
    NSString *email;
    NSString *suplente;
    NSURL *imagen;
    
    //Detalles - sólo senadores
    NSString *direccion;
    NSString *telefono;
    
    //Delegate
    id <EBCongresistaDelegate> delegate;
}

@property(nonatomic, retain)NSString *nombre;
@property(nonatomic, retain)NSString *direccion;
@property(nonatomic, retain)NSString *telefono;
@property(nonatomic, retain)NSString *email;
@property(nonatomic, retain)NSString *suplente;
@property(nonatomic, assign)unsigned int tipo;
@property(nonatomic, assign)BOOL detallesDisponibles;
@property(nonatomic, retain)NSURL *imagen;
@property(nonatomic, retain)NSString *partido;
@property(nonatomic, retain)NSString *estado;
@property(nonatomic, retain)NSString *detallesString;
@property(nonatomic, retain)id <EBCongresistaDelegate> delegate;


-(id)initWithElement:(TFHppleElement *)element;
-(id)initWithCongresoRestDic:(NSDictionary *)dic;
-(id)initWithDic:(NSDictionary *)plistDic type:(NSUInteger)type;
-(void)descargarDetalles;
-(NSDictionary *)exportAsDictionary;

@end
