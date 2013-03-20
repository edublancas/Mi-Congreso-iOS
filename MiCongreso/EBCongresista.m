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
estado, detalles;

- (id) initWithElement:(TFHppleElement *)element{
    self = [super init];
    if (self){
        self.imagen = [NSURL URLWithString:[[[[[element childrenWithTagName:@"td"]objectAtIndex:0]firstChildWithTagName:@"a"]firstChildWithTagName:@"img"]objectForKey:@"src"]];
        self.nombre = [[[[[element childrenWithTagName:@"td"]objectAtIndex:1]firstChildWithTagName:@"a"]firstChild]content];
        
        NSString *partidoEstado  = [[[[[[element childrenWithTagName:@"td"]objectAtIndex:1]firstChildWithTagName:@"a"]children]lastObject]content];
        
        self.estado = [[partidoEstado componentsSeparatedByString:@" "]objectAtIndex:0];
        self.partido = [[partidoEstado componentsSeparatedByString:@" "]lastObject];
        self.partido = [self.partido stringByReplacingOccurrencesOfString:@"(" withString:@""];
        self.partido = [self.partido stringByReplacingOccurrencesOfString:@")" withString:@""];
        
        if ([self.partido isEqualToString:@"SG"]) {
            //Fix
            NSString *str  = [[[[[element childrenWithTagName:@"td"]objectAtIndex:1]firstChildWithTagName:@"a"]firstChildWithTagName:@"img"]objectForKey:@"src"];
            
            if (!([str rangeOfString:@"Ciudadano"].location == NSNotFound)) {
                self.partido = @"MC";
            }
            
            if (!([str rangeOfString:@"nueva"].location == NSNotFound)) {
                self.partido = @"NA";
            }
            
            //NSLog(@"Fix partido :%@", self.partido);
        }
        
        self.detalles = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.senado.gob.mx/%@", [[[[element childrenWithTagName:@"td"]objectAtIndex:0]firstChildWithTagName:@"a"]objectForKey:@"href"]]];
    
        //NSLog(@"Img: %@ Nombre: %@ Partido: %@ Estado: %@ Detalles: %@", self.imagen, self.nombre, self.partido, self.estado, detalles);
        
        [self descargarDetalles];
        
    }
    return self;
}

-(void)descargarDetalles{
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:self.detalles] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
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
            
            NSString *phoneQuery1 = @"//div[@id='contenedor']/div[@id='cuerpo']/div[@id='contenido_interior']/table[1]/tr[2]/td[2]/table[1]/tr[6]/td[2]";
            NSString *phoneQuery2 = @"//div[@id='contenedor']/div[@id='cuerpo']/div[@id='contenido_interior']/table[1]/tr[2]/td[2]/table[1]/tr[5]/td[2]";
            
            NSArray *result = [detailsParser searchWithXPathQuery:phoneQuery1];
            
            if (result.count) {
                self.telefono = [[[result objectAtIndex:0]firstChild]content];
            }else{
                NSArray *result2 = [detailsParser searchWithXPathQuery:phoneQuery2];
                self.telefono = [[[result2 objectAtIndex:0]firstChild]content];
            }
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
            
            //NSLog(@"Mail: %@", self.email);
            
            
            
            self.direccion = (NSString *)[mdireccion copy];
     
        }
        else if (error)
            NSLog(@"%@",error);
    }];
    
}

@end
