//
//  PFShoppingCartTableViewController.swift
//  ParseStore
//
//  Created by Zhitao Fan on 5/10/17.
//  Copyright © 2017 Zhitao Fan. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PFShoppingCartTableViewController: PFQueryTableViewController {
    
    init(style: UITableViewStyle) {
        super.init(style:UITableViewStyle.plain, className: "Cart")
        
        tableView.register(ShoppingCartTableViewCell.self, forCellReuseIdentifier: "ShoppingCartTableViewCell")
        tableView.separatorStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadObjects()
        title = "Shopping Cart"
        let barButtonItem = UIBarButtonItem(title: "Checkout", style: .done, target: self, action: #selector(self.checkout))
        navigationItem.rightBarButtonItem = barButtonItem
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkoutFinished), name: NSNotification.Name(rawValue: "CheckoutFinished"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        
        let topController = navigationController?.topViewController
        if topController is PFFinishViewController {
            navigationController?.popViewController(animated: false)
        }
    }
    
    // MARK: - overrided funcs
    
    override func queryForTable() -> PFQuery<PFObject> {
        let query = PFQuery(className: parseClassName!)
        if PFUser.current() != nil {
            query.whereKey("user", equalTo: PFUser.current()!)
            query.whereKey("valid", equalTo: true)
        }
        query.includeKey("product")

        if objects?.count == 0 && !Parse.isLocalDatastoreEnabled() {
            query.cachePolicy = .cacheThenNetwork
        }
        query.order(byDescending: "createdAt")
        return query

    }
    
    override func objectsDidLoad(_ error: Error?) {
        super.objectsDidLoad(error)
        
        updateTabItemBadgeCount()
    }
    
    // MARK: - public funcs
    
    func add(toCart cartItem: [AnyHashable: Any]) {
        postItem(cartItem)
        var index = 0
        while tabBarController?.childViewControllers[index] != navigationController {
            index += 1
        }
        let tabBarItem = tabBarController?.tabBar.items?[index]
        var count = Int(tabBarItem?.badgeValue ?? "0")!
        count += cartItem["quantity"]! as! Int
        tabBarItem?.badgeValue = String(count)
    }
    
    // MARK: - private funcs
    
    func indexOf(_ object: PFObject) -> Int {
        for i in 0..<(objects?.count)! {
            let theObject = (objects?[i])!
            let q1 = theObject.value(forKey: "quantity") as! Int
            let q2 = object.value(forKey: "quantity") as! Int
            if (theObject.objectId == object.objectId) && (q1 == q2) {
                return i
            }
        }
        return -1
    }
    
    func postItem(_ item: [AnyHashable: Any]) {
        let product: PFObject? = item["product"] as? PFObject
        var productInfo = [AnyHashable: Any]()
        productInfo["itemName"] = product?["name"]
        productInfo["quantity"] = item["quantity"]
        productInfo["size"] = item["size"]
        PFCloud.callFunction(inBackground: "addToCart", withParameters: productInfo, block: {(_ object: Any, _ error: Error?) -> Void in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error!.localizedDescription , preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.loadObjects()
            }
        })
    }
    
    func updateTabItemBadgeCount() {
        var index = 0
        while tabBarController?.viewControllers?[index].childViewControllers[0] != self {
            index += 1
        }
        let tabBarItem = tabBarController?.tabBar.items?[index]
        var count = 0
        for object: PFObject in objects! {
            count += object["quantity"]! as! Int
        }
        tabBarItem?.badgeValue = count == 0 ? nil : String(count)
    }

    // MARK: - Table view data source

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "ShoppingCartTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? ShoppingCartTableViewCell
        if cell == nil {
            cell = ShoppingCartTableViewCell(style: .default, reuseIdentifier: identifier)
        }
        
        if indexPath.row < (objects?.count)! {
            let object = objects?[indexPath.row]
            cell?.configureObject(object)
        }
        
        return cell!
        
    }

    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 173.0
    }
    
    // MARK: - actions
    
    func checkout() {
        if (objects?.count)! > 0 {
            let shippingController = PFShippingTableViewController(items: objects)
            navigationController?.navigationBar.isHidden = true
            navigationController?.pushViewController(shippingController, animated: true)
        }
    }
    
    func checkoutFinished() {
        loadObjects()
    }
}
