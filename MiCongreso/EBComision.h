//
//  EBComision.h
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
#import "TFHpple.h"
#import "TFHppleElement.h"


@protocol EBComisionDelegate
-(void)didUpdateDetails;
@end

@interface EBComision : NSObject{
    NSString *nombre;
    NSURL *integrantesURL;
    NSURL *sitiowebURL;
    NSUInteger theType;
    NSArray *details;
    
    id <EBComisionDelegate> delegate;
}


@property(nonatomic, retain, readonly)NSString *nombre;
@property(nonatomic, retain, readonly)NSURL *integrantesURL;
@property(nonatomic, retain, readonly)NSURL *sitiowebURL;
@property(nonatomic, assign, readonly)NSUInteger theType;
@property(nonatomic, retain, readonly)NSArray *details;
@property(nonatomic, retain)id <EBComisionDelegate> delegate;

- (id) initWithNombre:(NSString *)unNombre integrantes:(NSURL *)inURL sitioWeb:(NSURL *)siURL type:(NSUInteger)type;
-(void)downloadDetails;


-(NSDictionary *)exportAsDictionary;
-(id)initWithDic:(NSDictionary *)plistDic type:(NSUInteger)type;


@end
