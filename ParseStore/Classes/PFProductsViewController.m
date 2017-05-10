//
//  PFProductsViewController.m
//  Stripe
//
//  Created by Andrew Wang on 2/26/13.
//  Copyright (c) 2013 Parse Inc. All rights reserved.
//

#import "PFProductTableViewCell.h"
#import "PFProductsViewController.h"
#import "PFShippingViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "PFStoreAppDelegate.h"
#import "ShoppingCartTableViewController.h"
#import "PFProducts.h"

#define ROW_MARGIN 6.0f
#define ROW_HEIGHT 173.0f
#define PICKER_HEIGHT 216.0f
#define SIZE_BUTTON_TAG_OFFSET 1000

@interface PFProductsViewController ()
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIPickerView *pickerViewWithoutSize;
@property (nonatomic, weak) UIButton *buttonLogout;
@end

@implementation PFProductsViewController


#pragma mark - Life cycle

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithClassName:@"Item"]) {
        //self.className = @"Item";
        [self.tableView registerClass:[PFProductTableViewCell class] forCellReuseIdentifier:@"ParseProduct"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *poweredImage = [UIImage imageNamed:@"Powered.png"];
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake((self.tableView.frame.size.width - poweredImage.size.width)/2.0f, 0.0f, self.tableView.frame.size.width, poweredImage.size.height + ROW_MARGIN * 2.0f)];
    UIButton * poweredButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [poweredButton setImage:poweredImage forState:UIControlStateNormal];
    //[poweredButton addTarget:self action:@selector(openBrowser:) forControlEvents:UIControlEventTouchUpInside];
    [poweredButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    poweredButton.frame = CGRectMake(0.0f, -4.0f, poweredImage.size.width, poweredImage.size.height + 20.0f);
    [footer addSubview:poweredButton];
    self.tableView.tableFooterView = footer;

    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, PICKER_HEIGHT)];
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.hidden = YES;
    self.pickerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pickerView];
    
    self.pickerViewWithoutSize = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, PICKER_HEIGHT)];
    self.pickerViewWithoutSize.showsSelectionIndicator = YES;
    self.pickerViewWithoutSize.dataSource = self;
    self.pickerViewWithoutSize.delegate = self;
    self.pickerViewWithoutSize.hidden = YES;
    self.pickerViewWithoutSize.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pickerViewWithoutSize];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.tableView.contentOffset = CGPointMake(0.0f, 0.0f);
    self.tableView.scrollEnabled = YES;
    self.pickerView.hidden = YES;    
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
    self.pickerViewWithoutSize.hidden = YES;
    [self.pickerViewWithoutSize selectRow:0 inComponent:0 animated:NO];
    
    if (![PFUser currentUser]) {
        PFLogInViewController *controller = [[PFLogInViewController alloc] init];
        controller.delegate = (PFStoreAppDelegate *)([UIApplication sharedApplication].delegate);
        controller.signUpController.delegate = (PFStoreAppDelegate *)([UIApplication sharedApplication].delegate);
        [self presentViewController:controller animated:YES completion:nil];
    }
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ParseProduct";
    PFProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[PFProductTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    PFObject *product = self.objects[indexPath.row];
    [cell configureProduct:product];

    [cell.sizeButton addTarget:self action:@selector(selectSize:) forControlEvents:UIControlEventTouchUpInside];
    cell.sizeButton.tag = SIZE_BUTTON_TAG_OFFSET + indexPath.row;
    
    [cell.orderButton addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    cell.orderButton.tag = indexPath.row;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // When any cell is selected, we dismiss the picker view.
    // If you want the cell selection to do some useful work, you can dismiss the picker view in the callback of a gesture recognizer, or implement an accessory control to the picker view that dismisses it.
    [UIView animateWithDuration:0.1f animations:^{
        PFObject *item = self.objects[indexPath.row];
        if ([item[@"hasSize"] boolValue]) {
            self.pickerView.frame = CGRectMake(0.0f, self.pickerView.frame.origin.y + PICKER_HEIGHT, tableView.frame.size.width, PICKER_HEIGHT);
        } else {
            self.pickerViewWithoutSize.frame = CGRectMake(0.0f, self.pickerView.frame.origin.y + PICKER_HEIGHT, tableView.frame.size.width, PICKER_HEIGHT);
        }
    } completion:^(BOOL finished) {
        self.pickerView.hidden = YES;
        self.pickerViewWithoutSize.hidden = YES;
        // The table view's scrolling is disabled when the picker view is shown. Re-enable it here.
        self.tableView.scrollEnabled = YES;
        
        // Scroll the table to the bottom if the table view's current offset is beyond the maximum
        // allowable offset sot that it does not leave too much white space at the bottom.
        NSInteger numRows = [self tableView:tableView numberOfRowsInSection:0];
        CGFloat maxOffset = numRows * ROW_HEIGHT - self.view.frame.size.height + 36.0f;
        
        if (self.tableView.contentOffset.y > maxOffset) {
            [self.tableView setContentOffset:CGPointMake(0.0f, maxOffset) animated:YES];
        }
    }];
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == self.pickerView) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    // We show all product names and "Select Size".
    if (component == 0) {
        return 11;
    } else {
        return [PFProducts sizes].count + 1;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return @(row + 1).stringValue;
    } else {
        return row == 0 ? NSLocalizedString(@"Select Size", @"Select Size") : [PFProducts sizes][row - 1];
    }
}


