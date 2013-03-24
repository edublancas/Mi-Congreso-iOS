//
//  EBCongresista.m
//  MiCongreso
//
//  Created by Edu on 16/03/13.
//  Copyright (c) 2013 Eduardo Blancas. All rights reserved.
//

#import "EBCongresista.h"

@implementation EBCongresista

@synthesize nombre, direccion, telefono, email, suplente, tipo, imagen, partido,
estado, detallesString, detallesDisponibles, delegate;

- (id) initWithElement:(TFHppleElement *)element{
    self = [super init];
    if (self){
        self.imagen = [NSURL URLWithString:[[[[[element childrenWithTagName:@"td"]objectAtIndex:0]firstChildWithTagName:@"a"]firstChildWithTagName:@"img"]objectForKey:@"src"]];
        self.nombre = [[[[[element childrenWithTagName:@"td"]objectAtIndex:1]firstChildWithTagName:@"a"]firstChild]content];
        
        NSString *partidoEstado  = [[[[[[element childrenWithTagName:@"td"]objectAtIndex:1]firstChildWithTagName:@"a"]children]lastObject]content];
        
        NSArray *partidoEstadoArray = [partidoEstado componentsSeparatedByString:@" "];
        
        NSMutableString *string = [[NSMutableString alloc]initWithString:[[partidoEstado componentsSeparatedByString:@" "]objectAtIndex:0]];
        
        if (partidoEstadoArray.count>2){
            for (int i =1; i<partidoEstadoArray.count-1; i++) {
                [string appendString:@" "];
                [string appendString:[partidoEstadoArray objectAtIndex:i]];
            }
        }
        
        self.estado = (NSString *)string;
        
        
        NSMutableString *mutablePartido = [[NSMutableString alloc]init];
        
        [mutablePartido setString:[[partidoEstado componentsSeparatedByString:@" "]lastObject]];
        [mutablePartido replaceOccurrencesOfString:@"(" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [mutablePartido length])];
        [mutablePartido replaceOccurrencesOfString:@")" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [mutablePartido length])];
        
        if ([mutablePartido isEqualToString:@"SG"]) {
            //Fix
            NSString *str  = [[[[[element childrenWithTagName:@"td"]objectAtIndex:1]firstChildWithTagName:@"a"]firstChildWithTagName:@"img"]objectForKey:@"src"];
            
            if (!([str rangeOfString:@"Ciudadano"].location == NSNotFound)) {
                [mutablePartido setString:@"MC"];
            }
            
            if (!([str rangeOfString:@"nueva"].location == NSNotFound)) {
                [mutablePartido setString:@"NA"];
            }
            
            //NSLog(@"Fix partido :%@", self.partido);
        }
        
        self.partido = (NSString *)mutablePartido;
        
        self.detallesString = [NSString stringWithFormat:@"http://www.senado.gob.mx/%@", [[[[element childrenWithTagName:@"td"]objectAtIndex:0]firstChildWithTagName:@"a"]objectForKey:@"href"]];
    
        //NSLog(@"Img: %@ Nombre: %@ Partido: %@ Estado: %@ Detalles: %@", self.imagen, self.nombre, self.partido, self.estado, detalles);
        
        //[self descargarDetalles];
        self.tipo = kSenador;
        
    }
    return self;
}

-(id)initWithCongresoRestDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.nombre = [dic objectForKey:@"nombre"];
        self.email = [dic objectForKey:@"email"];
        self.suplente = [dic objectForKey:@"suplente"];
        self.partido = [dic objectForKey:@"fraccion"];
        if ([self.partido isEqualToString:@"Verde"]) {
            self.partido = @"PV";
        }else if ([self.partido isEqualToString:@"Movimiento Ciudadano"]) {
            self.partido = @"MC";
        }else if ([self.partido isEqualToString:@"PANAL"]) {
            self.partido = @"NA";
        }
        self.estado = [dic objectForKey:@"entidad"];
        self.tipo = kDiputado;
    }
    return self;
}

