//
//  ShoppingCartTableViewCell.m
//  Store
//
//  Created by Zhitao Fan on 3/7/17.
//  Copyright © 2017 Parse Inc. All rights reserved.
//

#import "ShoppingCartTableViewCell.h"

@implementation ShoppingCartTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *labelPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        labelPrice.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20.0f];
        labelPrice.textColor = [UIColor colorWithRed:14.0f/255.0f green:190.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
        labelPrice.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
        labelPrice.shadowOffset = CGSizeMake(0.0f, 0.5f);
        labelPrice.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:labelPrice];
        self.labelPrice = labelPrice;
        
        UILabel *labelDate = [[UILabel alloc] initWithFrame:CGRectZero];
        labelDate.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f];
        labelDate.textColor = [UIColor colorWithRed:102.0f/255.0f green:107.0f/255.0f blue:110.0f/255.0f alpha:1.0f];
        labelDate.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
        labelDate.shadowOffset = CGSizeMake(0.0f, 0.5f);
        labelDate.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:labelDate];
        self.labelDate = labelDate;
        
        UILabel *labelQuantity = [[UILabel alloc] initWithFrame:CGRectZero];
        labelQuantity.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f];
        labelQuantity.textColor = [UIColor colorWithRed:102.0f/255.0f green:107.0f/255.0f blue:110.0f/255.0f alpha:1.0f];
        labelQuantity.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
        labelQuantity.shadowOffset = CGSizeMake(0.0f, 0.5f);
        labelQuantity.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:labelQuantity];
        self.labelQuantity = labelQuantity;
        
        UILabel *labelSize = [[UILabel alloc] initWithFrame:CGRectZero];
        labelSize.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f];
        labelSize.textColor = [UIColor colorWithRed:102.0f/255.0f green:107.0f/255.0f blue:110.0f/255.0f alpha:1.0f];
        labelSize.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
        labelSize.shadowOffset = CGSizeMake(0.0f, 0.5f);
        labelSize.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:labelSize];
        self.labelSize = labelSize;
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
    self.labelPrice.text = @"";
    self.labelItem.text = @"";
    self.labelQuantity.text  = @"";
    self.labelSize.text = @"";
}

#pragma mark - UIView

- (void)layoutSubviews {
    static CGFloat ROW_MARGIN = 5.0f;
    CGFloat x = ROW_MARGIN;
    CGFloat y = ROW_MARGIN;
    self.backgroundView.frame = CGRectMake(x, y, self.frame.size.width - ROW_MARGIN*2.0f, 167.0f);
    x += 10.0f;
    
    self.imageView.frame = CGRectMake(x, y + 1.0f, 120.0f, 165.0f);
    x += 120.0f + 5.0f;
    y += 10.0f;
    
    [self.labelPrice sizeToFit];
    CGFloat priceX = self.frame.size.width - self.labelPrice.frame.size.width - ROW_MARGIN - 10.0f;
    self.labelPrice.frame = CGRectMake(priceX, ROW_MARGIN + 10.0f, self.labelPrice.frame.size.width, self.labelPrice.frame.size.height);
    
    y = 45.0f;
    
    [self.textLabel sizeToFit];
    self.textLabel.frame = CGRectMake(x + 2.0f, y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
    y += self.textLabel.frame.size.height + 2.0f;
    
    [self.labelQuantity sizeToFit];
    self.labelQuantity.frame = CGRectMake(self.textLabel.frame.origin.x, 92.0f, self.labelQuantity.frame.size.width, self.labelQuantity.frame.size.height);

    [self.labelSize sizeToFit];
    self.labelSize.frame = CGRectMake(self.textLabel.frame.origin.x + 50, 92.0f, self.labelSize.frame.size.width, self.labelSize.frame.size.height);

    [self.labelDate sizeToFit];
    self.labelDate.frame = CGRectMake(self.textLabel.frame.origin.x, 120.0f, self.labelDate.frame.size.width, self.labelDate.frame.size.height);
}

#pragma mark - Public

- (void)configureObject:(PFObject *)object {
    PFObject *product = object[@"product"];
    UIImage *backgroundImage = [UIImage imageNamed:@"Product.png"];
    UIEdgeInsets backgroundInsets = UIEdgeInsetsMake(backgroundImage.size.height/2.0f, backgroundImage.size.width/2.0f, backgroundImage.size.height/2.0f, backgroundImage.size.width/2.0f);
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[backgroundImage resizableImageWithCapInsets:backgroundInsets]];
    self.backgroundView = backgroundImageView;
    
    self.imageView.file = (PFFile *)product[@"image"];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.imageView loadInBackground];
    
    self.labelPrice.text = [NSString stringWithFormat:@"$%d", [product[@"price"] intValue]];
    
    self.textLabel.text = product[@"name"];
    self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:19.0f];
    self.textLabel.textColor = [UIColor colorWithRed:82.0f/255.0f green:87.0f/255.0f blue:90.0f/255.0f alpha:1.0f];
    self.textLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    self.textLabel.shadowOffset = CGSizeMake(0.0f, 0.5f);
    self.textLabel.backgroundColor = [UIColor clearColor];
    
    NSDate *date = product.updatedAt;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE, MMM d, h:mm a"];
    self.labelDate.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:date]];

    self.labelQuantity.text = [object[@"quantity"] stringValue];
    self.labelSize.text = [object[@"size"] isEqualToString:@"N/A"] ? @"" : object[@"size"];
}

@end
