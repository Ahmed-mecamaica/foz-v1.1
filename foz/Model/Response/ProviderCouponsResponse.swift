//
//  PrivderCouponsResponse.swift
//  foz
//
//  Created by Ahmed Medhat on 25/10/2021.
//

import Foundation

struct ProviderCouponsResponse: Codable {
    let state: String
    let data: [ProviderCouponsData]
}

struct ProviderCouponsData: Codable {
    let id: Int
    let code: String
    let expire_date: String
    let price: String
    let type: String
    let price_after_discount: Double
}
