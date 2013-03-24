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

@protocol EBIniciativaDelegate
-(void)didUpdateDetails;
@end

@interface EBIniciativa : NSObject{
    NSString *fecha;
    NSString *nombreCongresista;
    NSString *descripcion;
    NSString *estado;
    NSString *identificadorDeIniciativa;
    unsigned int localAFavorPorcentaje;
    unsigned int localEnContraPorcentaje;
    unsigned int localTotalVotos;
    unsigned int plenoAFavor;
    unsigned int plenoEnContra;
    unsigned int plenoAbstenciones;
    NSArray *recursosAdicionales;
    BOOL detallesDisponibles;
    id <EBIniciativaDelegate> delegate;
}

@property(nonatomic,retain)NSString *fecha;
@property(nonatomic,retain)NSString *nombreCongresista;
@property(nonatomic,retain)NSString *descripcion;
@property(nonatomic,retain)NSString *estado;
@property(nonatomic,retain)NSString *identificadorDeIniciativa;
@property(nonatomic,assign)unsigned int localAFavorPorcentaje;
@property(nonatomic,assign)unsigned int localEnContraPorcentaje;
@property(nonatomic,assign)unsigned int localTotalVotos;
@property(nonatomic,assign)unsigned int plenoAFavor;
@property(nonatomic,assign)unsigned int plenoEnContra;
@property(nonatomic,assign)unsigned int plenoAbstenciones;
@property(nonatomic,retain)NSArray *recursosAdicionales;
@property(nonatomic,retain)id <EBIniciativaDelegate> delegate;

- (id) initWithElement:(TFHppleElement *)element;
-(void)voteUp;
-(void)voteDown;
-(void)descargarDetalles;

@end
