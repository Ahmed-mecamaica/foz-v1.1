//
//  ActiveAuctionResponse.swift
//  foz
//
//  Created by Ahmed Medhat on 26/09/2021.
//

import Foundation

struct ActiveAuctionResponse: Codable {
    let data: ActiveAuctionData
}

struct ActiveAuctionData: Codable {
    let auction: AuctionData
    let last_bid: LastBidData
}

struct LastBidData: Codable {
    let id: Int
    let username: String
    let amount: String
}
