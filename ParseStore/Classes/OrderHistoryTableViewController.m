//
//  OrderHistoryTableViewController.m
//  Store
//
//  Created by Zhitao Fan on 2/28/17.
//  Copyright © 2017 Parse Inc. All rights reserved.
//

#import "OrderHistoryTableViewController.h"
#import "OrderHistoryTableViewCell.h"

@interface OrderHistoryTableViewController ()

@end

@implementation OrderHistoryTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithClassName:@"Order"]) {
        //self.className = @"Item";
        //[self.tableView registerNib:[UINib nibWithNibName:@"OrderHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderHistoryTableViewCell"];
        [self.tableView registerClass:[OrderHistoryTableViewCell class] forCellReuseIdentifier:@"OrderHistoryTableViewCell"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadObjects];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkoutFinished) name:@"CheckoutFinished" object:nil];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"OrderHistoryTableViewCell";
    OrderHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (!cell) {
        cell = [[OrderHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.row < self.objects.count) {
        PFObject *order = self.objects[indexPath.row];
        [cell configureOrder:order];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 173.0f;
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
    }
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0 && ![Parse isLocalDatastoreEnabled]) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    [query includeKey:@"item"];
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}

#pragma mark - Notification Handlers

- (void)checkoutFinished {
    [self loadObjects];
}

@end
