//
//  TodayViewController.swift
//  RaiToday
//
//  Created by Zack Shapiro on 11/11/17.
//  Copyright © 2017 Zack Shapiro. All rights reserved.
//

import UIKit
import NotificationCenter
import Cartography
import SwiftyJSON


class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var label: UILabel!
    
    private func fetchPrice(_ completion: @escaping ((Double?, Error?) -> ())) {
        let url = URL(string: "https://api.coinmarketcap.com/v1/ticker/raiblocks/")!
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let data = data {
                let json = JSON(data)[0].dictionaryValue
                let stringVal = json["price_btc"]?.stringValue ?? ""
                let converted = Double(stringVal)
                completion(converted, nil)
            } else {
                completion(0, nil)
            }
            }.resume()
    }

    private func setLabel(withPrice price: String) {
        DispatchQueue.main.async {
            self.label.text = price
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton()
        button.addTarget(self, action: #selector(openApp), for: .touchUpInside)
        view.addSubview(button)
        constrain(button) {
            $0.edges == $0.superview!.edges
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func openApp() {
        guard let url = URL(string: "rai://") else { return }

        self.extensionContext?.open(url, completionHandler: nil)
    }
    
    func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        self.fetchPrice { price, error in
            if let price = price {
                self.setLabel(withPrice: String(price))
            }
        }
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(.newData)
    }
}
