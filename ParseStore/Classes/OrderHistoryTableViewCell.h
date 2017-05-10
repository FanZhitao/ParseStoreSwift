//
//  OrderHistoryTableViewCell.h
//  Store
//
//  Created by Zhitao Fan on 2/28/17.
//  Copyright © 2017 Parse Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface OrderHistoryTableViewCell : PFTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelItem;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelQuantity;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelSize;

- (void)configureOrder:(PFObject *)order;

@end
