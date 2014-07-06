//
//  EBIniciativa.h
//  MiCongreso
//

//  Copyright (c) 2013 Eduardo Blancas https://github.com/edublancas
//
//  MIT LICENSE
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.

#import <Foundation/Foundation.h>
#import "TFHppleElement.h"
#import "TFHpple.h"
#import "SVProgressHUD.h"

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
