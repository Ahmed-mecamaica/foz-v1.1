//
//  OffersProvidersResponse.swift
//  foz
//
//  Created by Ahmed Medhat on 24/10/2021.
//

import Foundation

struct OffersProvidersResponse: Codable {
    let state: String
    let data: [OffersProvidersData]
}

struct OffersProvidersData: Codable {
    let id: Int
    let name: String
    let image_url: String
}
