//
//  EBAppDelegate.m
//  MiCongreso
//
//  Created by Edu on 16/03/13.
//  Copyright (c) 2013 Eduardo Blancas. All rights reserved.
//

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
    NSString *pathDiputados = [documentsDirectory stringByAppendingString:@"/diputados.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathDiputados]){
        //Copiar archivo
        NSString *sourceDiputados = [[NSBundle mainBundle] pathForResource:@"diputados" ofType:@"plist"];
        [fileManager copyItemAtPath:sourceDiputados toPath:pathDiputados error:nil];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathSenadores]){
        //Copiar archivo
        NSString *sourceSenadores = [[NSBundle mainBundle] pathForResource:@"senadores" ofType:@"plist"];
        [fileManager copyItemAtPath:sourceSenadores toPath:pathSenadores error:nil];
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
