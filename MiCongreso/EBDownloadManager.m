//
//  EBDownloadManager.m
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


#import "EBDownloadManager.h"

@implementation EBDownloadManager

@synthesize delegate;

-(id)init{
    self = [super init];
    if (self) {
        diputados = [[NSMutableDictionary alloc]init];
        senadores = [[NSMutableDictionary alloc]init];
        diputadosArray = [[NSMutableArray alloc]init];
    }
    return self;
}




-(void)descargarDiputados{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingString:@"/diputados.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]){
        
        NSOperationQueue *downloadQueue = [[NSOperationQueue alloc]init];
        
        
        NSArray *URLKeys = @[@1, @3, @2, @5, @6, @4, @12];
        NSArray *partidos = @[@"PRI", @"PAN", @"PRD", @"PV", @"MC", @"PT", @"NA"];
        
        for (int i = 0; i<URLKeys.count; i++) {
            NSString *partido = [partidos objectAtIndex:i];
            NSString *urlString = [NSString stringWithFormat:@"%@LXII_leg/listado_diputados_gpnp.php?tipot=%d", kDiputadosBaseURLsitl,[[URLKeys objectAtIndex:i]integerValue]];
            NSURL *URL = [NSURL URLWithString:urlString];
            
            
            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:URL] queue:downloadQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                if (data){
                    TFHpple *parser = [TFHpple hppleWithHTMLData:data];
                    NSString *queryString = @"//table/tr/td/table/tr";
                    NSArray *nodos = [parser searchWithXPathQuery:queryString];
                    if ([nodos count]) {
                        for (TFHppleElement *elemento in nodos) {
                            NSArray *datos = [NSArray arrayWithArray:[elemento childrenWithClassName:@"textoNegro"]];
                            if (datos.count==3) {
                                NSMutableString *detalles = [[NSMutableString alloc]init];
                                [detalles setString:kDiputadosBaseURLsitl];
                                [detalles appendString:@"LXII_leg/"];
                                [detalles appendString:[[[datos objectAtIndex:0]firstChild]objectForKey:@"href"]];
                                
                                NSMutableString *nombreMutable = [[NSMutableString alloc]initWithString:[[[[datos objectAtIndex:0]firstChild]firstChild]content]];
                                
                                NSArray *componens = [nombreMutable componentsSeparatedByString:@" "];
                                
                                [nombreMutable setString:@""];
                                
                                for (int i=1; i<componens.count; i++) {
                                    if (i!=1) {
                                        [nombreMutable appendString:@" "];
                                    }
                                    [nombreMutable appendString:[componens objectAtIndex:i]];
                                }
                                
                                NSString *estado = [[[datos objectAtIndex:1]firstChild]content];
                                
                                //NSString *distrito = [[[datos objectAtIndex:2]firstChild]content];
                                                                
                                
                                
                                //NSLog(@"Nombre: %@ Estado: %@ Distrito: %@ Partido: %@", nombreMutable, estado, distrito, partido);
                                NSDictionary *dic = @{@"nombre": nombreMutable, @"estado": estado, @"partido": partido, @"detallesString": detalles};
                                
                                EBCongresista *diputado = [[EBCongresista alloc]initWithDic:dic type:kDiputado];
                                [diputadosArray addObject:diputado];
                                [self countUpDiputados];
                            }
                        }
                        
                    }
                    
                }
                else if (error)
                    NSLog(@"%@",error);
            }];
            
        }
        
        
        
    }else{
        NSLog(@"Cargando datos locales de diputados...");
        //Cargar datos locales
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSArray *keys = [dic allKeys];
        
        //NSLog(@"Dic: %@", dic);
        
        for (int i=0; i<[keys count]; i++) {
            NSMutableArray *mutable = [[NSMutableArray alloc]init];
            NSArray *arrayFromPlist = [dic objectForKey:[keys objectAtIndex:i]];
            for (NSDictionary *diputadoDic in arrayFromPlist) {
                EBCongresista *diputado = [[EBCongresista alloc]initWithDic:diputadoDic type:kDiputado];
                [mutable addObject:diputado];
            }
            [diputados setObject:mutable forKey:[keys objectAtIndex:i]];
        }
        //NSLog(@"Parsed dic: %@", diputados);
        if ([(NSObject *)delegate respondsToSelector:@selector(seDescargaronDiputados:)]) {
            [delegate seDescargaronDiputados:diputados];
        }
        
    }

}

-(void)countUpDiputados{
    //NSLog(@"Diputados count: %d", diputadosArray.count);
    if (diputadosArray.count==500) {
        //Procesar arreglo
        
        for (EBCongresista *diputado in diputadosArray) {
            //Inicial del primer apellido
            NSString *inicial = [[diputado.nombre substringToIndex:1]uppercaseString];
            ;
            if ([inicial isEqualToString:@"Á"])
                inicial = @"A";
            if ([inicial isEqualToString:@"É"])
                inicial = @"E";
            if ([inicial isEqualToString:@"Í"])
                inicial = @"I";
            if ([inicial isEqualToString:@"Ó"])
                inicial = @"O";
            if ([inicial isEqualToString:@"Ú"])
                inicial = @"U";
            
            //Conseguir una referencia al arreglo que empieza con esa letra
            NSMutableArray *array = [diputados objectForKey:inicial];
            //Si no existe, crearla
            if (!array) {
                array = [[NSMutableArray alloc]init];
                [diputados setObject:array forKey:inicial];
            }
            
            [array addObject:diputado];
        }
        
        //NSLog(@"Diputados dic: %@", diputados);
        if ([(NSObject *)delegate respondsToSelector:@selector(seDescargaronDiputados:)]) {
            [delegate seDescargaronDiputados:diputados];
            [self guardarDiputados];
        }
    }
}

