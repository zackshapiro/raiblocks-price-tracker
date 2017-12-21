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


class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var label: UILabel!

    private func fetchLatestBTCPrice() {
        guard let url = URL(string: "https://bitgrail.com/api/v1/BTC-XRB/ticker") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil else { return self.fetchPriceFromMercatox() }

            if let data = data, let xrb = try? JSONDecoder().decode(BGXRBPair.self, from: data) {
                DispatchQueue.main.async {
                    self.setLabel(withPrice: xrb.xrbPair)
                }
            } else {
                self.fetchPriceFromMercatox()
            }
        }.resume()
    }

    private func fetchPriceFromMercatox() {
        guard let url = URL(string: "https://mercatox.com/public/json24") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil else {
                self.setLabel(withPrice: "0")

                return
            }

            if let data = data, let xrb = try? JSONDecoder().decode(MercXRBPair.self, from: data) {
                self.setLabel(withPrice: xrb.xrbPair.last)
            } else {
                self.setLabel(withPrice: "0")
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
        fetchLatestBTCPrice()
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(.newData)
    }
}
