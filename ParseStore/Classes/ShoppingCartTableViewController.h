//
//  ShoppingCartViewController.h
//  Store
//
//  Created by Zhitao Fan on 3/7/17.
//  Copyright © 2017 Parse Inc. All rights reserved.
//

#import <ParseUI/ParseUI.h>

@interface ShoppingCartTableViewController : PFQueryTableViewController

- (void)addToCart:(NSDictionary *)item;

@end
