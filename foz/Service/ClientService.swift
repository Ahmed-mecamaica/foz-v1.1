//
//  ClientService.swift
//  foz
//
//  Created by Ahmed Medhat on 22/09/2021.
//

import Foundation

class ClientService {
    
    static let shared = ClientService()
    
    private init() {}
    
    enum Endpoint {
        
        case activeAuction
        
        var stringValue: String {
            switch self {
            case .activeAuction:
                return AuthService.Endpoints.base + "api/auctions"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    
    //MARK: generic function for get call request
    func taskForGetRequest<ResponseType: Codable> (url: URL, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(AuthService.Auth.token)", forHTTPHeaderField: "Api-token")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(ResponseType.self, from: data)
                completion(result, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
        return task
    }
    
    //MARK: generic func for post call request
    func taskForPostRequest<RequestType: Codable, ResponseType: Codable>(url: URL, body: RequestType, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(AuthService.Auth.token)", forHTTPHeaderField: "Api-token")
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(ResponseType.self, from: data)
                completion(result, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
        return task
    }
    
    
    //MARK:- auctions screen calls
    func getAllAuctionsData(completion: @escaping (ActiveAuctionsResponse?, Error?) -> ()) {
        let task = taskForGetRequest(url: Endpoint.activeAuction.url, response: ActiveAuctionsResponse.self) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
