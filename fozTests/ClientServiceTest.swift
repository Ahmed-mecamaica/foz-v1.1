//
//  ClientServiceTest.swift
//  fozTests
//
//  Created by Ahmed Medhat on 15/11/2021.
//

import XCTest

//give the unit test access to internal types and function in foz
@testable import foz

class ClientServiceTest: XCTestCase {

    var sut: ClientService!
    override func setUp() {
        super.setUp()
        sut = ClientService()
    }
    
    override func tearDown() {
        sut = nil
    }
    
//test for api to response back with data
    func testFetchInactiveAuction() {
        let promise = XCTestExpectation(description: "fetch inactive auction")
        var responseError: Error?
        var responseInactiveAuction: InactiveAuctionsResponse?
        
        guard let bundle = Bundle.unitTest.path(forResource: "InactiveAuctionStub", ofType: "json") else {
            XCTFail("content not found")
            return
        }
        
        sut.taskForGetRequest(url: URL(fileURLWithPath: bundle), response: InactiveAuctionsResponse.self) { response, error in
            responseError = error
            responseInactiveAuction = response
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1)
        XCTAssertNil(responseError)
        XCTAssertNotNil(responseInactiveAuction)
    }
    
}
