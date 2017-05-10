//
//  PFCheckoutViewController.h
//  Store
//
//  Created by Andrew Wang on 2/28/13.
//  Copyright (c) 2013 Parse Inc. All rights reserved.
//

#import "STPCheckoutView.h"
#import <Parse/Parse.h>

@interface PFCheckoutViewController : UIViewController <STPCheckoutDelegate>
- (id)initWithProduct:(PFObject *)product size:(NSString *)size shippingInfo:(NSDictionary *)otherShippingInfo;
- (instancetype)initWithItems:(NSArray<PFObject*> *)items shippingInfo:(NSDictionary *)shippingInfo;
@end