-(void)descargarSenadores{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingString:@"/senadores.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]){
        char letra;
        
        
        for (letra = 'A'; letra<='Z'; letra++) {
            //NSLog(@"%c", letra);
            
            NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?ver=int&mn=9&sm=1&str=%c", kSenadoresBaseURL, letra]];
            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:URL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                if (data){
                    TFHpple *parser = [TFHpple hppleWithHTMLData:data];
                    NSString *queryString = @"//div[@id='contenido_interior']/table/tr/td/table/tr";
                    NSArray *nodos = [parser searchWithXPathQuery:queryString];
                    NSMutableArray *senadoresArray = [[NSMutableArray alloc]init];
                    if ([nodos count]) {
                        for (TFHppleElement *elemento in nodos) {
                            EBCongresista *congresista = [[EBCongresista alloc]initWithElement:elemento];
                            [senadoresArray addObject:congresista];
                        }
                        //NSLog(@"Array for %c is %@ count %d", letra, senadoresArray, senadoresArray.count);
                        if (senadoresArray.count) {
                            [senadores setObject:senadoresArray forKey:[NSString stringWithFormat:@"%c", letra]];
                        }
                        [self countUpSenadores];
                        
                    }
                    
                }
                else if (error)
                    NSLog(@"%@",error);
            }];
            
        }
        
    }else{
        NSLog(@"Cargando datos locales de senadores...");
        //Cargar datos locales
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSArray *keys = [dic allKeys];
        
        //NSLog(@"Dic: %@", dic);
        
        for (int i=0; i<[keys count]; i++) {
            NSMutableArray *mutable = [[NSMutableArray alloc]init];
            NSArray *arrayFromPlist = [dic objectForKey:[keys objectAtIndex:i]];
            for (NSDictionary *senadorDic in arrayFromPlist) {
                EBCongresista *senador = [[EBCongresista alloc]initWithDic:senadorDic type:kSenador];
                [mutable addObject:senador];
            }
            [senadores setObject:mutable forKey:[keys objectAtIndex:i]];
        }
        //NSLog(@"Parsed dic: %@", senadores);
        if ([(NSObject *)delegate respondsToSelector:@selector(sedescargaronSenadores:)]) {
            [delegate sedescargaronSenadores:senadores];
        }
        
    }
    
    
}

-(void)countUpSenadores{
    count++;
    NSLog(@"ccount: %d", count);
    if (count>=20) {
        if ([(NSObject *)delegate respondsToSelector:@selector(sedescargaronSenadores:)]) {
            [delegate sedescargaronSenadores:senadores];
            [self guardarSenadores];
        }
    }
}


-(void)guardarDiputados{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingString:@"/diputados.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]){
        NSDictionary *emptyDic = [NSDictionary dictionary];
        [emptyDic writeToFile:path atomically:YES];
    }
    
    NSMutableDictionary *mutable = [[NSMutableDictionary alloc]init];
    NSArray *keys = [diputados allKeys];
    for (NSString *aKey in keys) {
        
        NSArray *array = [diputados objectForKey:aKey];
        NSMutableArray *convertedArray = [[NSMutableArray alloc]init];
        for (EBCongresista *diputado in array) {
            diputado.nombre = [NSString stringWithFormat:@"Dip. %@", diputado.nombre];
            [convertedArray addObject:[diputado exportAsDictionary]];
        }
        [mutable setObject:convertedArray forKey:aKey];
    }
    
    NSLog(@"Guardando diputados: %@", mutable);
    [mutable writeToFile:path atomically:YES];
    
}

-(void)guardarSenadores{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingString:@"/senadores.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]){
        NSDictionary *emptyDic = [NSDictionary dictionary];
        [emptyDic writeToFile:path atomically:YES];
    }
    NSMutableDictionary *mutable = [[NSMutableDictionary alloc]init];
    NSArray *keys = [senadores allKeys];
    for (NSString *aKey in keys) {
        NSArray *array = [senadores objectForKey:aKey];
        NSMutableArray *convertedArray = [[NSMutableArray alloc]init];
        for (EBCongresista *senador in array) {
            senador.nombre = [senador.nombre stringByReplacingOccurrencesOfString:@"Sen. " withString:@""];
            NSArray *components = [senador.nombre componentsSeparatedByString:@" "];
            NSMutableString *mutable = [[NSMutableString alloc]init];
            NSUInteger lowerBound = components.count-2;
            [mutable appendString:[components objectAtIndex:lowerBound]];
            [mutable appendString:@" "];
            [mutable appendString:[components objectAtIndex:lowerBound+1]];
            [mutable appendString:@" "];
            for (int i = 0; i<lowerBound; i++) {
                [mutable appendString:@" "];
                [mutable appendString:[components objectAtIndex:i]];
            }
            senador.nombre = [NSString stringWithFormat:@"Sen. %@", mutable];
            
            [convertedArray addObject:[senador exportAsDictionary]];
        }
        [mutable setObject:convertedArray forKey:aKey];
    }
    
    NSLog(@"Guardando senadores: %@", mutable);
    [mutable writeToFile:path atomically:YES];
    
}

@end
