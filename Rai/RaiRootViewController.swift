//
//  ViewController.swift
//  Rai
//
//  Created by Zack Shapiro on 11/11/17.
//  Copyright © 2017 Zack Shapiro. All rights reserved.
//

import UIKit
import Cartography


class RaiRootViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool { return true }
    
    private let raiRootView = RaiRootView(frame: .zero)
    
    private var lastTradePrice: Double?
    
    private var amountIOwn: Double? = UserDefaults.standard.object(forKey: "xrbAmount") as? Double
    
    private let currencies: [Currency] = [.btc, .eur, .usd]
    
    private var currencyPreference: Currency = {
        let string = UserDefaults.standard.object(forKey: "currencyPreference") as? String
        let currency = Currency.from(string) ?? .btc
        UserDefaults.standard.set(currency.ticker, forKey: "currencyPreference")
        return currency
    }()

    override func loadView() {
        self.view = self.raiRootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.raiRootView.textField.text = self.amountIOwn?.description
        self.raiRootView.textField.delegate = self
        self.raiRootView.textField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        self.raiRootView.refreshControl.addTarget(self, action: #selector(self.refreshPulled), for: .valueChanged)
        self.raiRootView.currencyButton.addTarget(self, action: #selector(self.currencyButtonTapped), for: .touchUpInside)
        self.updatePrice()
        
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped))
        self.raiRootView.addGestureRecognizer(dismissKeyboardTap)
        
        self.raiRootView.currencyPickerView.delegate = self
        self.raiRootView.currencyPickerView.dataSource = self
    }
    
    @objc private func backgroundTapped() {
        self.raiRootView.textField.resignFirstResponder()
        self.raiRootView.currencyPickerView.isHidden = true
    }
}

extension RaiRootViewController {
    @objc private func refreshPulled() {
        self.raiRootView.textField.resignFirstResponder()
        self.raiRootView.refreshControl.endRefreshing()
    }
}

extension RaiRootViewController {
    @objc private func updatePrice() {
        PriceController.fetchPrice(currency: self.currencyPreference) { (price, error) in
            DispatchQueue.main.async {
                guard let price = price else {
                    return
                }
                
                self.lastTradePrice = price
                
                self.syncLabels()
            }
        }
    }
    
    private func syncLabels() {
        let rounded = String(format:"%.6f", self.lastTradePrice ?? 0)
        self.raiRootView.priceLabel.text = "\(rounded.description) \(self.currencyPreference.ticker)/XRB"
        
        guard let amount = self.amountIOwn, let price = self.lastTradePrice else {
            self.raiRootView.currencyButton.isHidden = true
            return
        }
        
        let btcValue = self.btc(forXrbAmount: amount, xrbValue: price)
        self.raiRootView.currencyButton.isHidden = btcValue <= 0
        self.raiRootView.balanceLabel.text = String(btcValue)
        self.raiRootView.currencyButton.setTitle(" \(self.currencyPreference.ticker) ", for: .normal)
    }
}

extension RaiRootViewController {
    private func btc(forXrbAmount amount: Double, xrbValue: Double) -> Double {
        let sats = xrbValue * 100_000_000
        let balance = (sats * amount) / 100_000_000
        return balance
    }
}

extension RaiRootViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.currencies[row].ticker
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currencyPreference = self.currencies[row]
        self.updatePrice()
    }
    
    @objc private func currencyButtonTapped() {
        self.raiRootView.currencyPickerView.isHidden = false
    }
}

extension RaiRootViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // make sure we don't put in letters or double-decimals
        // todo: prevent pasting double-decimals
        let currentText = textField.text ?? ""
        let containsLetters = !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
        let inputtingDecimal = string == "."
        let doubleDecimals = currentText.contains(".") && string.contains(".")
        let emptyInput = string.count == 0
        let underMaxValue = Double(currentText) ?? 0 < 99999
        let nonNegative = Double(currentText) ?? 0 >= 0
        return emptyInput || !(containsLetters && !inputtingDecimal) && !doubleDecimals && underMaxValue && nonNegative
    }
    
    @objc func textDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        self.raiRootView.balanceLabel.isHidden = self.raiRootView.textField.text?.count == 0
        self.amountIOwn = Double(text)
        
        UserDefaults.standard.set(self.amountIOwn, forKey: "xrbAmount")
        self.syncLabels()
    }
}
