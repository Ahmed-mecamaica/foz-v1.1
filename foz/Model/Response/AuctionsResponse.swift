//
//  ActiveAuctionsResponse.swift
//  foz
//
//  Created by Ahmed Medhat on 22/09/2021.
//

import Foundation

struct AuctionsResponse: Codable {
    let data: AuctionsAllData
}


struct AuctionsAllData: Codable {
    let active: AuctionData
    let inactive: [AuctionData]
    let sold: [AuctionData]
}

struct AuctionData: Codable {
    let id: Int
    let title: String
    let description: String
    let start_price: String
    let end_price: String
    let image_url: String
    let serial_number: String
    let provider_image: String
    let time: String
    
}
