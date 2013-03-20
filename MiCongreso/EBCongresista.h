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

typedef enum {
    kDiputado,
    kSenador,
} kCongresista;


@interface EBCongresista : NSObject{
    NSString *nombre;
    NSString *direccion;
    NSString *telefono;
    NSString *email;
    NSString *suplente;
    NSString *partido;
    NSString *estado;
    unsigned int tipo;
    NSURL *imagen;
    NSURL *detalles;
}

@property(nonatomic, retain)NSString *nombre;
@property(nonatomic, retain)NSString *direccion;
@property(nonatomic, retain)NSString *telefono;
@property(nonatomic, retain)NSString *email;
@property(nonatomic, retain)NSString *suplente;
@property(nonatomic, assign)unsigned int tipo;
@property(nonatomic, retain)NSURL *imagen;
@property(nonatomic, retain)NSString *partido;
@property(nonatomic, retain)NSString *estado;
@property(nonatomic, retain)NSURL *detalles;

- (id) initWithElement:(TFHppleElement *)element;
-(void)descargarDetalles;

@end
