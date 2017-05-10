//
//  PFAppDelegate.h
//  Stripe
//
//  Created by Andrew Wang on 2/25/13.
//  Copyright (c) 2013 Parse Inc. All rights reserved.
//

#import <ParseUI/ParseUI.h>

@interface PFStoreAppDelegate : UIResponder <UIApplicationDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
@property (nonatomic, strong) UIWindow *window;
@end
