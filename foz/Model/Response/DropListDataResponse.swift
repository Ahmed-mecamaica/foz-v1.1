//
//  InterestsDataResponse.swift
//  foz
//
//  Created by Ahmed Medhat on 25/08/2021.
//

import Foundation

struct DropListDataResponse: Codable {
    let data: [DropListData]
}

struct DropListData: Codable {
    let id: Int
    let name: String
}
