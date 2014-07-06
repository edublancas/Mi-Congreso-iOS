//
//  EBComision.m
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

#import "EBComision.h"

@implementation EBComision

@synthesize nombre, integrantesURL, sitiowebURL, theType, delegate, details;

- (id) initWithNombre:(NSString *)unNombre integrantes:(NSURL *)inURL sitioWeb:(NSURL *)siURL type:(NSUInteger)type{
    self = [super init];
    if (self){
        nombre = unNombre;
        integrantesURL = inURL;
        sitiowebURL = siURL;
        theType = type;
    }
    return self;
}

-(void)downloadDetails{
    
    if (details.count) {
        //Load details
        NSLog(@"Cargando integrantes de archivo local...");
        if ([(NSObject *)delegate respondsToSelector:@selector(didUpdateDetails)]) {
            [delegate didUpdateDetails];
        }
        
    }else{
        [[EBProgressIndicator sharedProgressIndicator]addProcessToQueue];
        //Download details
        NSLog(@"Downloading from: %@", [integrantesURL absoluteString]);
        //Senador
        if (theType==kSenador) {
            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:integrantesURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                if (data){
                    //NSString *receivedData = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                    //NSLog(@"Received HTML: %@", receivedData);
                    
                    TFHpple *parser = [TFHpple hppleWithHTMLData:data];
                    NSString *queryString = @"//div[@id='contenido_interior']//table/tr/td/table/tr/td/table";
                    NSArray *nodes = [parser searchWithXPathQuery:queryString];
                    
                    NSMutableArray *tmpArray = [[NSMutableArray alloc]init];
                    
                    for (TFHppleElement *element in nodes) {
                        TFHppleElement *a = [[element childrenWithTagName:@"tr"]objectAtIndex:0];
                        TFHppleElement *b = [[element childrenWithTagName:@"tr"]objectAtIndex:1];
                        
                        NSString *image = [[[[[[a childrenWithTagName:@"td"]objectAtIndex:0]childrenWithTagName:@"a"]objectAtIndex:0]firstChild]objectForKey:@"src"];
                        
                        NSString *imageString = [NSString stringWithFormat:@"%@%@", kSenadoresBaseURL, image];
                        
                        TFHppleElement *sub;
                        
                        NSUInteger theCount = [[[[[b firstChild]firstChild]firstChild]children]count];
                        
                        if (theCount==3 || theCount==5) {
                            sub = [[[b firstChild]firstChild]firstChild];
                        }else if(theCount==1){
                            sub = [[[[b firstChild]firstChild]firstChild]firstChild];
                        }
                        
                        //NSLog(@"sub: %@", sub);
                        
                        NSString *posicion = [[sub firstChild]content];
                        
                        NSString *elnombre = [[[sub children]objectAtIndex:2]content];
                        
                        NSString *partido;
                        
                        if ([[[b firstChild]children]count]==3) {
                            partido = [[[[b firstChild]children]objectAtIndex:2]objectForKey:@"title"];
                            
                        }else{
                            partido = [[[[[b firstChild]firstChild]children]objectAtIndex:2]objectForKey:@"title"];
                        }
                        
                        
                        //Hay un error en la página del senado, en algunos casos no se muestra el nombre del integrante ni algún otro dato, en ese caso ignorarlo
                        if (![elnombre isEqualToString:@"Sen.     "]) {
                            //NSLog(@"b: %@ - %@ - %@ - %@", elnombre, posicion, imageString, partido);
                            
                            NSDictionary *dic = @{@"nombre": elnombre, @"posicion": posicion, @"image": imageString, @"partido":partido, @"tipo": @(kSenador)};
                            
                            [tmpArray addObject:dic];
                        }else{
                            NSLog(@"Nombre en blanco...");
                        }
                        
                    }
                    details = [[NSArray alloc]initWithArray:tmpArray];
                    
                    
                    
                    //Save into plist file
                    //Get path
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    NSString *path = [documentsDirectory stringByAppendingString:@"/comisionesOrdinariasSenadores.plist"];
                    //Load contents
                    NSMutableArray *cArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
                    //Add new info
                    NSMutableDictionary *mutable;
                    NSUInteger index=0;
                    for (int i=0; i<cArray.count; i++) {
                        NSDictionary *comisionDic = [cArray objectAtIndex:i];
                        if ([[comisionDic objectForKey:@"nombre"]isEqualToString:self.nombre]) {
                            mutable = [comisionDic mutableCopy];
                            index = i;
                            break;
                        }
                    }
                    [mutable setObject:details forKey:@"details"];
                    [cArray replaceObjectAtIndex:index withObject:mutable];
                    
                    //Re-write file
                    [cArray writeToFile:path atomically: YES];
                    
                    
                    
                    
                    if ([(NSObject *)delegate respondsToSelector:@selector(didUpdateDetails)]) {
                        [delegate didUpdateDetails];
                        [[EBProgressIndicator sharedProgressIndicator]removeProcessFromQueue];
                    }
                    
                }
                else if (error){
                    NSLog(@"%@",error);
                    [[EBProgressIndicator sharedProgressIndicator]removeProcessFromQueue];
                }
            }];
            //Diputado
        }else{
            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:integrantesURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                if (data){
                    TFHpple *parser = [TFHpple hppleWithHTMLData:data];
                    NSString *queryString = @"//table/tr[4]/td[1]/table[1]/tr";
                    NSArray *nodes = [parser searchWithXPathQuery:queryString];
                    NSMutableArray *tmpArray = [[NSMutableArray alloc]init];
                    
                    int i=0;
                    for (TFHppleElement *element in nodes) {
                        //Do stuff...
                        if ([[[element firstChildWithTagName:@"td"]objectForKey:@"class"]isEqualToString:@"TitulosVerde"]) {
                            i++;
                        }
                        NSString *posicion;
                        
                        switch (i) {
                            case 1:
                                posicion = @"PRESIDENTE";
                                break;
                            case 2:
                                posicion = @"SECRETARIO";
                                break;
                            case 3:
                                posicion = @"INTEGRANTE";
                                break;
                            default:
                                break;
                        }
                        
                        
                        if ([element objectForKey:@"bgcolor"]) {
                            NSMutableString *elnombre = [[NSMutableString alloc]init];
                            [elnombre setString:@"Dip. "];
                            
                            NSMutableString *string = [[NSMutableString alloc]init];
                            [string setString:[[[[element firstChildWithTagName:@"td"]firstChildWithTagName:@"a"]firstChild]content]];
                            
                            [string replaceOccurrencesOfString:@"[^A-Za-z áéíóú]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, elnombre.length)];
                            [string deleteCharactersInRange:NSMakeRange(0, 63)];
                            
                            [elnombre appendString:string];
                            
#warning solo se esta guardando nombre y posicion, ¿guardar lo demas?
                            
                            
                            
                            NSLog(@"%@", elnombre);
                            
                            NSDictionary *dic = @{@"nombre": elnombre,
                                                  @"posicion": posicion,
                                                  @"image": @"",
                                                  @"partido":@"",
                                                  @"tipo": @(kDiputado)};
                            
                            [tmpArray addObject:dic];
                            
                            NSLog(@"adding: %@", dic);
                            
                        }
                        
                    }
                    details = [[NSArray alloc]initWithArray:tmpArray];
                    
                    
                    
                    //Save into plist file
                    //Get path
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    NSString *path = [documentsDirectory stringByAppendingString:@"/comisionesOrdinariasDiputados.plist"];
                    //Load contents
                    NSMutableArray *cArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
                    //Add new info
                    NSMutableDictionary *mutable;
                    NSUInteger index=0;
                    for (int i=0; i<cArray.count; i++) {
                        NSDictionary *comisionDic = [cArray objectAtIndex:i];
                        if ([[comisionDic objectForKey:@"nombre"]isEqualToString:self.nombre]) {
                            mutable = [comisionDic mutableCopy];
                            index = i;
                            break;
                        }
                    }
                    [mutable setObject:details forKey:@"details"];
                    [cArray replaceObjectAtIndex:index withObject:mutable];
                    
                    //Re-write file
                    [cArray writeToFile:path atomically: YES];
                    
                    
                    if ([(NSObject *)delegate respondsToSelector:@selector(didUpdateDetails)]) {
                        [delegate didUpdateDetails];
                        [[EBProgressIndicator sharedProgressIndicator]removeProcessFromQueue];
                    }
                    
                }
                else if (error){
                    NSLog(@"%@",error);
                    [[EBProgressIndicator sharedProgressIndicator]removeProcessFromQueue];
                }
            }];
            
            
        }
    }
    
}

