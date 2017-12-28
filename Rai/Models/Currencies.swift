//
//  Currencies.swift
//  Rai
//
//  Created by Ryan Fox on 12/27/17.
//  Copyright © 2017 Zack Shapiro. All rights reserved.
//

import Foundation

internal enum Currency {
    case btc
    case eur
    case usd
    
    static func from(_ string: String?) -> Currency? {
        if string == Currency.btc.ticker {
            return .btc
        } else if string == Currency.usd.ticker {
            return .usd
        } else if string == Currency.eur.ticker {
            return .eur
        }
        
        return nil
    }
    
    internal var ticker: String {
        switch(self) {
        case .btc: return "BTC"
        case .eur: return "EUR"
        case .usd: return "USD"
        }
    }
}
