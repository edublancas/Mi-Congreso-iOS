//
//  EBAppDelegate.m
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

#import "EBAppDelegate.h"

@implementation EBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [[UITabBar appearance]setBackgroundImage:[UIImage imageNamed:@"tabBar.png"]];
    [[UITabBar appearance]setSelectedImageTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"navBar.png"] forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance]setTintColor:[UIColor colorWithRed:0.843 green:0.601 blue:0.290 alpha:1.000]];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pathSenadores = [documentsDirectory stringByAppendingString:@"/senadores.plist"];
    NSString *pathComSenadores = [documentsDirectory stringByAppendingString:@"/comisionesOrdinariasSenadores.plist"];
    NSString *pathDiputados = [documentsDirectory stringByAppendingString:@"/diputados.plist"];
    NSString *pathComDiputados = [documentsDirectory stringByAppendingString:@"/comisionesOrdinariasDiputados.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathDiputados]){
        //Copiar archivo
        NSLog(@"Copiando diputados.plist");
        NSString *source = [[NSBundle mainBundle] pathForResource:@"diputados" ofType:@"plist"];
        [fileManager copyItemAtPath:source toPath:pathDiputados error:nil];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathSenadores]){
        //Copiar archivo
        NSLog(@"Copiando senadores");
        NSString *source = [[NSBundle mainBundle] pathForResource:@"senadores" ofType:@"plist"];
        [fileManager copyItemAtPath:source toPath:pathSenadores error:nil];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathComDiputados]){
        //Copiar archivo
        NSLog(@"Copiando comisionesOrdinariasDiputados.plist");
        NSString *source = [[NSBundle mainBundle] pathForResource:@"comisionesOrdinariasDiputados" ofType:@"plist"];
        [fileManager copyItemAtPath:source toPath:pathComDiputados error:nil];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathComSenadores]){
        //Copiar archivo
        NSLog(@"Copiando comisionesOrdinariasSenadores.plist");
        NSString *source = [[NSBundle mainBundle] pathForResource:@"comisionesOrdinariasSenadores" ofType:@"plist"];
        [fileManager copyItemAtPath:source toPath:pathComSenadores error:nil];
    }
    
    
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
