//
//  ClientServiceMock.swift
//  fozTests
//
//  Created by Ahmed Medhat on 15/11/2021.
//

import XCTest
@testable import foz
class ClientServiceMock: APIServiceProtocol {
    func getInactiveAuctionsData(completion: @escaping (InactiveAuctionsResponse?, Error?) -> ()) {
        fetchInactiveAuctionIsCalled = true
    }
    

   var fetchInactiveAuctionIsCalled = false
    var taskForGetRequest = false
    
}
