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
    
    
    func getAllAuctionsData(completion: @escaping (ActiveAuctionsResponse?, Error?) -> ()) {
        var request = URLRequest(url: Endpoint.activeAuction.url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(AuthService.Auth.token)", forHTTPHeaderField: "Api-token")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            print("response of auctions call is \(response)")
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(ActiveAuctionsResponse.self, from: data)
                completion(result, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
}
