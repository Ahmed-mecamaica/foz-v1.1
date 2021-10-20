//
//  ResendOtpResponse.swift
//  foz
//
//  Created by Ahmed Medhat on 17/10/2021.
//

import Foundation

struct ResendOtpResponse: Codable {
    let state: String
    let data: ResendOtpData
}


struct ResendOtpData: Codable {
    let id: Int
}
