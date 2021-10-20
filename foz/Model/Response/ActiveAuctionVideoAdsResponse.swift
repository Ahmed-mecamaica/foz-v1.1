//
//  ActiveAuctionVideoAdsResponse.swift
//  foz
//
//  Created by Ahmed Medhat on 18/10/2021.
//

import Foundation

struct ActiveAuctionVideoAdsResponse: Codable {
    let state: String
    let data: VideoAdData
}

struct VideoAdData: Codable {
    let id: Int
    let video_url: String
}
