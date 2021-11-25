//
//  AllCouponResponse.swift
//  foz
//
//  Created by Ahmed Medhat on 23/11/2021.
//

import Foundation


struct AllCouponResponse: Codable {
    let state: String
    let data: [AllCouponData]
}


struct AllCouponData: Codable {
    let id: Int?
    let user_id: Int?
    let price: String?
    let discount: Int?
    let type: String?
    let in_market: Int
    let expire_date: String?
    let status: String?
    let price_after_discount: Int
    let serial_number: String?
    let provider: AllCouponProviderData?
}

struct AllCouponProviderData: Codable {
    let id: Int?
    let image_url: String?
}
