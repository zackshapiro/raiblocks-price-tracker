//
//  PriceController.swift
//  Rai
//
//  Created by Ryan Fox on 12/22/17.
//  Copyright © 2017 Zack Shapiro. All rights reserved.
//

import Foundation
import SwiftyJSON

public class PriceController {
    class func fetchPrice(currency: Currency, _ completion: @escaping ((Double?, Error?) -> ())) {
        let url = URL(string: "https://api.coinmarketcap.com/v1/ticker/raiblocks/?convert=\(currency.ticker)")!
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let data = data {
                let json = JSON(data)[0].dictionaryValue
                let key = "price_\(currency.ticker.lowercased())"
                let stringVal = json[key]?.stringValue ?? ""
                let converted = Double(stringVal)
                completion(converted, nil)
            } else {
                completion(0, nil)
            }
            }.resume()
    }
}
