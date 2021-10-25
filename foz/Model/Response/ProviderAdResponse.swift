//
//  ProviderAdResponse.swift
//  foz
//
//  Created by Ahmed Medhat on 25/10/2021.
//

import Foundation

struct ProviderAdResponse: Codable {
    let state: String
    let data: ProviderAdData
}

struct ProviderAdData: Codable {
    let id: Int
    let video_url: String
    let views: Int
}