#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row == 0 && component == 1) {
        NSString *buttonTitle = pickerView == self.pickerView ? NSLocalizedString(@"Select Qt. & Size", @"Select Quantity and Size") : NSLocalizedString(@"Select Quantity", @"Select Quantity");
        UIButton *sizeButton = (UIButton *)[self.tableView viewWithTag:pickerView.tag + SIZE_BUTTON_TAG_OFFSET];
        [sizeButton setTitle:buttonTitle forState:UIControlStateNormal];
    } else {
        if (component == 1) {
            UIButton *sizeButton = (UIButton *)[self.tableView viewWithTag:pickerView.tag + SIZE_BUTTON_TAG_OFFSET];
            NSString *title = [self pickerView:pickerView titleForRow:row forComponent:component];
            [sizeButton setTitle:title forState:UIControlStateNormal];
        } else {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:pickerView.tag inSection:0];
            PFProductTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.labelQuantity.text = [self pickerView:pickerView titleForRow:row forComponent:component];
        }
    }
}


#pragma mark - Event handlers

- (void)next:(UIButton *)button {
    UIButton *sizeButton = (UIButton *)[self.tableView viewWithTag:(button.tag + SIZE_BUTTON_TAG_OFFSET)];
    NSString *size = sizeButton ? [sizeButton titleForState:UIControlStateNormal] : nil;
    PFObject *product = self.objects[button.tag];
    
    if ([product[@"hasSize"] boolValue] && [size isEqualToString:NSLocalizedString(@"Select Qt. & Size", @"Select Quantity and Size")]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Size", @"Missing Size") message:NSLocalizedString(@"Please select a size.", @"Please select a size.") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
        [alertView show];
    } else {
        /*
        PFShippingViewController *shippingController = [[PFShippingViewController alloc] initWithProduct:self.objects[button.tag] size:size];
        [self.navigationController pushViewController:shippingController animated:YES];
         */
        
        // change to add to cart
        ShoppingCartTableViewController *controller = [self.tabBarController.viewControllers objectAtIndex:3].childViewControllers[0];
        NSMutableDictionary *cartItem = [NSMutableDictionary new];
        cartItem[@"product"] = product;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
        PFProductTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cartItem[@"quantity"] = @(cell.labelQuantity.text.integerValue);
        if ([product[@"hasSize"] boolValue]) {
            cartItem[@"size"] = size;
        }
        [controller addToCart:cartItem];
    }
}

- (void)selectSize:(id)sender {
    // This method shows the picker view for size selection.
    NSInteger row = ((UIButton *)sender).tag - SIZE_BUTTON_TAG_OFFSET;
    
    // Scroll to the row so that the picker view does not conceal any input.
    CGFloat offset = (row + 1) * ROW_HEIGHT - self.view.frame.size.height + PICKER_HEIGHT;
    if (offset < 0.0f) {
        offset = 0.0f;
    }
    
    [self.tableView setContentOffset:CGPointMake(0.0f, offset) animated:YES];
    
    // Disable scrolling in the table view so that user stays focused on the picker view.
    self.tableView.scrollEnabled = NO;
    
    // Assign the tag to the picker so that the picker knows which product's size it is selecting.
    PFObject *item = self.objects[row];
    UIPickerView *pickerView = [item[@"hasSize"] boolValue] ? self.pickerView : self.pickerViewWithoutSize;
    pickerView.tag = row;

    pickerView.hidden = NO;
    
    // Default for picker view's initial selection.
    [pickerView selectRow:0 inComponent:0 animated:NO];

    pickerView.frame = CGRectMake(0.0f, offset + self.view.frame.size.height, self.tableView.frame.size.width, PICKER_HEIGHT);
    [UIView animateWithDuration:0.1f animations:^{
        pickerView.frame = CGRectMake(0.0f, offset + self.view.frame.size.height - PICKER_HEIGHT, self.tableView.frame.size.width, PICKER_HEIGHT);
    }];
}

- (void)openBrowser:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.parse.com/store"]];
}

- (void)logout {
    [PFUser logOut];
    PFLogInViewController *controller = [[PFLogInViewController alloc] init];
    controller.delegate = (PFStoreAppDelegate *)([UIApplication sharedApplication].delegate);
    controller.signUpController.delegate = (PFStoreAppDelegate *)([UIApplication sharedApplication].delegate);
    [self presentViewController:controller animated:YES completion:nil];
}

@end
