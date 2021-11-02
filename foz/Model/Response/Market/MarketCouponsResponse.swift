//
//  MarketCouponsResponse.swift
//  foz
//
//  Created by Ahmed Medhat on 31/10/2021.
//

import Foundation

struct MarketCouponsResponse: Codable {
    let data: [MarketCouponsData]
}

struct MarketCouponsData: Codable {
    let id: Int
    let coupon_id: Int
    let offer_price: String
    let status: String
    let provider_image: String
    let price_before_discount: String
    let discount: String
}
