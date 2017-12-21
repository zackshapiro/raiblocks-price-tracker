//
//  Pairs.swift
//  Rai
//
//  Created by Zack Shapiro on 12/20/17.
//  Copyright © 2017 Zack Shapiro. All rights reserved.
//

import Foundation

struct BGXRBPair: Decodable {

    let response: Response

    var xrbPair: String {
        return response.last
    }

    struct Response: Decodable {
        let last: String
    }

}

struct MercXRBPair: Decodable {

    let pairs: [String: Pair]

    var xrbPair: Pair {
        return pairs.filter { $0.key == "XRB_BTC" }.first!.value
    }

    struct Pair: Decodable {
        let last: String
    }

}

enum DecodableErrors: Error {
    case priceError
}

struct BTCUSDPair: Decodable {

    let symbol: String
    let priceUSD: Double

    enum CodingKeys: String, CodingKey {
        case symbol
        case priceUSD = "price_usd"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.symbol = try container.decode(String.self, forKey: .symbol)
        let _priceUSD = try container.decode(String.self, forKey: .priceUSD)

        guard let price = Double(_priceUSD) else { throw DecodableErrors.priceError }

        self.priceUSD = price
    }
}

