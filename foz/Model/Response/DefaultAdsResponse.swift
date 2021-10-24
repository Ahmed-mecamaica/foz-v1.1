//
//  DefaultAdsResponse.swift
//  foz
//
//  Created by Ahmed Medhat on 24/10/2021.
//

import Foundation

struct DefaultAdsResponse: Codable {
    let state: String
    let data: DefaultAdsData
}

struct DefaultAdsData: Codable {
    let id: Int
    let image_url: String
}
