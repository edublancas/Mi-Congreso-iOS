//
//  EBCongresista.h
//  MiCongreso
//
//  Created by Edu on 16/03/13.
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
