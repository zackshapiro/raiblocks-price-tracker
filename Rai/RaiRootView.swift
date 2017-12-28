//
//  RaiRootView.swift
//  Rai
//
//  Created by Ryan Fox on 12/27/17.
//  Copyright © 2017 Zack Shapiro. All rights reserved.
//

import UIKit
import Cartography


class RaiRootView: UIView {
    
    internal let refreshControl = UIRefreshControl()
    
    private let scrollView = UIScrollView()
    
    private let raiImageView = with(UIImageView(image: UIImage(named: "rai"))) {
        $0.contentMode = .scaleAspectFit
        $0.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    internal let priceLabel = with(UILabel()) {
        $0.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        $0.adjustsFontSizeToFitWidth = true
        $0.textColor = UIColor.from(red: 193, green: 211, blue: 81)
    }
    
    internal let currencyPickerView = with(UIPickerView()) {
        $0.heightAnchor.constraint(equalToConstant: 150).isActive = true
        $0.isHidden = true
        $0.backgroundColor = .white
    }
    
    internal let currencyButton = with(UIButton(type: .roundedRect)) {
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.from(red: 135, green: 205, blue: 241).cgColor
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        $0.setTitleColor(UIColor.from(red: 135, green: 205, blue: 241), for: .normal)
        $0.isHidden = true
    }
    
    internal let balanceLabel = with(UILabel()) {
        $0.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        $0.adjustsFontSizeToFitWidth = true
        $0.textColor = UIColor.from(red: 135, green: 205, blue: 241)
    }
    
    internal let textField = with(UITextField()) {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        $0.textAlignment = .right
        $0.keyboardType = .decimalPad
        $0.returnKeyType = .done
        $0.placeholder = "10000"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.from(red: 46, green: 116, blue: 247)
        
        let ownedView: UIView = with(UIView()) {
            self.addSubview($0)
            $0.addSubview(self.textField)
            $0.translatesAutoresizingMaskIntoConstraints = false
            if #available(iOS 11.0, *) {
                $0.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
            } else {
                $0.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            }
            $0.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            $0.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        }
        
        let ownLabel: UILabel = with(UILabel()) {
            $0.text = "I own"
            $0.font = UIFont.systemFont(ofSize: 20, weight: .regular)
            ownedView.addSubview($0)
        }
        constrain(ownLabel) {
            $0.top == $0.superview!.top + CGFloat(8)
            $0.left == $0.superview!.left + CGFloat(16)
            $0.bottom == $0.superview!.bottom - CGFloat(8)
        }
        
        let xrbLabel: UILabel = with(UILabel()) {
            $0.text = "XRB"
            $0.font = UIFont.systemFont(ofSize: 20, weight: .regular)
            ownedView.addSubview($0)
        }
        
        constrain(xrbLabel) {
            $0.top == $0.superview!.top + CGFloat(8)
            $0.right == $0.superview!.right - CGFloat(16)
            $0.bottom == $0.superview!.bottom - CGFloat(8)
        }
        
        constrain(textField, ownLabel, xrbLabel) {
            $0.top == $1.top
            $0.bottom == $1.bottom
            $0.right == $2.left - CGFloat(8)
            $0.width == CGFloat(240)
        }
        
        self.scrollView.refreshControl = self.refreshControl
        self.scrollView.addSubview(self.refreshControl)
        
        self.addSubview(self.scrollView)
        constrain(self.scrollView, ownedView) {
            $0.top == $1.bottom
            $0.left == $0.superview!.left
            $0.right == $0.superview!.right
            $0.bottom == $0.superview!.bottom
        }
        
        self.scrollView.addSubview(self.priceLabel)
        constrain(self.scrollView, self.priceLabel) {
            $1.center == $0.center
        }
        
        let stackView = UIStackView(arrangedSubviews: [self.balanceLabel, self.currencyButton])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 4
        
        self.addSubview(stackView)
        constrain(stackView, self.priceLabel) {
            $0.top == $1.bottom + CGFloat(12)
            $0.centerX == $0.superview!.centerX
        }
        
        self.addSubview(self.currencyPickerView)
        constrain(self, currencyPickerView) {
            $1.left == $0.left
            $1.bottom == $0.bottom
            $1.right == $0.right
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
