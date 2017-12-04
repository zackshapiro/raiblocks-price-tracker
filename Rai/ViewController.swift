//
//  ViewController.swift
//  Rai
//
//  Created by Zack Shapiro on 11/11/17.
//  Copyright © 2017 Zack Shapiro. All rights reserved.
//

import UIKit
import Cartography


struct XRBPair: Codable {

    let pairs: [String: Pair]

    var xrbPair: Pair {
        return pairs.filter { $0.key == "XRB_BTC" }.first!.value
    }

    struct Pair: Codable {
        let last: String
    }

}


class ViewController: UIViewController {
    
    private weak var scrollView: UIScrollView?
    private weak var label: UILabel?
    private weak var btcBalanceLabel: UILabel?
    private weak var textField: UITextField?
    
    private weak var ownedViewTopConstraint: NSLayoutConstraint?
    
    private var lastTradePrice: Double?
    private var amountIOwn: Double?
    
    override var prefersStatusBarHidden: Bool { return true }
    
    private func calculateBTCAmount() {
        guard let amountIOwn = amountIOwn, let price = lastTradePrice else { return }
        let sats = price * 100_000_000
        let balance = (sats * amountIOwn) / 100_000_000
        
        self.btcBalanceLabel?.text = "\(String(balance)) BTC"
    }
    
    @objc private func getPriceAndSetLabel() {
        guard let url = URL(string: "https://mercatox.com/public/json24") else { fatalError("url failed to cast") }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil else { return }
            
            if let data = data, let xrb = try? JSONDecoder().decode(XRBPair.self, from: data) {
                let lastTradePrice = xrb.xrbPair.last

                DispatchQueue.main.async {
                    self.label?.text = lastTradePrice
                    self.textField?.resignFirstResponder()
                    self.scrollView?.refreshControl?.endRefreshing()

                    self.lastTradePrice = Double(lastTradePrice)
                    self.calculateBTCAmount()
                }
            }
        }.resume()
    }
    
    init() {
        self.amountIOwn = UserDefaults.standard.object(forKey: "xrbAmount") as? Double
        super.init(nibName: nil, bundle: nil)
        
        getPriceAndSetLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ownedView = UIView()
        view.addSubview(ownedView)
        
        let ownLabel: UILabel = {
            let label = UILabel()
            label.text = "I own"
            label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
            
            return label
        }()
        ownedView.addSubview(ownLabel)
        constrain(ownLabel) {
            $0.top == $0.superview!.top + CGFloat(8)
            $0.left == $0.superview!.left + CGFloat(16)
            $0.bottom == $0.superview!.bottom - CGFloat(8)
        }
        
        let xrbLabel: UILabel = {
            let label = UILabel()
            label.text = "xrb"
            label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
            
            return label
        }()
        ownedView.addSubview(xrbLabel)
        constrain(xrbLabel) {
            $0.top == $0.superview!.top + CGFloat(8)
            $0.right == $0.superview!.right - CGFloat(16)
            $0.bottom == $0.superview!.bottom - CGFloat(8)
        }
        
        let textField: UITextField = {
            let t = UITextField()
            t.placeholder = "10000"
            if let amount = amountIOwn {
                t.text = String(amount)
            }
            t.font = UIFont.systemFont(ofSize: 20, weight: .regular)
            t.textAlignment = .right
            t.keyboardType = .decimalPad
            t.returnKeyType = .done
            t.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
            
            return t
        }()
        ownedView.addSubview(textField)
        constrain(textField, ownLabel, xrbLabel) {
            $0.top == $1.top
            $0.bottom == $1.bottom
            $0.right == $2.left - CGFloat(8)
            $0.width == CGFloat(240)
        }
        self.textField = textField
        
        constrain(ownedView) {
            self.ownedViewTopConstraint = $0.top == $0.superview!.top // - CGFloat(30)
            $0.left == $0.superview!.left
            $0.right == $0.superview!.right
        }
    
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getPriceAndSetLabel), for: .valueChanged)
        
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.refreshControl = refreshControl
        scrollView.addSubview(refreshControl)
        view.addSubview(scrollView)
        constrain(scrollView, ownedView) {
            $0.top == $1.bottom
            $0.left == $0.superview!.left
            $0.right == $0.superview!.right
            $0.bottom == $0.superview!.bottom
        }
        self.scrollView = scrollView
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        label.textColor = .black
        scrollView.addSubview(label)
        constrain(label) {
            $0.center == $0.superview!.center
        }
        self.label = label
        
        let btcBalanceLabel: UILabel = {
            let l = UILabel()
            l.font = UIFont.systemFont(ofSize: 24, weight: .regular)
            l.textColor = UIColor.from(rgb: 0x438297).withAlphaComponent(0.8)
            
            return l
        }()
        view.addSubview(btcBalanceLabel)
        constrain(btcBalanceLabel, label) {
            $0.top == $1.bottom + CGFloat(12)
            $0.centerX == $0.superview!.centerX
        }
        self.btcBalanceLabel = btcBalanceLabel
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func textDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        // TODO: prevent multiple decimals
        
        btcBalanceLabel?.isHidden = textField.text == ""
        
        let balance = Double(text)
        amountIOwn = balance
        
        UserDefaults.standard.set(balance, forKey: "xrbAmount")
        
        calculateBTCAmount()
    }
}
