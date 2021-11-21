//
//  AdsInsideCategoryResponse.swift
//  foz
//
//  Created by Ahmed Medhat on 16/11/2021.
//

import Foundation

struct AdsInsideCategoryResponse: Codable {
    let data: [AdsInsideCategoryData]
}

struct AdsInsideCategoryData: Codable {
    let id: Int
    let title: String
    let video_url: String
    let image_url: String
    let description: String
    let ad_logo: String
}
