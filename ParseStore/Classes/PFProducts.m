//
//  PFConstants.m
//  Store
//
//  Created by Andrew Wang on 2/26/13.
//  Copyright (c) 2013 Parse Inc. All rights reserved.
//

#import "PFProducts.h"

@implementation PFProducts

+ (NSArray *)sizes {
    return @[NSLocalizedString(@"Small", @"Small"),
             NSLocalizedString(@"Medium", @"Medium"),
             NSLocalizedString(@"Large", @"Large"),
             NSLocalizedString(@"Extra Large", @"Extra Large")];
}

@end
