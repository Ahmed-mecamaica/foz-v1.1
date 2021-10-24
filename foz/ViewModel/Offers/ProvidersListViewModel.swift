//
//  ProvidersListViewModel.swift
//  foz
//
//  Created by Ahmed Medhat on 24/10/2021.
//

import Foundation

class ProvidersListViewModel {
    var offersProvidersData: [OffersProvidersData] = [OffersProvidersData]()
    
    private var providersListCellViewModel: [ProvidersListCellViewModel] = [ProvidersListCellViewModel]() {
        didSet {
            self.reloadCollectionViewClousure?()
        }
    }
    
    var providerNumberOfCell: Int {
        return providersListCellViewModel.count
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

    
    func initProviderData(query: String) {
        state = .loading
        ClientService.shared.getProvidersList(query: query) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                self.state = .error
                self.alertMesssage = error.localizedDescription
            } else {
                self.state = .populated
                self.proccessFetchedCafeProviderData(data: (result?.data)!)
            }
        }
    }
    
    func getCellViewModel(at indesxPath: IndexPath) -> ProvidersListCellViewModel {
        return providersListCellViewModel[indesxPath.row]
    }
    
    func createCellViewModel(data: OffersProvidersData) -> ProvidersListCellViewModel {
        return ProvidersListCellViewModel(id: data.id, name: data.name, provider_image: data.image_url)
    }
    
    private func proccessFetchedCafeProviderData(data: [OffersProvidersData]) {
        self.offersProvidersData = data
        var vms = [ProvidersListCellViewModel]()
        for provider in data {
            vms.append(createCellViewModel(data: provider))
        }
        self.providersListCellViewModel = vms
    }
}
