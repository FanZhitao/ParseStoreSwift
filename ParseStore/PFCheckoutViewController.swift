//
//  PFCheckoutViewController.swift
//  ParseStore
//
//  Created by Zhitao Fan on 5/11/17.
//  Copyright © 2017 Zhitao Fan. All rights reserved.
//

import UIKit
import ParseUI

class PFCheckoutViewController: UIViewController, STPCheckoutDelegate  {
    
    let shippingInfo : [String: AnyObject]
    let checkoutView : STPCheckoutView
    let hud : MBProgressHUD
    let items : [PFObject]
    
    public init(items: [PFObject], shippingInfo: [String: AnyObject]) {
        self.items = items
        self.shippingInfo = shippingInfo
        checkoutView = STPCheckoutView(frame: CGRect(x: CGFloat(15.0), y: CGFloat(165.0), width: CGFloat(290.0), height: CGFloat(55.0)), andKey: Bundle.main.infoDictionary!["STRIPE_PUBLISHABLE_KEY"] as! String)
        hud = MBProgressHUD()
        
        super.init(nibName: nil, bundle: nil)
        
        checkoutView.delegate = self
        hud.frame = view.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Checkout"
        let barButtonItem = UIBarButtonItem(title: "Buy", style: .done, target: self, action: #selector(self.buy))
        navigationItem.rightBarButtonItem = barButtonItem
        
        let creditCardImage = UIImage(named: "CreditCardBg.png")!
        let creditCardView = UIImageView(image: creditCardImage)
        creditCardView.frame = CGRect(x: CGFloat((view.frame.size.width - creditCardImage.size.width) / 2.0), y: CGFloat(90.0), width: CGFloat(creditCardImage.size.width), height: CGFloat(creditCardImage.size.height))
        view.addSubview(creditCardView)
        let creditCardLabel = UILabel()
        creditCardLabel.text = "Enter your credit card information"
        creditCardLabel.backgroundColor = UIColor.clear
        creditCardLabel.font = UIFont(name: "HelveticaNeue-Medium", size: CGFloat(14.0))
        creditCardLabel.textColor = UIColor(red: CGFloat(72.0 / 255.0), green: CGFloat(98.0 / 255.0), blue: CGFloat(111.0 / 255.0), alpha: CGFloat(1.0))
        creditCardLabel.shadowColor = UIColor(white: CGFloat(1.0), alpha: CGFloat(0.7))
        view.addSubview(creditCardLabel)
        
        view.addSubview(checkoutView)
        view.addSubview(hud)
        
    }

    // MARK: - actions
    func buy() {
        title = "Authorizing..."
        
        checkoutView.createToken() {
            token, error in
            if error != nil {
                self.displayError(error: error!)
            } else {
                self.chargeItems(token: token!)
            }
        }
    }
    
    // MARK: - private func
    func displayError(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription , preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func chargeItems(token: STPToken) {
        title = "Charging..."
        
        let productInfo: [String: AnyObject] = ["cardToken": token.tokenId as AnyObject, "name": shippingInfo["name"]!, "email": shippingInfo["email"]!, "address": shippingInfo["address"]!, "zip": shippingInfo["zip"]!, "city_state": shippingInfo["cityState"]!]
        PFCloud.callFunction(inBackground: "purchaseItemsInCart", withParameters: productInfo, block: {(_ object: Any, _ error: Error?) -> Void in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error!.localizedDescription , preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                let finishController = PFFinishViewController()
                self.navigationController?.pushViewController(finishController, animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CheckoutFinished"), object: nil)
            }
        })
    }
}
