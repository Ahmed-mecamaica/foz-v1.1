//
//  SoldAuctionsListViewModel.swift
//  foz
//
//  Created by Ahmed Medhat on 29/09/2021.
//

import Foundation

class SoldAuctionsListViewModel {
    
    var soldAuctionData: [SoldAuctionData] = [SoldAuctionData]()
    
    private var soldAuctionCellViewModel: [SoldAuctionsCellViewModel] = [SoldAuctionsCellViewModel]() {
        didSet {
            self.reloadCollectionViewClousure?()
        }
    }
    
    var soldAuctionNumberOfCell: Int {
        return soldAuctionCellViewModel.count
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
    
    var selectedSoldAuction: SoldAuctionData?

    
    func initData() {
        state = .loading
        ClientService.shared.getSoldAuctionsData { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                self.state = .error
                self.alertMesssage = error.localizedDescription
            } else {
                self.state = .populated
                self.proccessFetchedSoldAuctionData(data: (result?.data)!)
            }
        }
    }
    
    func getCellViewModel(at indesxPath: IndexPath) -> SoldAuctionsCellViewModel {
        return soldAuctionCellViewModel[indesxPath.row]
    }
    
    func createCellViewModel(data: SoldAuctionData) -> SoldAuctionsCellViewModel {
        return SoldAuctionsCellViewModel(auctionNum: data.serial_number, productImage: data.image_url, productName: data.title, bidWinnerName: data.winner_name, bidWinnerImage: data.image_url, bidTotalAmount: data.winner_amount)
    }
    
    private func proccessFetchedSoldAuctionData(data: [SoldAuctionData]) {
        self.soldAuctionData = data
        var vms = [SoldAuctionsCellViewModel]()
        for auction in data {
            vms.append(createCellViewModel(data: auction))
        }
        self.soldAuctionCellViewModel = vms
    }
}
