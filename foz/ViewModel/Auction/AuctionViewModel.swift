//
//  AuctionViewModel.swift
//  foz
//
//  Created by Ahmed Medhat on 22/09/2021.
//

import Foundation

class AuctionViewModel {
    
    
    var activeAuctionData: AuctionsAllData?
    var activeAuctionViedoData: ActiveAuctionVideoAdsResponse?
    var InactiveAuctionData: [AuctionData] = [AuctionData]()
    var soldAuctionData: [AuctionData] = [AuctionData]()
    
    //cotainer of all cell
    private var inActiveAuctionCellViewModel: [InactiveAuctionListCellinAuctions] = [InactiveAuctionListCellinAuctions]() {
        didSet {
            self.reloadCollectionViewClousure?()
        }
    }
    
    private var soldAuctionCellViewModel: [SoldAuctionListCellinAuctions] = [SoldAuctionListCellinAuctions]() {
        didSet {
            self.reloadCollectionViewClousure?()
        }
    }
    
    var inactiveAuctionNumberOfCell: Int {
        return inActiveAuctionCellViewModel.count
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
    
    var selectedInactiveAuction: AuctionData?
    var selectedSoldAuction: AuctionData?
    
    func initData() {
        state = .loading
        ClientService.shared.getAllAuctionsData { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                self.state = .error
                self.alertMesssage = error.localizedDescription
            } else {
                self.state = .populated
                self.activeAuctionData = result?.data
                self.proccessFetchedInactivAuctionData(data: (result?.data.inactive)!)
                self.proccessFetchedSoldAuctionData(data: (result?.data.sold)!)
            }
        }
    }
    
    func initFetchActiveAuctionVideoAdUrl(auctionId: String) {
        state = .loading
        ClientService.shared.getActiveAuctionVideoAdData(auctionId: auctionId) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                self.state = .error
                self.alertMesssage = error.localizedDescription
            } else {
                self.state = .populated
                self.activeAuctionViedoData = result
                
            }
        }
    }
    
    func getCellViewModel(at indesxPath: IndexPath) -> InactiveAuctionListCellinAuctions {
        return inActiveAuctionCellViewModel[indesxPath.row]
    }
    
    func getSoldCellViewModel(at indesxPath: IndexPath) -> SoldAuctionListCellinAuctions {
        return soldAuctionCellViewModel[indesxPath.row]
    }
    
    func createCellViewModel(data: AuctionData) -> InactiveAuctionListCellinAuctions {
        return InactiveAuctionListCellinAuctions(title: data.title, id: data.serial_number, image_url: data.image_url)
    }
    
    func createSoldCellViewModel(data: AuctionData) -> SoldAuctionListCellinAuctions {
        return SoldAuctionListCellinAuctions(title: data.title, id: data.serial_number, image_url: data.image_url)
    }
    
    private func proccessFetchedInactivAuctionData(data: [AuctionData]) {
        self.InactiveAuctionData = data
        var vms = [InactiveAuctionListCellinAuctions]()
        for aucrion in data {
            vms.append(createCellViewModel(data: aucrion))
        }
        self.inActiveAuctionCellViewModel = vms
    }
    
    private func proccessFetchedSoldAuctionData(data: [AuctionData]) {
        self.soldAuctionData = data
        var vms = [SoldAuctionListCellinAuctions]()
        for aucrion in data {
            vms.append(createSoldCellViewModel(data: aucrion))
        }
        self.soldAuctionCellViewModel = vms
    }
}
