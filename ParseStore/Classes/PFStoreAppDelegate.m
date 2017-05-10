//
//  PFAppDelegate.m
//  Stripe
//
//  Created by Andrew Wang on 2/25/13.
//  Copyright (c) 2013 Parse Inc. All rights reserved.
//

#import "PFProductsViewController.h"
#import "PFStoreAppDelegate.h"
#import "OrderHistoryTableViewController.h"
#import "ShoppingCartTableViewController.h"
#import <Parse/Parse.h>

@implementation PFStoreAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //[Parse setApplicationId:infoDictionary[@"PARSE_APPLICATION_ID"] clientKey:infoDictionary[@"PARSE_CLIENT_KEY"]];
    ParseClientConfiguration *configuration = [ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration>  _Nonnull configuration) {
        //[configuration setApplicationId:infoDictionary[@"PARSE_APPLICATION_ID"]];
        //[configuration setClientKey:infoDictionary[@"PARSE_CLIENT_KEY"]];
        [configuration setServer:@"http://localhost:1337/parse"];
        [configuration setApplicationId:@"APP_ID0"];
        [configuration setClientKey:@"MASTER_KEY0"];
        //[configuration setApplicationId:@"SsIJnAQghp1kAsj2ASwgAgWbVJfy6mRiuYRQmGgq"];
        //[configuration setClientKey:@"M8Yc0ARiasnwGWWn7vNn8iI8eNUpYzrWYkJNinr"];
        //[configuration setServer:@"http://store.mobilewareinc.com/parse"];
    }];
    [Parse initializeWithConfiguration:configuration];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    /*
     UINavigationController *rootController = [[UINavigationController alloc] initWithRootViewController:[[PFProductsViewController alloc] init]];
     rootController.navigationBar.hidden = YES;
     self.window.rootViewController = rootController;
     */
    UITabBarController *tabBarController = [UITabBarController new];
    UINavigationController *controller0 = [[UINavigationController alloc] initWithRootViewController:[PFProductsViewController new]];
    controller0.navigationBar.hidden = YES;
    PFProductsViewController *controller1 = [[PFProductsViewController alloc] init];
    PFProductsViewController *controller2 = [[PFProductsViewController alloc] init];
    UINavigationController *controller3 = [[UINavigationController alloc] initWithRootViewController:[ShoppingCartTableViewController new]];
    //controller3.navigationBar.hidden = YES;
    UINavigationController *controller4 = [[UINavigationController alloc] initWithRootViewController:[[OrderHistoryTableViewController alloc] init]];
    controller4.navigationBar.hidden = YES;
    tabBarController.viewControllers = @[controller0, controller1, controller2, controller3, controller4];
    
    controller0.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:0];
    controller1.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:1];
    controller2.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:2];
    controller3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Cart" image:nil tag:3];
    controller4.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:4];
    
    self.window.rootViewController = tabBarController;
    
    return YES;
}

#pragma mark - PFLogInViewControllerDelegate

- (BOOL)logInViewController:(PFLogInViewController *)logInController
shouldBeginLogInWithUsername:(NSString *)username
                   password:(NSString *)password {
    return YES;
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [logInController dismissViewControllerAnimated:YES completion:nil];
}

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(nullable NSError *)error {
    NSLog(@"Error: %@", error.localizedDescription);
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [controller addAction:defaultAction];
    [logInController presentViewController:controller animated:YES completion:nil];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    
}

#pragma mark - PFSignUpControllerDelegate

- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary<NSString *, NSString *> *)info {
    return YES;
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [signUpController dismissViewControllerAnimated:YES completion:^{
        UIViewController *topViewController = self.window.rootViewController;
        while (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        }
        if ([topViewController isKindOfClass:[PFLogInViewController class]]) {
            [topViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(nullable NSError *)error {
    NSLog(@"Error: %@", error.localizedDescription);
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [controller addAction:defaultAction];
    [signUpController presentViewController:controller animated:YES completion:nil];
}

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    
}

@end
