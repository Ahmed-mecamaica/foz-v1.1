//
//  LoginResponse.swift
//  foz
//
//  Created by Ahmed Medhat on 23/08/2021.
//

import Foundation

struct LoginResponse: Codable {
    let state: String
    let new: String
    let data: LoginResponseData
}

struct LoginResponseData: Codable {
    let access_token: String
}
