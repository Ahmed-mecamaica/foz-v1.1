//
//  Auth.swift
//  foz
//
//  Created by Ahmed Medhat on 23/08/2021.
//

import Foundation

class AuthService {
    // Disable Policies
//    let policies: [String: ServerTrustPolicy] = [
//        "example.entrydns.org": .DisableEvaluation
//    ]
    static let instance = AuthService()
    
    struct Auth {
        static var token = ""
        static var otp = ""
    }
    
    enum Endpoints {
        
        //first base
//        static let base = "https://fooz.macber-eg.com/"
        
        //second base
        static let base = "https://foz.qbizns.com/current/"
        //local host
//        static let base = "http://192.168.1.217/macber/laravel/fooooooz/"
        static let auth = "api/auth/"
        
        case login
        case otp
        case resendOtp
        case fcmPostToken
        case userInterest
        case cities
        case incomeLevels
        case register
        
        var stringValue: String {
            switch self {
            case .login:
                return Endpoints.base + Endpoints.auth + "login"
            case .otp:
                return Endpoints.base + Endpoints.auth + "verify"
            case .resendOtp:
                return Endpoints.base + Endpoints.auth + "resend"
            case .fcmPostToken:
                return Endpoints.base + Endpoints.auth + "storeFcm"
            case .userInterest:
                return Endpoints.base + Endpoints.auth + "getOptions/Interests"
            case .cities:
                return Endpoints.base + Endpoints.auth + "getOptions/Cities"
            case .incomeLevels:
                return Endpoints.base + Endpoints.auth + "getOptions/Incomelevels"
            case .register:
                return Endpoints.base + Endpoints.auth + "register"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    //MARK: LOGIN USER REQUEST
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
    
    //MARK: OTP vc calls
    func sendOtp(otp: String, completion: @escaping (String, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.otp.url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(Auth.token)", forHTTPHeaderField: "Authorization")
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
//                result.save()
                completion(result.new, nil)
            } catch {
                completion("", error)
            }
        }
        task.resume()
    }
    
    func resendOtp(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.resendOtp.url)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(Auth.token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
//        let body = OtpRequest(otp: otp)
//        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(false, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(ResendOtpResponse.self, from: data)
                completion(true, nil)
            } catch {
                completion(false, error)
            }
        }
        task.resume()
    }
    

    //MARK: post fcm-token Push notification
    func postFcm(fcmtoken: String, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.fcmPostToken.url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(Auth.token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = FcmTokenRequest(fcm: fcmtoken) //TODO:- set encoded struct
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(false, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(fcmTokenResponse.self, from: data)
                completion(true, error)
            } catch {
                completion(false, error)
            }
        }
        task.resume()
    }
    
    
    //MARK: REGISTER USER REQUESTS
    //TODO: revision this method
    func userInterests(completion: @escaping ([InterestsPhoto], Error?) -> Void) {
        var request = URLRequest(url: Endpoints.userInterest.url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(Auth.token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion([], error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(InterestsDataResponse.self, from: data)
                completion(result.data, nil)
            } catch {
                completion([], error)
            }
        }
        task.resume()
    }
    
    
    
    func cities(completion: @escaping ([DropListData], Error?) -> Void) {
        var request = URLRequest(url: Endpoints.cities.url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(Auth.token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion([], error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(DropListDataResponse.self, from: data)
                completion(result.data, nil)
            } catch {
                completion([], error)
            }
        }
        task.resume()
    }
    
    func IncomeLevels(completion: @escaping ([DropListData], Error?) -> Void) {
        var request = URLRequest(url: Endpoints.incomeLevels.url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(Auth.token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion([], error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(DropListDataResponse.self, from: data)
                completion(result.data, nil)
            } catch {
                completion([], error)
            }
        }
        task.resume()
    }
    
    func registerUser(userName: String, birthDate: String, gender: String, city: String, incomeLevel: String, completion: @escaping (String, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.register.url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(Auth.token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let body = RegisterUserRequest(username: userName, birthdate: birthDate, city: city, incomelevel: incomeLevel, gender: gender)
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print("response is: \(response)")
            guard let data = data else {
                completion("", error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(RegisterUserResponse.self, from: data)
                completion(result.state, nil)
            } catch {
                completion("", error)
            }
        }
        task.resume()
    }
}
