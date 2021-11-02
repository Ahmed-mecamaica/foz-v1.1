//
//  CouponDetailsResponse.swift
//  foz
//
//  Created by Ahmed Medhat on 01/11/2021.
//

import Foundation

struct CouponDetailsResponse: Codable {
    let data: CouponDetailsData
}

struct CouponDetailsData: Codable {
    let coupon_id: Int
    let user_id: Int
    let offer_price: String
    let expire_date: String
    let status: String
    let last_username: String
    let last_amount: Double
    let views: Int
    let discount: String
    let provider_image: String
    let price_before_discount: String
}
