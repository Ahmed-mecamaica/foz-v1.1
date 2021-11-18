//
//  adsInsideCategoryViewModel.swift
//  foz
//
//  Created by Ahmed Medhat on 17/11/2021.
//

import Foundation

class AdsInsideCategoryViewModel {
    
    var adsPhotoData: DefaultAdsData?
    
    var adsInsideCategoryData: [AdsInsideCategoryData] = [AdsInsideCategoryData]()
    
    private var adsInsideCategoryCellViewModel: [AdsInsideCategoryCellViewModel] = [AdsInsideCategoryCellViewModel]() {
        didSet {
            self.reloadCollectionViewClousure?()
        }
    }
    
    var adsNumberOfCell: Int {
        return adsInsideCategoryCellViewModel.count
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
    var selectedProvider: AdsInsideCategoryData?

    
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
    
    func getCellViewModel(at indesxPath: IndexPath) -> AdsInsideCategoryCellViewModel {
        return adsInsideCategoryCellViewModel[indesxPath.row]
    }
    
    func createCellViewModel(data: AdsInsideCategoryData) -> AdsInsideCategoryCellViewModel {
        return AdsInsideCategoryCellViewModel(adId: data.id, adthumbnail: data.image_url)
    }
    
    private func proccessFetchedAdsInsideCategoryData(data: [AdsInsideCategoryData]) {
        self.adsInsideCategoryData = data
        var vms = [AdsInsideCategoryCellViewModel]()
        for provider in data {
            vms.append(createCellViewModel(data: provider))
        }
        self.adsInsideCategoryCellViewModel = vms
    }
}

extension AdsInsideCategoryViewModel {
    func userPressed(at indexPath: IndexPath) {
        let category = self.adsInsideCategoryData[indexPath.row]
        if category.id != 0 {
            self.selectedProvider = category
            self.isAllowSegue = true
        }
        else {
            self.isAllowSegue = false
            self.selectedProvider = nil
            self.alertMesssage = "no ad here right now"
        }
        
    }
}
