//
//  AdDetailsViewModel.swift
//  foz
//
//  Created by Ahmed Medhat on 18/11/2021.
//

import Foundation

class AdDetailsViewModel {
    var adsPhotoData: DefaultAdsData?
    var adDetails: AdDetailsData?
    
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
    
    func initFetchAdDataData(adId: String) {
        state = .loading
        ClientService.shared.fetchAdDetails(adId: adId) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                self.state = .error
                self.alertMesssage = error.localizedDescription
            } else {
                self.state = .populated
                self.adDetails = result?.data
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
    
    
}
