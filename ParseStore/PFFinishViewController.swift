//
//  PFFinishViewController.swift
//  ParseStore
//
//  Created by Zhitao Fan on 5/11/17.
//  Copyright © 2017 Zhitao Fan. All rights reserved.
//

import UIKit

class PFFinishViewController: UIViewController {

    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.popToRootViewController(animated: false)
    }

    override func loadView() {
        super.loadView()
        
        title = "Thank you!"
        
        let confirmation = UIImage(named: "IconConfirmation.png")!
        let confirmationView = UIImageView(image: confirmation)
        confirmationView.frame = CGRect(x: CGFloat((view.frame.size.width - confirmation.size.width) / 2.0), y: CGFloat(100.0), width: CGFloat(confirmation.size.width), height: CGFloat(confirmation.size.height))
        view.addSubview(confirmationView)
        let congratulationsLabel = UILabel()
        congratulationsLabel.text = "Congratulations!"
        congratulationsLabel.backgroundColor = UIColor.clear
        congratulationsLabel.font = UIFont(name: "HelveticaNeue-Medium", size: CGFloat(26.0))
        congratulationsLabel.textColor = UIColor(red: CGFloat(132.0 / 255.0), green: CGFloat(140.0 / 255.0), blue: CGFloat(147.0 / 255.0), alpha: CGFloat(1.0))
        congratulationsLabel.shadowColor = UIColor(white: CGFloat(1.0), alpha: CGFloat(0.7))
        congratulationsLabel.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(0.5))
        congratulationsLabel.sizeToFit()
        congratulationsLabel.frame = CGRect(x: CGFloat((view.frame.size.width - congratulationsLabel.frame.size.width) / 2.0), y: CGFloat(250.0), width: CGFloat(congratulationsLabel.frame.size.width), height: CGFloat(congratulationsLabel.frame.size.height))
        view.addSubview(congratulationsLabel)
        
        let ownerLabel = UILabel()
        ownerLabel.text = "Checkout succeeded."
        ownerLabel.numberOfLines = 2
        ownerLabel.textAlignment = .center
        ownerLabel.backgroundColor = UIColor.clear
        ownerLabel.font = UIFont(name: "HelveticaNeue-Medium", size: CGFloat(17.0))
        ownerLabel.textColor = UIColor(red: CGFloat(132.0 / 255.0), green: CGFloat(140.0 / 255.0), blue: CGFloat(147.0 / 255.0), alpha: CGFloat(1.0))
        ownerLabel.shadowColor = UIColor(white: CGFloat(1.0), alpha: CGFloat(0.7))
        ownerLabel.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(0.5))
        ownerLabel.sizeToFit()
        ownerLabel.frame = CGRect(x: CGFloat((view.frame.size.width - ownerLabel.frame.size.width) / 2.0), y: CGFloat(300.0), width: CGFloat(ownerLabel.frame.size.width), height: CGFloat(ownerLabel.frame.size.height))
        view.addSubview(ownerLabel)
        
        let buyButton = UIButton(type: .custom)
        buyButton.setTitle(NSLocalizedString("Buy something else", comment: "Buy something else"), for: .normal)
        buyButton.titleLabel?.shadowColor = UIColor(white: CGFloat(0.0), alpha: CGFloat(0.7))
        buyButton.titleLabel?.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(-0.5))
        buyButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: CGFloat(14.0))
        
        let checkoutImage = UIImage(named: "ButtonCheckout.png")!
        let checkoutPressedImage = UIImage(named: "ButtonCheckoutPressed.png")
        let insets: UIEdgeInsets? = UIEdgeInsetsMake(checkoutImage.size.height / 2, checkoutImage.size.width / 2, checkoutImage.size.height / 2, checkoutImage.size.width / 2)
        buyButton.setBackgroundImage(checkoutImage.resizableImage(withCapInsets: insets!), for: .normal)
        buyButton.setBackgroundImage(checkoutPressedImage?.resizableImage(withCapInsets: insets!), for: .highlighted)
        buyButton.addTarget(self, action: #selector(self.buy), for: .touchUpInside)
        buyButton.frame = CGRect(x: CGFloat((view.frame.size.width - 195.0) / 2.0), y: CGFloat(370.0), width: CGFloat(195.0), height: CGFloat(checkoutImage.size.height))
        view.addSubview(buyButton)
    }
    
    // MARK: - actions
    
    func buy(sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
