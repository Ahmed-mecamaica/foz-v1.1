//
//  InterestsDataResponse.swift
//  foz
//
//  Created by Ahmed Medhat on 26/08/2021.
//

import Foundation

struct InterestsDataResponse: Codable {
    let data: [InterestsPhoto]
}

struct InterestsPhoto: Codable {
    let id: Int
    let name: String
    let image_url: String
}
