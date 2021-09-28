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
        
        case auctions
        case activeAuction(String)
        
        var stringValue: String {
            switch self {
            case .auctions:
                return AuthService.Endpoints.base + "api/auctions"
            case .activeAuction(let auctionID):
                return AuthService.Endpoints.base + "api/auctions/active?auction_id=" + auctionID
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
    func getAllAuctionsData(completion: @escaping (AuctionsResponse?, Error?) -> ()) {
        let task = taskForGetRequest(url: Endpoint.auctions.url, response: AuctionsResponse.self) { response, error in
            
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    //MARK: active Auction screen

    func getActiveAuctionData(auctionId: String, completion: @escaping (ActiveAuctionResponse?, Error?) -> Void) {
        let task = taskForGetRequest(url: Endpoint.activeAuction(auctionId).url, response: ActiveAuctionResponse.self) { result, error in
//            print("active api: \(Endpoint.activeAuction(auctionId).url)")
            if let response = result {
//                print("active response: \(response)")
                completion(response, nil)
            } else {
//                print("active error: \(error?.localizedDescription)")
                completion(nil, error)
            }
        }
    }
}
