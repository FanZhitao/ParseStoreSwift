//
//  PFProductsTableViewController.swift
//  ParseStore
//
//  Created by Zhitao Fan on 5/9/17.
//  Copyright © 2017 Zhitao Fan. All rights reserved.
//

import UIKit
import ParseUI

class PFProductsTableViewController: PFQueryTableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let ROW_MARGIN : CGFloat = 6.0
    let ROW_HEIGHT : CGFloat = 173.0
    let PICKER_HEIGHT : CGFloat = 216.0
    let SIZE_BUTTON_TAG_OFFSET = 1000
    
    var pickerView : UIPickerView
    var pickerViewWithoutSize : UIPickerView
    
    // MARK: - Life cycle
    
    init(style: UITableViewStyle) {
        pickerView = UIPickerView()
        pickerViewWithoutSize = UIPickerView()
        
        super.init(style:UITableViewStyle.plain, className: "Item")
        
        tableView.register(PFProductTableViewCell.self, forCellReuseIdentifier: "ParseProduct")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Store"
        let poweredImage = UIImage(named: "Powered.png")!
        let footer = UIView(frame: CGRect(x: CGFloat((tableView.frame.size.width - poweredImage.size.width) / 2.0), y: CGFloat(0.0), width: CGFloat(tableView.frame.size.width), height: CGFloat(poweredImage.size.height + ROW_MARGIN * 2.0)))
        let poweredButton = UIButton(type: .custom)
        poweredButton.setImage(poweredImage, for: .normal)
        poweredButton.frame = CGRect(x: CGFloat(0.0), y: CGFloat(-4.0), width: CGFloat(poweredImage.size.width), height: CGFloat(poweredImage.size.height + 20.0))
        footer.addSubview(poweredButton)
        tableView.tableFooterView = footer
        
        pickerView.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(tableView.frame.size.width), height: CGFloat(PICKER_HEIGHT))
        pickerView.showsSelectionIndicator = true
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.isHidden = true
        pickerView.backgroundColor = UIColor.white
        view.addSubview(pickerView)
        
        pickerViewWithoutSize.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(tableView.frame.size.width), height: CGFloat(PICKER_HEIGHT))
        pickerViewWithoutSize.showsSelectionIndicator = true
        pickerViewWithoutSize.dataSource = self
        pickerViewWithoutSize.delegate = self
        pickerViewWithoutSize.isHidden = true
        pickerViewWithoutSize.backgroundColor = UIColor.white
        view.addSubview(pickerViewWithoutSize)
        
        let barButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(self.logout))
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        tableView.contentOffset = CGPoint(x: CGFloat(0.0), y: CGFloat(0.0))
        tableView.isScrollEnabled = true
        pickerView.isHidden = true
        pickerView.selectRow(0, inComponent: 0, animated: false)
        pickerViewWithoutSize.isHidden = true
        pickerViewWithoutSize.selectRow(0, inComponent: 0, animated: false)
        if !(PFUser.current() != nil) {
            let controller = PFLogInViewController()
            controller.delegate = ((UIApplication.shared.delegate) as? AppDelegate)
            controller.signUpController?.delegate = ((UIApplication.shared.delegate) as? AppDelegate)
            present(controller, animated: true, completion: { _ in })
        }
    }
    
    // MARK: - Table view data source

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let identifier = "ParseProduct"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? PFProductTableViewCell
        if cell == nil {
            cell = PFProductTableViewCell(style: .default, reuseIdentifier: identifier)
        }
        let product: PFObject? = objects?[indexPath.row]
        cell?.configureProduct(product)
        cell?.sizeButton?.addTarget(self, action: #selector(self.selectSize), for: .touchUpInside)
        cell?.sizeButton?.tag = SIZE_BUTTON_TAG_OFFSET + indexPath.row
        cell?.orderButton?.addTarget(self, action: #selector(self.makeOrder), for: .touchUpInside)
        cell?.orderButton?.tag = indexPath.row
        return cell!

    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ROW_HEIGHT
    }
    
    // MARK: - UITableViewDelegate
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.1, animations: {() -> Void in
            let item = self.objects?[indexPath.row]
            if ((item?.object(forKey: "hasSize")) != nil) {
                self.pickerView.frame = CGRect(x: CGFloat(0.0), y: CGFloat(self.pickerView.frame.origin.y + self.PICKER_HEIGHT), width: CGFloat(tableView.frame.size.width), height: CGFloat(self.PICKER_HEIGHT))
            }
            else {
                self.pickerViewWithoutSize.frame = CGRect(x: CGFloat(0.0), y: CGFloat(self.pickerView.frame.origin.y + self.PICKER_HEIGHT), width: CGFloat(tableView.frame.size.width), height: CGFloat(self.PICKER_HEIGHT))
            }
        }, completion: {(_ finished: Bool) -> Void in
            self.pickerView.isHidden = true
            self.pickerViewWithoutSize.isHidden = true
            tableView.isScrollEnabled = true
            let numRows = self.tableView(tableView, numberOfRowsInSection: 0)
            let maxOffset: CGFloat = CGFloat(numRows) * self.ROW_HEIGHT - self.view.frame.size.height + 36.0
            if tableView.contentOffset.y > maxOffset {
                tableView.setContentOffset(CGPoint(x: CGFloat(0.0), y: maxOffset), animated: true)
            }
        })
    }
    
    // MARK: - UIPickerViewDataSource
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == self.pickerView {
            return 2
        } else {
            return 1
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 11
        } else {
            return PFProducts.sizes().count + 1
        }
    }
    
    // MARK: - UIPickerViewDelegate
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String(row + 1)
        } else {
            return row == 0 ? "Select Size" : PFProducts.sizes()[row - 1] 
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 && component == 1 {
            let buttonTitle = pickerView == pickerView ? "Select Quantity and Size" : "Select Quantity"
            let sizeButton: UIButton? = (tableView.viewWithTag(pickerView.tag + SIZE_BUTTON_TAG_OFFSET) as? UIButton)
            sizeButton?.setTitle(buttonTitle, for: .normal)
        } else {
            if component == 1 {
                let sizeButton: UIButton? = (tableView.viewWithTag(pickerView.tag + SIZE_BUTTON_TAG_OFFSET) as? UIButton)
                let title: String = self.pickerView(pickerView, titleForRow: row, forComponent: component)!
                sizeButton?.setTitle(title, for: .normal)
            }
            else {
                let indexPath = IndexPath(row: pickerView.tag, section: 0)
                let cell = tableView.cellForRow(at: indexPath) as! PFProductTableViewCell
                cell.labelQuantity?.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
            }
        }
    }
    
    // MARK: - actions
    
    func makeOrder(sender: UIButton) {
        let sizeButton = (tableView.viewWithTag((sender.tag + SIZE_BUTTON_TAG_OFFSET)) as? UIButton)
        let size = sizeButton?.title(for: .normal)
        let product = objects?[sender.tag]
        if (product?.value(forKey: "hasSize") != nil) && (size == "Select Qt. & Size") {
            let alert = UIAlertController(title: "Missing Size", message: "Please select a size.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            var index = 0
            while index < (tabBarController?.viewControllers?.count)! && tabBarController?.viewControllers?[index].childViewControllers[0] is PFShoppingCartTableViewController == false {
                index += 1
            }
            if index < (tabBarController?.viewControllers?.count)! {
                let controller = tabBarController?.viewControllers?[index].childViewControllers[0] as! PFShoppingCartTableViewController
                var cartItem = [AnyHashable: Any]()
                cartItem["product"] = product
                let indexPath = IndexPath(row: sender.tag, section: 0)
                let cell = tableView.cellForRow(at: indexPath) as! PFProductTableViewCell
                cartItem["quantity"] = (Int((cell.labelQuantity?.text)!))
                let hasSize = product?.value(forKey: "hasSize") as? Bool
                if hasSize == true {
                    cartItem["size"] = size
                }
                controller.add(toCart: cartItem)
            }
        }
    }
    
    func selectSize(sender: Any) {
        let row: Int? = ((sender as? UIButton)?.tag)! - SIZE_BUTTON_TAG_OFFSET
        var offset: CGFloat = CGFloat(row! + 1) * ROW_HEIGHT - view.frame.size.height + PICKER_HEIGHT
        if offset < 0.0 {
            offset = 0.0
        }
        tableView.setContentOffset(CGPoint(x: CGFloat(0.0), y: offset), animated: true)
        tableView.isScrollEnabled = false
        
        let item: PFObject? = objects?[row!]
        let hasSize = item?.value(forKey: "hasSize") as? Bool
        let pickerView: UIPickerView? = hasSize! ? self.pickerView : pickerViewWithoutSize
        pickerView?.tag = row!
        pickerView?.isHidden = false
        pickerView?.selectRow(0, inComponent: 0, animated: false)
        pickerView?.frame = CGRect(x: CGFloat(0.0), y: CGFloat(offset + view.frame.size.height), width: CGFloat(tableView.frame.size.width), height: CGFloat(PICKER_HEIGHT))
        UIView.animate(withDuration: 0.1, animations: {() -> Void in
            pickerView?.frame = CGRect(x: CGFloat(0.0), y: CGFloat(offset + self.view.frame.size.height - self.PICKER_HEIGHT), width: CGFloat(self.tableView.frame.size.width), height: CGFloat(self.PICKER_HEIGHT))
        })
    }

    func logout() {
        PFUser.logOut()
        let controller = PFLogInViewController()
        controller.delegate = ((UIApplication.shared.delegate) as? AppDelegate)
        controller.signUpController?.delegate = ((UIApplication.shared.delegate) as? AppDelegate)
        present(controller, animated: true, completion: nil)
    }
}
