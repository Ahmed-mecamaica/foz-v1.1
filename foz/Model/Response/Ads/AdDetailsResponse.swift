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
}

