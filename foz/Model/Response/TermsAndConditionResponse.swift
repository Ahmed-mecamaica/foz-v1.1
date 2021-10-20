//
//  TermsAndConditionResponse.swift
//  foz
//
//  Created by Ahmed Medhat on 17/10/2021.
//

import Foundation

struct TermsAndConditionResponse: Codable {
    let data: TermsAndConditionData
}

struct TermsAndConditionData: Codable {
    let description: String
}
