//
//  InactiveAuctionsListViewModel.swift
//  foz
//
//  Created by Ahmed Medhat on 28/09/2021.
//

import Foundation

class InactiveAuctionsListViewModel {
    
    var apiService: APIServiceProtocol!
    
    var InactiveAuctionData: [AuctionData] = [AuctionData]()
    
    private var inActiveAuctionCellViewModel: [InactiveAuctionsCellViewModel] = [InactiveAuctionsCellViewModel]() {
        didSet {
            self.reloadCollectionViewClousure?()
        }
    }
    
    var inactiveAuctionNumberOfCell: Int {
        return inActiveAuctionCellViewModel.count
    }
    
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMesssage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var reloadCollectionViewClousure: (()->())?
    
    var selectedInactiveAuction: AuctionData?

    init(apiService: APIServiceProtocol = ClientService()) {
        self.apiService = apiService
    }
    
    func initData() {
        state = .loading
        apiService.getInactiveAuctionsData { [weak self] result, error in
            guard let self = self else { return }
            guard  error == nil else {
                self.state = .error
                self.alertMesssage = error?.rawValue
                return
            }
//            else {
                self.state = .populated
                self.proccessFetchedInactivAuctionData(data: (result?.data)!)
//            }
        }
    }
    
    func getCellViewModel(at indesxPath: IndexPath) -> InactiveAuctionsCellViewModel {
        return inActiveAuctionCellViewModel[indesxPath.row]
    }
    
    func createCellViewModel(data: AuctionData) -> InactiveAuctionsCellViewModel {
        return InactiveAuctionsCellViewModel(productNum: data.serial_number, productImage: data.image_url, productName: data.title, ProductTotalAmount: data.start_price, auctionStartTime: data.time)
    }
    
    private func proccessFetchedInactivAuctionData(data: [AuctionData]) {
        self.InactiveAuctionData = data
        var vms = [InactiveAuctionsCellViewModel]()
        for auction in data {
            vms.append(createCellViewModel(data: auction))
        }
        self.inActiveAuctionCellViewModel = vms
    }
}
