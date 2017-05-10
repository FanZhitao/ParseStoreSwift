//
//  PFShippingViewController.h
//  Store
//
//  Created by Andrew Wang on 2/26/13.
//  Copyright (c) 2013 Parse Inc. All rights reserved.
//

@interface PFShippingViewController : UITableViewController <UITextFieldDelegate>
- (id)initWithProduct:(PFObject *)product size:(NSString *)size;
- (instancetype)initWithCartItems:(NSArray *)items;
@end
