//
//  SoldAuctionResponse.swift
//  foz
//
//  Created by Ahmed Medhat on 29/09/2021.
//

import Foundation

struct SoldAuctionResponse: Codable {
    let data: [SoldAuctionData]
}

struct SoldAuctionData: Codable {
    let id: Int
    let title: String
    let description: String
    let start_price: String
    let end_price: String
    let image_url: String
    let serial_number: String
    let provider_image: String
    let time: String
    let winner_name: String
    let winner_amount: String
}
