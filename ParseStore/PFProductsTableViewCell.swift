//
//  PFProductsTableViewCell.swift
//  ParseStore
//
//  Created by Zhitao Fan on 5/11/17.
//  Copyright © 2017 Zhitao Fan. All rights reserved.
//

import UIKit
import ParseUI

class PFProductsTableViewCell: PFTableViewCell {
    
    let ROW_MARGIN: CGFloat = 6.0
    let ROW_HEIGHT: CGFloat = 173.0
    
    var buttonSize: UIButton?
    let buttonOrder: UIButton?
    let labelPrice: UILabel?
    let labelQuantity: UILabel?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        buttonSize = UIButton(type: .custom)
        buttonOrder = UIButton(type: .custom)
        labelPrice = UILabel()
        labelQuantity = UILabel()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        labelPrice?.font = UIFont(name: "HelveticaNeue-Medium", size: CGFloat(20.0))
        labelPrice?.textColor = UIColor(red: CGFloat(14.0 / 255.0), green: CGFloat(190.0 / 255.0), blue: CGFloat(255.0 / 255.0), alpha: CGFloat(1.0))
        labelPrice?.shadowColor = UIColor(white: CGFloat(1.0), alpha: CGFloat(0.7))
        labelPrice?.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(0.5))
        labelPrice?.backgroundColor = UIColor.clear
        contentView.addSubview(labelPrice!)
        
        buttonOrder?.setTitle("Add to Cart", for: .normal)
        buttonOrder?.titleLabel?.shadowColor = UIColor(white: CGFloat(0.0), alpha: CGFloat(0.7))
        buttonOrder?.titleLabel?.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(-0.5))
        buttonOrder?.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: CGFloat(16.0))
        
        let orderImage = UIImage(named: "ButtonOrder.png")!
        let orderPressedImage = UIImage(named: "ButtonOrderPressed.png")!
        let insets: UIEdgeInsets? = UIEdgeInsetsMake(orderImage.size.height / 2, orderImage.size.width / 2, orderImage.size.height / 2, orderImage.size.width / 2)
        buttonOrder?.setBackgroundImage(orderImage.resizableImage(withCapInsets: insets!), for: .normal)
        buttonOrder?.setBackgroundImage(orderPressedImage.resizableImage(withCapInsets: insets!), for: .highlighted)
        addSubview(buttonOrder!)
        
        labelQuantity?.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(50.0), height: CGFloat(20.0))
        labelQuantity?.font = UIFont(name: "HelveticaNeue-Medium", size: CGFloat(20.0))
        labelQuantity?.textColor = UIColor(red: CGFloat(14.0 / 255.0), green: CGFloat(190.0 / 255.0), blue: CGFloat(255.0 / 255.0), alpha: CGFloat(1.0))
        labelQuantity?.shadowColor = UIColor(white: CGFloat(1.0), alpha: CGFloat(0.7))
        labelQuantity?.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(0.5))
        labelQuantity?.backgroundColor = UIColor.clear
        labelQuantity?.text = "1"
        contentView.addSubview(labelQuantity!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var x = ROW_MARGIN, y = ROW_MARGIN
        
        backgroundView?.frame = CGRect(x: x, y: y, width: CGFloat(frame.size.width - ROW_MARGIN * 2.0), height: CGFloat(167.0))
        x += 10.0
        imageView?.frame = CGRect(x: CGFloat(x), y: CGFloat(y + 1.0), width: CGFloat(120.0), height: CGFloat(165.0))
        x += 120.0 + 5.0
        y += 10.0
        
        labelPrice?.sizeToFit()
        let priceX = frame.size.width - labelPrice!.frame.size.width - ROW_MARGIN - 10.0
        labelPrice?.frame = CGRect(x: priceX, y: ROW_MARGIN + 10.0, width: labelPrice!.frame.size.width, height: labelPrice!.frame.size.height)
        
        y = buttonSize != nil ? 45.0 : 55.0
        
        textLabel?.sizeToFit()
        textLabel?.frame = CGRect(x: x + 2.0, y: y, width: CGFloat(textLabel!.frame.size.width), height: textLabel!.frame.size.height)
        y += textLabel!.frame.size.height + 2.0
        if buttonSize != nil {
            buttonSize!.frame = CGRect(x: x, y: y, width: CGFloat(157.0), height: CGFloat(40.0))
            y += buttonSize!.frame.size.height + 5.0
        } else {
            y += 6.0
        }
        buttonOrder!.frame = CGRect(x: x, y: y, width: CGFloat(120.0), height: CGFloat(35.0))
        labelQuantity?.frame = CGRect(x: x + 130.0, y: y + 4.0, width: CGFloat(labelQuantity!.frame.size.width), height: CGFloat(labelQuantity!.frame.size.height))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        buttonSize?.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - public func
    public func configure(product: PFObject) {
        let backgroundImage = UIImage(named: "Product.png")!
        let backgroundInsets = UIEdgeInsetsMake(backgroundImage.size.height / 2.0, backgroundImage.size.width / 2.0, backgroundImage.size.height / 2.0, backgroundImage.size.width / 2.0)
        let backgroundImageView = UIImageView(image: backgroundImage.resizableImage(withCapInsets: backgroundInsets))
        backgroundView = backgroundImageView
        imageView?.file = (product["image"] as? PFFile)
        imageView?.contentMode = .scaleAspectFit
        imageView?.loadInBackground()
        labelPrice?.text = product["price"] as? String
        textLabel?.text = product["description"] as? String
        textLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: CGFloat(19.0))
        textLabel?.textColor = UIColor(red: CGFloat(82.0 / 255.0), green: CGFloat(87.0 / 255.0), blue: CGFloat(90.0 / 255.0), alpha: CGFloat(1.0))
        textLabel?.shadowColor = UIColor(white: CGFloat(1.0), alpha: CGFloat(0.7))
        
        buttonSize = UIButton(type: .custom)
        buttonSize?.contentHorizontalAlignment = .left
        let buttonTitle = (product["hasSize"] != nil) ? "Select Qt. & Size" : "Select Quantity"
        buttonSize?.setTitle(buttonTitle, for: .normal)
        buttonSize?.setTitleColor(UIColor(red: CGFloat(95.0 / 255.0), green: CGFloat(95.0 / 255.0), blue: CGFloat(95.0 / 255.0), alpha: CGFloat(1.0)), for: .normal)
        buttonSize?.titleEdgeInsets = UIEdgeInsetsMake(0.0, 16.0, 0.0, 0.0)
        buttonSize?.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: CGFloat(16.0))
        buttonSize?.setTitleShadowColor(UIColor.white, for: .normal)
        buttonSize?.titleLabel?.textColor = UIColor(red: CGFloat(95.0 / 255.0), green: CGFloat(95.0 / 255.0), blue: CGFloat(90.0 / 255.0), alpha: CGFloat(1.0))
        buttonSize?.titleLabel?.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(0.5))
        
        let sizeImage = UIImage(named: "DropdownButton.png")!
        let sizePressedImage = UIImage(named: "DropdownButtonPressed.png")!
        let insets: UIEdgeInsets? = UIEdgeInsetsMake(sizeImage.size.height / 2, sizeImage.size.width / 2, sizeImage.size.height / 2, sizeImage.size.width / 2)
        buttonSize?.setBackgroundImage(sizeImage.resizableImage(withCapInsets: insets!), for: .normal)
        buttonSize?.setBackgroundImage(sizePressedImage.resizableImage(withCapInsets: insets!), for: .highlighted)
        let arrowImage = UIImage(named: "Arrow.png")!
        let arrowView = UIImageView(image: arrowImage)
        arrowView.frame = CGRect(x: CGFloat(140.0), y: CGFloat((40.0 - arrowImage.size.height) / 2.0), width: CGFloat(arrowImage.size.width), height: CGFloat(arrowImage.size.height))
        buttonSize?.addSubview(arrowView)
        addSubview(buttonSize!)
    }
}
