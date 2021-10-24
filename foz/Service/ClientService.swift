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
        case inactiveAuction
        case soldAuction
        case contactUs
        case termsAndConditions
        case ActiveAuctionVideoAd(String)
        case completWatching(String)
        case offersProvidersList(String)
//        case offersResturantProvidersList(String)
        
        var stringValue: String {
            switch self {
            case .auctions:
                return AuthService.Endpoints.base + "api/auction"
            case .activeAuction(let auctionID):
                return AuthService.Endpoints.base + "api/auction/active?auction_id=" + auctionID
            case .inactiveAuction:
                return AuthService.Endpoints.base + "api/auction/view/inactive"
            case .soldAuction:
                return AuthService.Endpoints.base + "api/auction/view/sold"
            case .contactUs:
                return AuthService.Endpoints.base + "api/sidemenu/contacts"
            case .termsAndConditions:
                return AuthService.Endpoints.base + "api/sidemenu/page/TERMS_CONDITIONS"
            case .ActiveAuctionVideoAd(let auctionID):
                return AuthService.Endpoints.base + "api/ad/auctions?auction_id=" + auctionID
            case .completWatching(let adID):
                return AuthService.Endpoints.base + "api/ad/watch?ad_id=" + adID
            case .offersProvidersList(let query):
                return AuthService.Endpoints.base + "api/offer/providers?name=\(query)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//            case .offersResturantProvidersList(let query):
//                return AuthService.Endpoints.base + "api/offer/providers?name=".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! + query
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
        request.addValue("Bearer \(AuthService.Auth.token)", forHTTPHeaderField: "Authorization")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
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
        request.addValue("Bearer \(AuthService.Auth.token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
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
    
    //MARK: terms and conditions VC
    func getTermsAndConditions(completion: @escaping (String, Error?) -> ()) {
        taskForGetRequest(url: Endpoint.termsAndConditions.url, response: TermsAndConditionResponse.self) { result, error in
            if let error = error {
                completion("", error)
            }
            else {
                completion(result!.data.description, nil)
            }
        }
    }
    
    
    //MARK: auctions screen calls
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
            if let response = result {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    
    //this function to bring the ad video url inside active auction vc
    func getActiveAuctionVideoAdData(auctionId: String, completion: @escaping (ActiveAuctionVideoAdsResponse?, Error?) -> Void) {
        let task = taskForGetRequest(url: Endpoint.ActiveAuctionVideoAd(auctionId).url, response: ActiveAuctionVideoAdsResponse.self) { result, error in
            if let response = result {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func completeWatchingVideoAd(adId: String, completion: @escaping (completeWatchingResponse?, Error?) -> Void) {
        var request = URLRequest(url: Endpoint.completWatching(adId).url)
        request.setValue("Bearer \(AuthService.Auth.token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(completeWatchingResponse.self, from: data)
                
                completion(result, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    
    }
    
    //MARK: inactive auction screen
    
    func getInactiveAuctionsData(completion: @escaping (InactiveAuctionsResponse?, Error?) -> Void) {
        let task = taskForGetRequest(url: Endpoint.inactiveAuction.url, response: InactiveAuctionsResponse.self) { result, error in
            if let error = error {
                completion(nil, error)
            }
            else {
                completion(result, nil)
            }
        }
    }
    
    //MARK: sold auction screen
    
    func getSoldAuctionsData(completion: @escaping (SoldAuctionResponse?, Error?) -> Void) {
        let task = taskForGetRequest(url: Endpoint.soldAuction.url, response: SoldAuctionResponse.self) { result, error in
            if let error = error {
                completion(nil, error)
            }
            else {
                completion(result, nil)
            }
        }
    }
    
    //MARK: contact us VC calls
    func sendMessage(message: String, completion: @escaping (String, Error?) -> ()) {
        taskForPostRequest(url: Endpoint.contactUs.url, body: ContactUsRequest(message: message), responseType: SendMessageResponse.self) { result, error in
            if let error = error {
                print("error of send message: \(error)")
                completion("False", error)
            }
            else {
                print("result of send message: \(result)")
                completion(result!.state, nil)
            }
        }
    }
    
    func getAllMessage( completion: @escaping ([ContactusMessageArray], Error?) -> ()) {
        taskForGetRequest(url: Endpoint.contactUs.url, response: ContactUsResponse.self) { result, error in
            if let error = error {
                completion([], error)
            }
            else {
               
                completion(result!.result, nil)
            }
        }
    }
    
    //MARK: offer category vc calls
    func getProvidersList(query: String, completion: @escaping (OffersProvidersResponse?, Error?) -> ()) {
        taskForGetRequest(url: Endpoint.offersProvidersList(query).url, response: OffersProvidersResponse.self) { result, error in
            if let error = error {
                completion(nil, error)
            }
            else {
                completion(result, nil)
            }
        }
    }
    
//    func getResturantProvidersList(completion: @escaping (OffersProvidersResponse?, Error?) -> ()) {
//        taskForGetRequest(url: Endpoint.offersResturantProvidersList.url, response: OffersProvidersResponse.self) { result, error in
//            if let error = error {
//                completion(nil, error)
//            }
//            else {
//                completion(result, nil)
//            }
//        }
//    }
}
