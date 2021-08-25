//
//  RegisterUserRequest.swift
//  foz
//
//  Created by Ahmed Medhat on 25/08/2021.
//

import Foundation

struct RegisterUserRequest: Codable {
    let username: String
    let birthdate: String
    let city: String
    let incomelevel: String
    let gender: String
}
