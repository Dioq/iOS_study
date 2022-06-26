//
//  AppDelegate.m
//  CompilePureObjcProject
//
//  Created by Dio Brand on 2022/6/25.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.window makeKeyAndVisible];
    
    MainViewController *rootVC = [MainViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    self.window.rootViewController = nav;
    
    return YES;
}

@end
