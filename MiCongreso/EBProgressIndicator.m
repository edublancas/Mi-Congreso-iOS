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

#import "EBProgressIndicator.h"

@implementation EBProgressIndicator

static EBProgressIndicator * _sharedProgressIndicator = nil;

+(EBProgressIndicator*)sharedProgressIndicator
{
	@synchronized([EBProgressIndicator class])
	{
		if (!_sharedProgressIndicator)
			_sharedProgressIndicator = [[self alloc] init];
        
		return _sharedProgressIndicator;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([EBProgressIndicator class])
	{
		NSAssert(_sharedProgressIndicator == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedProgressIndicator = [super alloc];
		return _sharedProgressIndicator;
	}
    
	return nil;
}

-(id)init {
	self = [super init];
	if (self != nil) {
		// initialize stuff here
	}
    
	return self;
}


-(void)addProcessToQueue{
    count++;
    NSLog(@"Count up: %d", count);
    [self updateUI];
}
-(void)removeProcessFromQueue{
    if (count>=1){
        count--;
        NSLog(@"Count down: %d", count);
        [self updateUI];
    }else
        NSLog(@"Count is already 0");
    
}

-(void)updateUI{
    if (count) {
        //NSLog(@"Showing activity indicator");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [SVProgressHUD showWithStatus:@"Cargando..."];
    }else{
        //NSLog(@"Hiding activity indicator");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [SVProgressHUD dismiss];
    }
    
}


@end
