//
//  ContactUsResponse.swift
//  foz
//
//  Created by Ahmed Medhat on 14/10/2021.
//

import Foundation


struct ContactUsResponse: Codable {
    let result: [ContactusMessageArray]
}

struct ContactusMessageArray: Codable {
    let message: String
    let status: String
}
