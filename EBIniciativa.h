//
//  EBIniciativa.h
//  MiCongreso
//
//  Created by Edu on 16/03/13.
//  Copyright (c) 2013 Eduardo Blancas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHppleElement.h"
#import "TFHpple.h"

@interface EBIniciativa : NSObject{
    NSString *fecha;
    NSString *nombreCongresista;
    NSString *descripcion;
    NSString *estado;
    NSString *identificadorDeIniciativa;
    unsigned int localAFavor;
    unsigned int localEnContra;
    unsigned int plenoAFavor;
    unsigned int plenoEnContra;
    unsigned int plenoAbstenciones;
    BOOL detallesDisponibles;
}

@property(nonatomic,retain)NSString *fecha;
@property(nonatomic,retain)NSString *nombreCongresista;
@property(nonatomic,retain)NSString *descripcion;
@property(nonatomic,retain)NSString *estado;
@property(nonatomic,retain)NSString *identificadorDeIniciativa;
@property(nonatomic,assign)unsigned int localAFavor;
@property(nonatomic,assign)unsigned int localEnContra;
@property(nonatomic,assign)unsigned int plenoAFavor;
@property(nonatomic,assign)unsigned int plenoEnContra;
@property(nonatomic,assign)unsigned int plenoAbstenciones;


- (id) initWithElement:(TFHppleElement *)element;
-(void)voteUp;
-(void)voteDown;

@end
