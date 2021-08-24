//
//  Auth.swift
//  foz
//
//  Created by Ahmed Medhat on 23/08/2021.
//

import Foundation

class AuthService {
    static let instance = AuthService()
    
    struct Auth {
        static var token = ""
        static var otp = ""
    }
    
    enum Endpoints {
        static let base = "https://fooz.macber-eg.com/"
        static let auth = "auth/authapi/"
        
        case login
        case otp
        
        var stringValue: String {
            switch self {
            case .login:
                return Endpoints.base + Endpoints.auth + "login"
            case .otp:
                return Endpoints.base + Endpoints.auth + "verify"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    func login(phoneNum: String, completion: @escaping (String, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.login.url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let body = LoginRequest(phone: phoneNum)
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion("", error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(LoginResponse.self, from: data)
                Auth.token = result.data.access_token
                completion(result.data.access_token, nil)
            } catch {
                completion("", error)
            }
        }
        task.resume()
    }
    
    func sendOtp(otp: String, completion: @escaping (String, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.otp.url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(Auth.token)", forHTTPHeaderField: "Api-token")
        request.httpMethod = "POST"
        let body = OtpRequest(otp: otp)
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion("", error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(LoginResponse.self, from: data)
                completion(result.new, nil)
            } catch {
                completion("", error)
            }
        }
        task.resume()
    }
}
