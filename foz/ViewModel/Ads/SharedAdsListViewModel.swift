//
//  SharedAdsListViewModel.swift
//  foz
//
//  Created by Ahmed Medhat on 21/11/2021.
//

import Foundation


class SharedAdsListViewModel {
    
    var adsPhotoData: DefaultAdsData?
    
    var sharedAdsData: [AdsInsideCategoryData] = [AdsInsideCategoryData]()
    
    private var sharedAdsCellViewModel: [SharedAdsListCellViewModel] = [SharedAdsListCellViewModel]() {
        didSet {
            self.reloadCollectionViewClousure?()
        }
    }
    
    var adsNumberOfCell: Int {
        return sharedAdsCellViewModel.count
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
    
    var isAllowSegue: Bool = false
    var selectedAd: AdsInsideCategoryData?

    
    func initFetchAdsInsideCategoryData(categoryName: String, categoryId: String) {
        state = .loading
        ClientService.shared.fetchAdsInsideCategory(categoryName: categoryName, categoryId: categoryId) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                self.state = .error
                self.alertMesssage = error.localizedDescription
            } else {
                self.state = .populated
                self.proccessFetchedAdsInsideCategoryData(data: result!.data)
            }
        }
    }
    
    func initAdsPhoto() {
        state = .loading
        ClientService.shared.getAdsPhoto { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                self.state = .error
                self.alertMesssage = error.localizedDescription
            } else {
                self.state = .populated
                self.adsPhotoData = result?.data
            }
        }
    }
    
    func getCellViewModel(at indesxPath: IndexPath) -> SharedAdsListCellViewModel {
        return sharedAdsCellViewModel[indesxPath.row]
    }
    
    func createCellViewModel(data: AdsInsideCategoryData) -> SharedAdsListCellViewModel {
        return SharedAdsListCellViewModel(id: data.id, adName: data.title, adDesc: data.description, adLogo: data.ad_logo)
    }
    
    private func proccessFetchedAdsInsideCategoryData(data: [AdsInsideCategoryData]) {
        self.sharedAdsData = data
        var vms = [SharedAdsListCellViewModel]()
        for provider in data {
            vms.append(createCellViewModel(data: provider))
        }
        self.sharedAdsCellViewModel = vms
    }
}

extension SharedAdsListViewModel {
    func userPressed(at indexPath: IndexPath) {
        let category = self.sharedAdsData[indexPath.row]
        if category.id != 0 {
            self.selectedAd = category
            self.isAllowSegue = true
        }
        else {
            self.isAllowSegue = false
            self.selectedAd = nil
            self.alertMesssage = "no ad here right now"
        }
        
    }
}