-(void)descargarDetalles{
    if (self.tipo==kSenador) {
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.detallesString]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            if (data){
                TFHpple *detailsParser = [TFHpple hppleWithHTMLData:data];
                
                NSString *query = @"//div[@id='contenedor']/div[@id='cuerpo']/div[@id='contenido_interior']/table/tr/td/table/tr/td/blockquote";
                
                NSArray *detallesNodes = [detailsParser searchWithXPathQuery:query];
                
                NSMutableString *mdireccion = [[NSMutableString alloc]init];
                
                if ([detallesNodes count]) {
                    TFHppleElement *element = [detallesNodes objectAtIndex:0];
                    for (TFHppleElement *children in [element children]) {
                        //NSLog(@"Content: %@", [children content]);
                        if ([children content]) {
                            [mdireccion appendString:[children content]];
                        }
                    }
                }
                
                [mdireccion replaceOccurrencesOfString:@"[^A-Za-z0-9,. áéíóú]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, mdireccion.length)];
                
                //[mdireccion replaceOccurrencesOfString:@"\t" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, mdireccion.length)];
                
                self.direccion = [mdireccion copy];
                
                NSLog(@"Dirección: %@", self.direccion);
                
                NSString *phoneQuery1 = @"//div[@id='contenedor']/div[@id='cuerpo']/div[@id='contenido_interior']/table[1]/tr[2]/td[2]/table[1]/tr[6]/td[2]";
                NSString *phoneQuery2 = @"//div[@id='contenedor']/div[@id='cuerpo']/div[@id='contenido_interior']/table[1]/tr[2]/td[2]/table[1]/tr[5]/td[2]";
                
                NSArray *result = [detailsParser searchWithXPathQuery:phoneQuery1];
                
                if (result.count) {
                    self.telefono = [[[result objectAtIndex:0]firstChild]content];
                }else{
                    NSArray *result2 = [detailsParser searchWithXPathQuery:phoneQuery2];
                    self.telefono = [[[result2 objectAtIndex:0]firstChild]content];
                }
                
                self.telefono = [self.telefono stringByReplacingOccurrencesOfString:@"[^A-Za-z0-9:,-]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [self.telefono length])];
                
                //NSLog(@"Telefono: %@", self.telefono);
                
                NSString *mailQuery1 = @"//div[@id='contenedor']/div[@id='cuerpo']/div[@id='contenido_interior']/table[1]/tr[2]/td[2]/table[1]/tr[10]/td[1]";
                NSString *mailQuery2 = @"//div[@id='contenedor']/div[@id='cuerpo']/div[@id='contenido_interior']/table[1]/tr[2]/td[2]/table[1]/tr[9]/td[1]";
                
                NSArray *resultMail1 = [detailsParser searchWithXPathQuery:mailQuery1];
                //NSLog(@"resultmail1 %@", resultMail1);
                
                if (resultMail1.count) {
                    self.email = [[[[detailsParser searchWithXPathQuery:mailQuery1]objectAtIndex:0]firstChild]content];
                    if (!self.email) {
                        NSArray *result2 = [detailsParser searchWithXPathQuery:mailQuery2];
                        self.email = [[[result2 objectAtIndex:0]firstChild]content];
                    }
                }
                
                self.email = [self.email stringByReplacingOccurrencesOfString:@"[^A-Za-z0-9@._-]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [self.email length])];
                
                NSString *suplenteQuery = @"//div[@id='contenedor']/div[@id='cuerpo']/div[@id='contenido_interior']/table/tr/td/table/tr/td";
                NSArray *suplenteArray = [detailsParser searchWithXPathQuery:suplenteQuery];
                self.suplente = [[[[suplenteArray lastObject]children]objectAtIndex:1]content];
                //NSLog(@"Suplente: %@", self.suplente);
                
                
                NSString *imageQuery = @"//img[@class='marco_2']";
                NSArray *imageArray = [detailsParser searchWithXPathQuery:imageQuery];
                //NSLog(@"Image: %@", [[imageArray objectAtIndex:0]objectForKey:@"src"]);
                self.imagen = [NSURL URLWithString:[@"http://www.senado.gob.mx/" stringByAppendingString:[[imageArray objectAtIndex:0]objectForKey:@"src"]]];
                
                self.detallesDisponibles = YES;
                //NSLog(@"Mail: %@", self.email);
                
                if ([(NSObject *)delegate respondsToSelector:@selector(didUpdateDetails)]) {
                    [delegate didUpdateDetails];
                }
                
            }
            else if (error)
                NSLog(@"%@",error);
        }];
    }else{
        /*
        NSDictionary *keys = @{@"PRI": @"1", @"PAN": @"2", @"PRD": @"3", @"PT": @"4",
                               @"PV": @"5", @"MC": @"6", @"NA": @"7"};
        NSString *key = [keys objectForKey:self.partido];
        NSString *urlString = [NSString stringWithFormat:@"http://curul501.org/partido_politico/%@", key];
        
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            if (data){
                TFHpple *detailsParser = [TFHpple hppleWithHTMLData:data];
                NSString *query = @"//div[@class='congresista']/ul";
                NSArray *detallesNodes = [detailsParser searchWithXPathQuery:query];
                for (TFHppleElement *element in detallesNodes) {
                    NSMutableString *mutableString = [[NSMutableString alloc]init];
                    [mutableString setString:[[[[element firstChildWithClassName:@"nombre"]firstChildWithTagName:@"a"]firstChild]content]];
                    
                    NSArray *originQuery = [self.nombre componentsSeparatedByString:@" "];
                    for (NSString *originComponent in originQuery) {
                        [mutableString replaceOccurrencesOfString:originComponent withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mutableString.length)];
                    }
                    
                }
                
            }
            else if (error)
                NSLog(@"%@",error);
        }];*/
        
        
         [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.detallesString]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *detailsResponse, NSData *detailsData, NSError *detailsError) {
         if (detailsData) {
             TFHpple *detailsParser = [TFHpple hppleWithHTMLData:detailsData];
             NSString *detailsQuery = @"//table/tr/td/table/tr/td/a[@class='linkNegroSin']";
             NSArray *detailsNodes = [detailsParser searchWithXPathQuery:detailsQuery];
             if (detailsNodes.count) {
                 //NSLog(@"%@", [[detailsNodes objectAtIndex:0]objectForKey:@"href"]);
                 NSString *queryMail = [[detailsNodes objectAtIndex:0]objectForKey:@"href"];
                 
                 self.email = [queryMail stringByReplacingOccurrencesOfString:@"mailto: " withString:@""];
                 
             }
             
             NSString *suplenteQuery = @"//table/tr/td/table/tr/td/span[@class='Estilo67']";
             NSArray *suplenteNodes = [detailsParser searchWithXPathQuery:suplenteQuery];
             if (suplenteNodes.count) {
                 /*for (int i = 0; i<suplenteNodes.count; i++) {
                     NSLog(@"%d - %@", i, [suplenteNodes objectAtIndex:i]);
                 }*/
                 NSMutableString *mutable = [[NSMutableString alloc]init];
                 [mutable setString:[[[suplenteNodes objectAtIndex:6]firstChild]content]];
                 [mutable replaceOccurrencesOfString:@"[^A-Za-z ]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, mutable.length)];
                 [mutable replaceOccurrencesOfString:@"Suplente " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, mutable.length)];
                 //NSLog(@"Suplente: %@", mutable);
                 self.suplente = mutable;
             }
             
             
             NSString *imageQuery = @"//table/tr/td/table/tr/td/img";
             NSArray *imageNodes = [detailsParser searchWithXPathQuery:imageQuery];
             if (imageNodes.count) {
                 NSMutableString *mutable = [[NSMutableString alloc]init];
                 [mutable setString:[[imageNodes objectAtIndex:0]objectForKey:@"src"]];
                 [mutable replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
                 NSString *urlString = [@"http://sitl.diputados.gob.mx/LXII_leg" stringByAppendingString:mutable];
                 self.imagen = [NSURL URLWithString:urlString];
             }
             
             self.detallesDisponibles = YES;
             
             if ([(NSObject *)delegate respondsToSelector:@selector(didUpdateDetails)]) {
                 [delegate didUpdateDetails];
             }
             
         
         }else if (detailsError) {
             NSLog(@"%@", detailsError);
         }
         }];
        

    }
    
}

-(NSDictionary *)exportAsDictionary{
    NSMutableDictionary *mutable = [[NSMutableDictionary alloc]init];
    if (self.nombre)
        [mutable setObject:self.nombre forKey:@"nombre"];
    if (self.partido)
        [mutable setObject:self.partido forKey:@"partido"];
    if (self.estado)
        [mutable setObject:self.estado forKey:@"estado"];
    if (self.detallesString)
        [mutable setObject:self.detallesString forKey:@"detallesString"];
    return [mutable copy];
}

-(id)initWithDic:(NSDictionary *)plistDic type:(NSUInteger)type;{
    self = [super init];
    if (self) {
        self.nombre = [plistDic objectForKey:@"nombre"];
        self.email = [plistDic objectForKey:@"email"];
        self.partido = [plistDic objectForKey:@"partido"];
        self.estado = [plistDic objectForKey:@"estado"];
        self.detallesString = [plistDic objectForKey:@"detallesString"];
        self.tipo = type;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Nombre: %@", self.nombre];
}

@end
