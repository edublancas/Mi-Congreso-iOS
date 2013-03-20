//
//  EBIniciativa.m
//  MiCongreso
//
//  Created by Edu on 16/03/13.
//  Copyright (c) 2013 Eduardo Blancas. All rights reserved.
//

#import "EBIniciativa.h"

@implementation EBIniciativa

@synthesize fecha, nombreCongresista, descripcion, estado,
identificadorDeIniciativa, localAFavor, localEnContra, plenoAbstenciones,
plenoAFavor, plenoEnContra;

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
        
    
        for (TFHppleElement *elemento in [[content firstChildWithClassName:@"estado"]children]) {
            //NSLog(@"Elemento: %@", [elemento objectForKey:@"class"]);
            if ([[elemento objectForKey:@"class"]isEqualToString:@""]) {
                break;
            }
            self.estado = [elemento objectForKey:@"class"];

        }
        
        self.identificadorDeIniciativa = [[[[content firstChildWithClassName:@"iniciativa_icon"]firstChildWithTagName:@"a"]objectForKey:@"href"]stringByReplacingOccurrencesOfString:@"/iniciativas/" withString:@""];
        
        [self descargarDetalles];
       
        
    }
    return self;
}

-(void)descargarDetalles{
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
                localAFavor = [string integerValue];
            }
            
            localEnContra = 100-localAFavor;
            
            NSString *queryPleno = @"//div[@class='votaciones']/ul[@class='votacion-pleno']/li";
            NSArray *plenoNodos = [detailsParser searchWithXPathQuery:queryPleno];
            self.plenoAFavor = [[[[plenoNodos objectAtIndex:1]firstChild]content]intValue];
            self.plenoEnContra = [[[[plenoNodos objectAtIndex:2]firstChild]content]intValue];
            self.plenoAbstenciones = [[[[plenoNodos objectAtIndex:3]firstChild]content]intValue];
            
            detallesDisponibles = YES;
            NSLog(@"Se descagaron detalles %@", self.identificadorDeIniciativa);
        }
        else if (error)
            NSLog(@"%@",error);
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
                               }else if (error)
                                   NSLog(@"%@",error);
                           }];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"Congresista: %@ Fecha: %@ Descripción: %@ Estado: %@ Identificador: %@ Local a favor: %d Local en contra: %d Pleno a favor: %d Pleno en contra: %d Pleno abstenciones: %d", self.nombreCongresista, self.fecha, self.descripcion, self.estado, self.identificadorDeIniciativa, self.localAFavor, self.localEnContra, self.plenoAFavor, self.plenoEnContra, self.plenoAbstenciones];
}

@end
