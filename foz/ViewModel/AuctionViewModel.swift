//
//  AuctionViewModel.swift
//  foz
//
//  Created by Ahmed Medhat on 22/09/2021.
//

import Foundation

class AuctionViewModel {
    
    
    var ActiveUctionData: ActiveAuctionsData?
    var InactiveAuctionData: [AuctionData] = [AuctionData]()
    
    //cotainer of all cell
    private var inActiveAuctionCellViewModel: [InactiveAuctionListCellinAuctions] = [InactiveAuctionListCellinAuctions]() {
        didSet {
            self.reloadCollectionViewClousure?()
        }
    }
    
    var numberOfCell: Int {
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
    
    var selectedPhoto: InterestsPhoto?
    
    func initData() {
        state = .loading
        ClientService.shared.getAllAuctionsData { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                self.state = .error
                self.alertMesssage = error.localizedDescription
            } else {
                self.state = .populated
                self.ActiveUctionData = result?.data
                self.proccessFetchedInactivAuctionData(data: (result?.data.inactive)!)
            }
        }
    }
    
    func getCellViewModel(at indesxPath: IndexPath) -> InactiveAuctionListCellinAuctions {
        return inActiveAuctionCellViewModel[indesxPath.row]
    }
    
    func createCellViewModel(data: AuctionData) -> InactiveAuctionListCellinAuctions {
        return InactiveAuctionListCellinAuctions(title: data.title, id: data.serial_number, image_url: data.image_url)
    }
    
    private func proccessFetchedInactivAuctionData(data: [AuctionData]) {
        self.InactiveAuctionData = data
        var vms = [InactiveAuctionListCellinAuctions]()
        for aucrion in data {
            vms.append(createCellViewModel(data: aucrion))
        }
        self.inActiveAuctionCellViewModel = vms
    }
}
