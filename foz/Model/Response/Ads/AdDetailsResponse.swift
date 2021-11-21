//
//  AdDetailsResponse.swift
//  foz
//
//  Created by Ahmed Medhat on 18/11/2021.
//

import Foundation

struct AdDetailsResponse: Codable {
    
    let data: AdDetailsData
}

struct AdDetailsData: Codable {
    let id: Int
    let video_url: String
    let image_url: String
    let description: String
    let ad_logo: String
    let coupon: CouponInAdDetailsData?
}

struct CouponInAdDetailsData: Codable {
    let id: Int
    let code: String
    let price: String
    let price_after_discount: Double
    let expire_date: String
}
