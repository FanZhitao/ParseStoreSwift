//
//  ShoppingCartTableViewCell.h
//  Store
//
//  Created by Zhitao Fan on 3/7/17.
//  Copyright © 2017 Parse Inc. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface ShoppingCartTableViewCell : PFTableViewCell

- (void)configureObject:(PFObject *)object;

@property (weak, nonatomic) IBOutlet UILabel *labelItem;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelQuantity;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelSize;

@end
