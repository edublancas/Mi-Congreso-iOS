//
//  EBIniciativa.m
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

#import "EBIniciativa.h"

@implementation EBIniciativa

@synthesize fecha, nombreCongresista, descripcion, estado,
identificadorDeIniciativa, localAFavorPorcentaje, localEnContraPorcentaje, plenoAbstenciones,
plenoAFavor, plenoEnContra, localTotalVotos,recursosAdicionales, delegate;

- (id) initWithElement:(TFHppleElement *)element{
    self = [super init];
    if (self){
        TFHppleElement *content = [element firstChild];
        
        TFHppleElement *iniciativa_info = [content firstChildWithClassName:@"iniciativa_info"];
        
        TFHppleElement *info = [iniciativa_info firstChildWithClassName:@"info"];
    
        self.fecha = [[info firstChild]content];
    
        if ([[[[info childrenWithTagName:@"span"]objectAtIndex:0]childrenWithTagName:@"a"]count]) {
            //NSLog(@"congresista: %@ fecha: %@", [[[[info childrenWithTagName:@"span"]objectAtIndex:0]childrenWithTagName:@"a"]objectAtIndex:0], self.fecha);
            self.nombreCongresista = [[[[[[info childrenWithTagName:@"span"]objectAtIndex:0]childrenWithTagName:@"a"]objectAtIndex:0]firstChild]content];
        }
        
        self.descripcion = [[[[iniciativa_info firstChildWithTagName:@"a"]firstChild]firstChild]content];
        
    
        /*
        for (TFHppleElement *elemento in [[content firstChildWithClassName:@"estado"]children]) {
            //NSLog(@"Elemento: %@", [elemento objectForKey:@"class"]);
            if ([[elemento objectForKey:@"class"]isEqualToString:@""]) {
                break;
            }
            self.estado = [elemento objectForKey:@"class"];

        }*/
        
        self.identificadorDeIniciativa = [[[[content firstChildWithClassName:@"iniciativa_icon"]firstChildWithTagName:@"a"]objectForKey:@"href"]stringByReplacingOccurrencesOfString:@"/iniciativas/" withString:@""];
        
        
    }
    return self;
}