-(NSDictionary *)exportAsDictionary{
    NSMutableDictionary *mutable = [[NSMutableDictionary alloc]init];
    if (self.nombre)
        [mutable setObject:self.nombre forKey:@"nombre"];
    if (self.integrantesURL)
        [mutable setObject:[self.integrantesURL absoluteString] forKey:@"integrantesURL"];
    if (self.sitiowebURL)
        [mutable setObject:[self.sitiowebURL absoluteString] forKey:@"sitiowebURL"];
    if (self.theType)
        [mutable setObject:@(self.theType) forKey:@"theType"];
    if (self.details)
        [mutable setObject:self.details forKey:@"details"];
        
    return [mutable copy];
}

-(id)initWithDic:(NSDictionary *)plistDic type:(NSUInteger)type{
    self = [super init];
    if (self) {
        nombre = [plistDic objectForKey:@"nombre"];
        integrantesURL = [NSURL URLWithString:[plistDic objectForKey:@"integrantesURL"]];
        sitiowebURL = [NSURL URLWithString:[plistDic objectForKey:@"sitiowebURL"]];
        theType = [[plistDic objectForKey:@"theType"]integerValue];
        details = [plistDic objectForKey:@"details"];
        theType = type;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Nombre: %@", self.nombre];
}

@end
