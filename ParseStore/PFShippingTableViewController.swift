//
//  PFShippingTableViewController.swift
//  ParseStore
//
//  Created by Zhitao Fan on 5/10/17.
//  Copyright © 2017 Zhitao Fan. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PFShippingTableViewController: UITableViewController, UITextFieldDelegate {
    
    enum PFShippingSection: Int {
        case Name = 0, Email, Address
    }
    
    enum PFAddressRow: Int {
        case Address = 0, CityState, ZipCode
    }
    
    let TEXT_FIELD_TAG_OFFSET = 1000
    let NUM_TEXT_FIELD = 5
    
    var textFieldName : UITextField?
    var textFieldEmail : UITextField?
    var textFieldAddress : UITextField?
    var textFieldCityState : UITextField?
    var textFieldPostalCode : UITextField?
    var cartItems : [PFObject]?
    
    // MARK: - life cycle
    
    init(items: [PFObject]?) {
        cartItems = items
        
        textFieldName = UITextField()
        textFieldEmail = UITextField()
        textFieldAddress = UITextField()
        textFieldCityState = UITextField()
        textFieldPostalCode = UITextField()
        
        cartItems = [PFObject]()
        
        super.init(style: .plain)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Shipping")
        tableView.backgroundView = nil
        tableView.backgroundColor = UIColor(red: CGFloat(249.0 / 255.0), green: CGFloat(252.0 / 255.0), blue: CGFloat(253.0 / 255.0), alpha: CGFloat(1.0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addHeaderView()
        addFooterView()
        addTextFields()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.cancelsTouchesInView = false
        
        title = "Shipping"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }

    // MARK: - private funcs
    
    func addHeaderView() {
        let backgroundStripe = UIImage(named: "ShippingHeader.png")!
        let headerView = UIView(frame: CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(tableView.frame.size.width), height: CGFloat(backgroundStripe.size.height)))
        headerView.backgroundColor = UIColor(patternImage: backgroundStripe)
        tableView.tableHeaderView = headerView
        let x: CGFloat = 30.0
        var y: CGFloat = 0.0
        
        let priceLabel = UILabel(frame: CGRect.zero)
        var price = 0
        for item in cartItems! {
            let product = item.value(forKey: "product") as! PFObject
            price += product.value(forKey: "price")! as! Int
        }
        priceLabel.text = "$\(price)"
        priceLabel.font = UIFont(name: "HelveticaNeue-Medium", size: CGFloat(20.0))
        priceLabel.textColor = UIColor(red: CGFloat(14.0 / 255.0), green: CGFloat(190.0 / 255.0), blue: CGFloat(255.0 / 255.0), alpha: CGFloat(1.0))
        priceLabel.shadowColor = UIColor(white: CGFloat(1.0), alpha: CGFloat(0.7))
        priceLabel.shadowOffset = CGSize(width: CGFloat(0), height: CGFloat(0.5))
        priceLabel.backgroundColor = UIColor.clear
        priceLabel.sizeToFit()
        let priceX: CGFloat = view.frame.size.width - priceLabel.frame.size.width - 10.0
        priceLabel.frame = CGRect(x: priceX, y: CGFloat(10.0), width: CGFloat(priceLabel.frame.size.width), height: CGFloat(priceLabel.frame.size.height))
        view.addSubview(priceLabel)
        
        let nameLabel = UILabel(frame: CGRect.zero)
        //let product = cartItems?[0].value(forKey: "product") as! PFObject
        //nameLabel.text = product.value(forKey: "description") as? String
        nameLabel.text = "shopping cart"
        nameLabel.font = UIFont(name: "HelveticaNeue-Medium", size: CGFloat(18.0))
        nameLabel.textColor = UIColor(red: CGFloat(82.0 / 255.0), green: CGFloat(87.0 / 255.0), blue: CGFloat(90.0 / 255.0), alpha: CGFloat(1.0))
        nameLabel.shadowColor = UIColor(white: CGFloat(1.0), alpha: CGFloat(0.7))
        nameLabel.shadowOffset = CGSize(width: CGFloat(0), height: CGFloat(0.5))
        nameLabel.backgroundColor = UIColor.clear
        nameLabel.sizeToFit()
        y = 30.0
        nameLabel.frame = CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(nameLabel.frame.size.width), height: CGFloat(nameLabel.frame.size.height))
        view.addSubview(nameLabel)
        y += nameLabel.frame.size.height
        
        let sizeLabel = UILabel(frame: CGRect.zero)
        sizeLabel.text = "Multiple values"
        sizeLabel.font = UIFont(name: "HelveticaNeue-Medium", size: CGFloat(14.0))
        sizeLabel.textColor = UIColor(red: CGFloat(138.0 / 255.0), green: CGFloat(144.0 / 255.0), blue: CGFloat(148.0 / 255.0), alpha: CGFloat(1.0))
        sizeLabel.shadowColor = UIColor(white: CGFloat(1.0), alpha: CGFloat(0.7))
        sizeLabel.shadowOffset = CGSize(width: CGFloat(0), height: CGFloat(0.5))
        sizeLabel.backgroundColor = UIColor.clear
        sizeLabel.sizeToFit()
        sizeLabel.frame = CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(sizeLabel.frame.size.width), height: CGFloat(sizeLabel.frame.size.height))
        view.addSubview(sizeLabel)
        y += sizeLabel.frame.size.height + 2.0
        
        let shippingLabel = UILabel(frame: CGRect.zero)
        shippingLabel.text = NSLocalizedString("Shipping Information", comment: "Shipping Information")
        shippingLabel.backgroundColor = UIColor.clear
        shippingLabel.font = UIFont(name: "HelveticaNeue-Medium", size: CGFloat(17.0))
        shippingLabel.textColor = UIColor(red: CGFloat(132.0 / 255.0), green: CGFloat(140.0 / 255.0), blue: CGFloat(147.0 / 255.0), alpha: CGFloat(1.0))
        shippingLabel.shadowColor = UIColor(white: CGFloat(1.0), alpha: CGFloat(0.7))
        shippingLabel.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(1.0))
        shippingLabel.sizeToFit()
        shippingLabel.frame = CGRect(x: CGFloat((tableView.frame.size.width - shippingLabel.frame.size.width) / 2.0), y: CGFloat(headerView.frame.size.height - shippingLabel.frame.size.height - 13.0), width: CGFloat(shippingLabel.frame.size.width), height: CGFloat(shippingLabel.frame.size.height))
        headerView.addSubview(shippingLabel)
    }
    
    func addFooterView() {
        let footer = UIView(frame: CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(tableView.frame.size.width), height: CGFloat(130.0)))
        let usOnlyLabel = UILabel(frame: CGRect.zero)
        usOnlyLabel.text = NSLocalizedString("US mailing address only", comment: "US mailing address only")
        usOnlyLabel.backgroundColor = UIColor.clear
        usOnlyLabel.font = UIFont(name: "HelveticaNeue-Medium", size: CGFloat(12.0))
        usOnlyLabel.textColor = UIColor(red: CGFloat(132.0 / 255.0), green: CGFloat(140.0 / 255.0), blue: CGFloat(147.0 / 255.0), alpha: CGFloat(1.0))
        usOnlyLabel.shadowColor = UIColor(white: CGFloat(1.0), alpha: CGFloat(0.7))
        usOnlyLabel.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(1.0))
        usOnlyLabel.sizeToFit()
        usOnlyLabel.frame = CGRect(x: CGFloat((tableView.frame.size.width - usOnlyLabel.frame.size.width) / 2.0), y: CGFloat(2.0), width: CGFloat(usOnlyLabel.frame.size.width), height: CGFloat(usOnlyLabel.frame.size.height))
        footer.addSubview(usOnlyLabel)

        let checkoutButton = UIButton(type: .custom)
        checkoutButton.setTitle(NSLocalizedString("Checkout", comment: "Checkout"), for: .normal)
        checkoutButton.titleLabel?.shadowColor = UIColor(white: CGFloat(0.0), alpha: CGFloat(0.7))
        checkoutButton.titleLabel?.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(-0.5))
        let checkoutImage = UIImage(named: "ButtonCheckout.png")!
        let checkoutPressedImage = UIImage(named: "ButtonCheckoutPressed.png")!
        let checkoutIcon = UIImage(named: "IconCheckout.png")!
        let insets: UIEdgeInsets = UIEdgeInsetsMake(checkoutImage.size.height / 2, checkoutImage.size.width / 2, checkoutImage.size.height / 2, checkoutImage.size.width / 2)
        checkoutButton.setBackgroundImage(checkoutImage.resizableImage(withCapInsets: insets), for: .normal)
        checkoutButton.setBackgroundImage(checkoutPressedImage.resizableImage(withCapInsets: insets), for: .highlighted)
        checkoutButton.setImage(checkoutIcon, for: .normal)
        checkoutButton.setImage(checkoutIcon, for: .highlighted)
        checkoutButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, -50.0, 0.0, 0.0)
        checkoutButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, -checkoutIcon.size.width, 0.0, 0.0)
        checkoutButton.addTarget(self, action: #selector(self.checkout), for: .touchUpInside)
        let y : CGFloat = UIScreen.main.bounds.size.height > 480.0 ? 30.0 : 18.0
        checkoutButton.frame = CGRect(x: CGFloat((tableView.frame.size.width - 195.0) / 2.0), y: y, width: CGFloat(195.0), height: CGFloat(checkoutImage.size.height))
        footer.addSubview(checkoutButton)

        let poweredImage = UIImage(named: "Powered.png")!
        let poweredButton = UIButton(type: .custom)
        poweredButton.setImage(poweredImage, for: .normal)
        //poweredButton.addTarget(self, action: #selector(self.openBrowser), for: .touchUpInside)
        poweredButton.frame = CGRect(x: CGFloat((tableView.frame.size.width - poweredImage.size.width) / 2.0), y: CGFloat(footer.frame.size.height - 20.0 - poweredImage.size.height), width: CGFloat(poweredImage.size.width), height: CGFloat(poweredImage.size.height + 20.0))
        footer.addSubview(poweredButton)
        tableView.tableFooterView = footer
    }

    func addTextFields() {
        textFieldName = UITextField(frame: CGRect(x: CGFloat(8.0), y: CGFloat(10.0), width: CGFloat(tableView.frame.size.width - 20.0), height: CGFloat(44.0)))
        textFieldName?.delegate = self
        textFieldName?.placeholder = "Name"
        textFieldName?.returnKeyType = .next
        textFieldName?.autocapitalizationType = .words
        textFieldName?.tag = TEXT_FIELD_TAG_OFFSET
        
        textFieldEmail = UITextField(frame: CGRect(x: CGFloat(8.0), y: CGFloat(10.0), width: CGFloat(tableView.frame.size.width - 20.0), height: CGFloat(44.0)))
        textFieldEmail?.delegate = self
        textFieldEmail?.placeholder = "Email"
        textFieldEmail?.returnKeyType = .next
        textFieldEmail?.keyboardType = .emailAddress
        textFieldEmail?.autocapitalizationType = .none
        textFieldEmail?.tag = TEXT_FIELD_TAG_OFFSET + 1
        textFieldEmail?.autocorrectionType = .no
        
        textFieldAddress = UITextField(frame: CGRect(x: CGFloat(8.0), y: CGFloat(10.0), width: CGFloat(tableView.frame.size.width - 20.0), height: CGFloat(44.0)))
        textFieldAddress?.delegate = self
        textFieldAddress?.placeholder = "Address"
        textFieldAddress?.returnKeyType = .next
        textFieldAddress?.autocapitalizationType = .sentences
        textFieldAddress?.tag = TEXT_FIELD_TAG_OFFSET + 2
        
        textFieldCityState = UITextField(frame: CGRect(x: CGFloat(8.0), y: CGFloat(10.0), width: CGFloat(tableView.frame.size.width - 20.0), height: CGFloat(44.0)))
        textFieldCityState?.delegate = self
        textFieldCityState?.placeholder = NSLocalizedString("City, State", comment: "City, State")
        textFieldCityState?.returnKeyType = .done
        textFieldCityState?.autocapitalizationType = .words
        textFieldCityState?.tag = TEXT_FIELD_TAG_OFFSET + 3
        textFieldCityState?.autocapitalizationType = .none
        
        textFieldPostalCode = UITextField(frame: CGRect(x: CGFloat(8.0), y: CGFloat(10.0), width: CGFloat(tableView.frame.size.width - 20.0), height: CGFloat(44.0)))
        textFieldPostalCode?.delegate = self
        textFieldPostalCode?.placeholder = "Postal Code"
        textFieldPostalCode?.returnKeyType = .next
        textFieldPostalCode?.keyboardType = .numberPad
        textFieldPostalCode?.tag = TEXT_FIELD_TAG_OFFSET + 4
        
        // MARK: Test data
        textFieldName?.text = "Zhitao"
        textFieldEmail?.text = "fan.zhitao.cn@gmail.com"
        textFieldAddress?.text = "87 Oneida Ave"
        textFieldCityState?.text = "Centereach, NY"
        textFieldPostalCode?.text = "11720"
    }
    
    func scrollView(toScreenTop textField: UITextField) {
        let cell = textField.superview?.superview as! UITableViewCell
        tableView.scrollToRow(at: tableView.indexPath(for: cell)!, at: .top, animated: true)
    }
    
    func dismissKeyboard() {
        for i in TEXT_FIELD_TAG_OFFSET..<TEXT_FIELD_TAG_OFFSET + NUM_TEXT_FIELD {
            view.viewWithTag(i)?.resignFirstResponder()
        }
    }
    
    func isEmailValid(_ email: String) -> Bool {
        let regex = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")
        return regex.evaluate(with: email)
    }
    
    func isValid() -> Bool {
        for i in 0..<NUM_TEXT_FIELD {
            let field = view.viewWithTag(TEXT_FIELD_TAG_OFFSET + i) as? UITextField
            if field?.text == nil {
                let alert = UIAlertController(title: "Missing Field", message: "Please fill in all fields.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return false
            }
        }
        if !isEmailValid((textFieldEmail?.text)!) {
            let alert = UIAlertController(title: "Invalid Email", message: "Please enter a valid email.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            textFieldEmail?.becomeFirstResponder()
            return false
        }
        return true
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1:
            return 1
        default:
            return 3
        }
    }
    
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIScreen.main.bounds.size.height > 480.0 ? 9.0 : 3.0
    }
    
    public override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "Shipping"
        var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        cell!.selectionStyle = .none
        if indexPath.section == PFShippingSection.Name.rawValue {
            cell!.contentView.addSubview(textFieldName!)
        }
        else if indexPath.section == PFShippingSection.Email.rawValue {
            cell!.contentView.addSubview(textFieldEmail!)
        }
        else if indexPath.section == PFShippingSection.Address.rawValue {
            if indexPath.row == PFAddressRow.Address.rawValue {
                cell!.contentView.addSubview(textFieldAddress!)
            }
            else if indexPath.row == PFAddressRow.CityState.rawValue {
                cell!.contentView.addSubview(textFieldCityState!)
            }
            else if indexPath.row == PFAddressRow.ZipCode.rawValue {
                cell!.contentView.addSubview(textFieldPostalCode!)
            }
        }
        
        return cell!
    }

    // MARK: - actions
    
    func checkout() {
        if isValid() {
            let shippingInfo: [AnyHashable: Any] = ["name": textFieldName?.text ?? "", "email": textFieldEmail?.text ?? "", "address": textFieldAddress?.text ?? "", "zip": textFieldPostalCode?.text ?? "", "cityState": textFieldCityState?.text ?? ""]
            let checkoutController = PFCheckoutViewController(items: cartItems!, shippingInfo: shippingInfo as! [String : AnyObject])
            navigationController?.pushViewController(checkoutController, animated: true)
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView(toScreenTop: textField)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == TEXT_FIELD_TAG_OFFSET + NUM_TEXT_FIELD - 1 {
            dismissKeyboard()
            checkout()
        } else {
            tableView.viewWithTag(textField.tag + 1)?.becomeFirstResponder()
        }
        return true
    }

}