-(void)descargarDetalles{
    [[EBProgressIndicator sharedProgressIndicator]addProcessToQueue];
    NSURL *detailsURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://curul501.org/iniciativas/%@", self.identificadorDeIniciativa]];
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:detailsURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if (data){
            TFHpple *detailsParser = [TFHpple hppleWithHTMLData:data];
            
            NSString *queryAFavor = @"//div[@class='votaciones']/ul[@class='votacion-local']/li[@class='a-favor']";
            
            NSArray *aFavorNodes = [detailsParser searchWithXPathQuery:queryAFavor];
            
            if ([aFavorNodes count]) {
                NSString *string = [[[aFavorNodes objectAtIndex:0]firstChild]content];
                string = [string stringByReplacingOccurrencesOfString:@"a favor: " withString:@""];
                string = [string stringByReplacingOccurrencesOfString:@"%" withString:@""];
                localAFavorPorcentaje = [string integerValue];
            }
            
            localEnContraPorcentaje = 100-localAFavorPorcentaje;
            
            NSString *votosQuery = @"//li[@class='votos']/span";
            
            NSArray *votosNodes = [detailsParser searchWithXPathQuery:votosQuery];
            
            if ([votosNodes count]) {
                localTotalVotos = [[[[[votosNodes objectAtIndex:0]firstChild]content] stringByReplacingOccurrencesOfString:@"\n" withString:@""]integerValue];
                //NSLog(@"Votos: %d", localTotalVotos);
                //NSLog(@"Votos nodes for %@: %@", identificadorDeIniciativa, [[[votosNodes objectAtIndex:0]firstChild]content]);
            }
            
            NSString *adicionalesQuery = @"//a[@class='aditional-resource']";
            
            NSArray *adicionalesNodes = [detailsParser searchWithXPathQuery:adicionalesQuery];
            
            if ([adicionalesNodes count]) {
                NSMutableArray *recursos = [[NSMutableArray alloc]init];
                for (TFHppleElement *element in adicionalesNodes) {
                    if ([[[element firstChild]content]length]>0) {
                        NSDictionary *dic = @{@"nombre": [[element firstChild]content], @"url":[element objectForKey:@"href"]};
                        [recursos addObject:dic];
                    }
                }
                self.recursosAdicionales = [recursos copy];
            }
            
            //NSLog(@"Recursos adicionales de %@: %@", identificadorDeIniciativa, recursosAdicionales);
            
            
            NSString *queryPleno = @"//div[@class='votaciones']/ul[@class='votacion-pleno']/li";
            NSArray *plenoNodos = [detailsParser searchWithXPathQuery:queryPleno];
            self.plenoAFavor = [[[[plenoNodos objectAtIndex:1]firstChild]content]intValue];
            self.plenoEnContra = [[[[plenoNodos objectAtIndex:2]firstChild]content]intValue];
            self.plenoAbstenciones = [[[[plenoNodos objectAtIndex:3]firstChild]content]intValue];
            
            
            NSString *queryEstado = @"//ul[@class='etapa']/li[2]";
            NSArray *estadoNodos = [detailsParser searchWithXPathQuery:queryEstado];
            
            
            NSMutableString *string = [[NSMutableString alloc]init];
            [string setString:[[[estadoNodos objectAtIndex:0]firstChild]content]];
            [string replaceOccurrencesOfString:@"comision" withString:@"comisión" options:NSLiteralSearch range:NSMakeRange(0, string.length)];
            [string replaceCharactersInRange:NSMakeRange(0, 1) withString:[[string substringToIndex:1]capitalizedString]];
            self.estado = string;
            //NSLog(@"estado: %@ id: %@", self.estado, self.identificadorDeIniciativa);
            detallesDisponibles = YES;
            
            if ([(NSObject *)self.delegate respondsToSelector:@selector(didUpdateDetails)]) {
                [self.delegate didUpdateDetails];
                [[EBProgressIndicator sharedProgressIndicator]removeProcessFromQueue];
            }
        }
        else if (error){
            NSLog(@"%@",error);
            [[EBProgressIndicator sharedProgressIndicator]removeProcessFromQueue];
        }
    }];
}

-(void)voteUp{
    NSString *bodyData = [NSString stringWithFormat:@""];
    NSString *URLString = [NSString stringWithFormat:@"http://curul501.org/iniciativas/%@/vote_up", identificadorDeIniciativa];
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:[bodyData length]]];
    
    [NSURLConnection sendAsynchronousRequest:postRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               if (data){
                                   NSString *response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"response is %@", response);
                                   [self descargarDetalles];
                               }else if (error)
                                   NSLog(@"%@",error);
                           }];
}

-(void)voteDown{
    NSString *bodyData = [NSString stringWithFormat:@""];
    NSString *URLString = [NSString stringWithFormat:@"http://curul501.org/iniciativas/%@/vote_down", identificadorDeIniciativa];
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:[bodyData length]]];
    
    [NSURLConnection sendAsynchronousRequest:postRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               if (data){
                                   NSString *response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"response is %@", response);
                                   [self descargarDetalles];
                               }else if (error)
                                   NSLog(@"%@",error);
                           }];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"Congresista: %@ Fecha: %@ Descripción: %@ Estado: %@ Identificador: %@ Local a favor: %d Local en contra: %d Pleno a favor: %d Pleno en contra: %d Pleno abstenciones: %d Recursos adicionales: %@", self.nombreCongresista, self.fecha, self.descripcion, self.estado, self.identificadorDeIniciativa, self.localAFavorPorcentaje, self.localEnContraPorcentaje, self.plenoAFavor, self.plenoEnContra, self.plenoAbstenciones, self.recursosAdicionales];
}

@end
