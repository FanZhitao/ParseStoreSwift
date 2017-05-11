//
//  PFOrderHistoryTableViewController.swift
//  ParseStore
//
//  Created by Zhitao Fan on 5/10/17.
//  Copyright © 2017 Zhitao Fan. All rights reserved.
//

import UIKit
import ParseUI

class PFOrderHistoryTableViewController: PFQueryTableViewController {
    
    init(style: UITableViewStyle) {
        super.init(style: .plain, className: "Order")
        
        tableView.register(PFProductTableViewCell.self, forCellReuseIdentifier: "OrderHistoryTableViewCell")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadObjects()
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkoutFinished), name: NSNotification.Name(rawValue: "CheckoutFinished"), object: nil)
    }

    // MARK: - Table view data source

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "OrderHistoryTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? OrderHistoryTableViewCell
        if cell == nil {
            cell = OrderHistoryTableViewCell(style: .default, reuseIdentifier: identifier)
        }

        if indexPath.row < (objects?.count)! {
            let order = objects?[indexPath.row]
            cell?.configureOrder(order)
        }

        return cell!
        
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 173.0
    }
    
    // MARK: - overrided funcs
    
    override func queryForTable() -> PFQuery<PFObject> {
        let query = PFQuery(className: parseClassName!)
        if PFUser.current() != nil {
            query.whereKey("user", equalTo: PFUser.current()!)
        }
        query.includeKey("item")
        
        if objects?.count == 0 && !Parse.isLocalDatastoreEnabled() {
            query.cachePolicy = .cacheThenNetwork
        }
        query.order(byDescending: "createdAt")
        return query
        
    }

    // MARK: - notification handlers
    
    func checkoutFinished() {
        
    }
}
