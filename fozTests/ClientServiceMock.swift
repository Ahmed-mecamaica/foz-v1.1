//
//  ClientServiceMock.swift
//  fozTests
//
//  Created by Ahmed Medhat on 15/11/2021.
//

import XCTest
@testable import foz
class ClientServiceMock: APIServiceProtocol {
    
    
    
    var fetchInactiveAuctionIsCalled = false
    var taskForGetRequest = false
    
    
    var inactiveAuctions: InactiveAuctionsResponse?
    var completionClosure:((InactiveAuctionsResponse?, APIError?) -> ())!
    
    func getInactiveAuctionsData(completion: @escaping (InactiveAuctionsResponse?, APIError?) -> ()) {
        fetchInactiveAuctionIsCalled = true
        
        completionClosure = completion
    }
    
    func fetchSuccess() {
        completionClosure(inactiveAuctions, nil)
    }
    
    func fetchFail(error: APIError?) {
        completionClosure(nil, error)
    }
    

   
    
}
