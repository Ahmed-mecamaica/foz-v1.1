//
//  LoginResponse.swift
//  foz
//
//  Created by Ahmed Medhat on 23/08/2021.
//

import Foundation

struct LoginResponse: Codable, Storable {
    let state: String
    let new: String
    let data: LoginResponseData
}

struct LoginResponseData: Codable {
    let access_token: String
}


protocol Storable {
    static var current: Self? { get set }
    func save()
}

extension Storable where Self: Codable {
    fileprivate static var key: String {
        return "Current_\(String.init(describing: Self.self))"
    }
    static var current: Self? {
        set {
            if let value = newValue, let encoded = try? JSONEncoder().encode(value) {
                    UserDefaults.standard.set(encoded, forKey: key)
            } else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        } get {
            guard let encoded = UserDefaults.standard.object(forKey: key) as? Data else {
                return nil
            }
            return try? JSONDecoder().decode(Self.self, from: encoded)
        }
    }
    func save() {
        Self.current = self
    }
}
