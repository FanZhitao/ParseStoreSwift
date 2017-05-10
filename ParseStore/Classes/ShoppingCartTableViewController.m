//
//  ShoppingCartViewController.m
//  Store
//
//  Created by Zhitao Fan on 3/7/17.
//  Copyright © 2017 Parse Inc. All rights reserved.
//

#import "ShoppingCartTableViewController.h"
#import "ShoppingCartTableViewCell.h"
#import "PFShippingViewController.h"

@interface ShoppingCartTableViewController ()

@end

@implementation ShoppingCartTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithClassName:@"Cart"]) {
        [self.tableView registerClass:[ShoppingCartTableViewCell class] forCellReuseIdentifier:@"ShoppingCartItem"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadObjects];
    self.title = @"Shopping Cart";
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Checkout" style:UIBarButtonItemStyleDone target:self action:@selector(checkout)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkoutFinished) name:@"CheckoutFinished" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - Public Methods

- (void)addToCart:(NSDictionary *)cartItem {
//    __block bool existed = NO;
//    NSMutableArray *arr = (NSMutableArray *)self.objects;
//    [arr enumerateObjectsUsingBlock:^(PFObject *obj, NSUInteger idx, BOOL *stop) {
//        PFObject *theItem = obj[@"item"];
//        if ([theItem.objectId isEqualToString:item.objectId]) {
//            existed = YES;
//            theItem[@"quantity"] = @([theItem[@"quantity"] integerValue] + quantity);
//            *stop = YES;
//        }
//    }];
//    if (!existed) {
//        [arr addObject:item];
//    }
    [self postItem:cartItem];
    
    UITabBarItem *tabBarItem = [self.tabBarController.tabBar.items objectAtIndex:3];
    NSUInteger count = tabBarItem.badgeValue.integerValue;
    count += [cartItem[@"quantity"] integerValue];
    tabBarItem.badgeValue = @(count).stringValue;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ShoppingCartItem";
    ShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (!cell) {
        cell = [[ShoppingCartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.row < self.objects.count) {
        PFObject *object = self.objects[indexPath.row];
        [cell configureObject:object];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 173.0f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Override

- (PFQuery *)queryForTable {
    if (!self.parseClassName) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"You need to specify a parseClassName for the PFQueryTableViewController.", nil];
    }
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    if ([PFUser currentUser]) {
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query whereKey:@"valid" equalTo:@YES];
    }
    [query includeKey:@"product"];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0 && ![Parse isLocalDatastoreEnabled]) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // update object ids
    [self updateTabItemBadgeCount];
}

#pragma mark - Private Methods

- (NSInteger)indexOfObject:(PFObject *)object {
    for (NSInteger i = 0; i < self.objects.count; i++) {
        PFObject *theObject = self.objects[i];
        if ([theObject.objectId isEqualToString:object.objectId] && theObject[@"quantity"] == object[@"quantity"]) {
            return i;
        }
    }
    return -1;
}

- (void)postItem:(NSDictionary *)item {
    PFObject *product = item[@"product"];
    NSMutableDictionary *productInfo = [NSMutableDictionary new];
    productInfo[@"itemName"] = product[@"name"];
    productInfo[@"quantity"] = item[@"quantity"];
    productInfo[@"size"] = item[@"size"];
    
    [PFCloud callFunctionInBackground:@"addToCart"
                       withParameters:productInfo
                                block:^(id object, NSError *error) {
                                    if (error) {
                                        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                                    message:[[error userInfo] objectForKey:@"error"]
                                                                   delegate:nil
                                                          cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                          otherButtonTitles:nil] show];
                                        
                                    } else {
                                        [self loadObjects];
                                    }
                                }];
}

- (void)updateTabItemBadgeCount {
    UITabBarItem *tabBarItem = [self.tabBarController.tabBar.items objectAtIndex:3];
    NSUInteger count = 0;
    for (PFObject *object in self.objects) {
        count += [object[@"quantity"] integerValue];
    }
    tabBarItem.badgeValue = count == 0 ? nil : @(count).stringValue;
}

- (void)checkout {
    if (self.objects.count) {
        //PFObject *product = self.objects[0][@"item"];
        //PFShippingViewController *shippingController = [[PFShippingViewController alloc] initWithProduct:product size:product[@"size"]];
        PFShippingViewController *shippingController = [[PFShippingViewController alloc] initWithCartItems:self.objects];
        self.navigationController.navigationBar.hidden = YES;
        [self.navigationController pushViewController:shippingController animated:YES];
    }
}

#pragma mark - Notification Handlers

- (void)checkoutFinished {
    [self loadObjects];
}

@end
