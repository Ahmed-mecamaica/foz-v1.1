//
//  InactiveAuctionsListViewModelTest.swift
//  fozTests
//
//  Created by Ahmed Medhat on 15/11/2021.
//

import XCTest
@testable import foz
class InactiveAuctionsListViewModelTest: XCTestCase {

    
    var sut: InactiveAuctionsListViewModel!
    var clientServiceMock: ClientServiceMock!
    override func setUp() {
        super.setUp()
        //create an instance of the mock in InactiveAuctionsListViewModelTest
        
//        sut = InactiveAuctionsListViewModel()
        clientServiceMock = ClientServiceMock()
        
        //inject clientservicemock to inactive auctions
        sut = InactiveAuctionsListViewModel(apiService: clientServiceMock)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    //dose view model create cell
    func testCreatCellViewModel() {
        //given
        let auction = AuctionData(id: 1,
                                  title: "naggar",
                                  description: "naggar",
                                  start_price: "20",
                                  end_price: "20",
                                  image_url: "http://google.com",
                                  serial_number: "wfffferrewr",
                                  provider_image: "http://google.com",
                                  time: "20:14")
        //when
        let cellViewModel = sut?.createCellViewModel(data: auction)
        //then
        
        XCTAssertEqual(cellViewModel?.productName, auction.title)
    }
    
    
//test for call inside view model
    func testInitFetch() {
        sut.initData()
        XCTAssert(clientServiceMock.fetchInactiveAuctionIsCalled)
    }
    
    
    func testFetchFailer() {
        let error = APIError.noNetwork

        sut.initData()

        clientServiceMock.fetchFail(error: error)

        XCTAssertEqual(sut.alertMesssage, error.rawValue)
    }
}
