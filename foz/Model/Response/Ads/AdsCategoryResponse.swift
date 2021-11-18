//
//  AdsCategoryResponse.swift
//  foz
//
//  Created by Ahmed Medhat on 16/11/2021.
//

import Foundation

struct AdsCategoryResponse: Codable {
    let data: [AdsCategoryData]
}

struct AdsCategoryData: Codable {
    let id: Int
    let name: String
    let image_url: String
    let ads_count: Int
}
