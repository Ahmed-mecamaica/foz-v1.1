//
//  CouponDetailsViewModel.swift
//  foz
//
//  Created by Ahmed Medhat on 01/11/2021.
//

import Foundation

class CouponDetailsViewModel {
    
    let group = DispatchGroup()
    var couponDetailsData: CouponDetailsData?
    var adsPhotoData: DefaultAdsData?
    
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
    
    var isAllowSegue: Bool = false
    
    func initFetchCouponDetailsData(providerId: String) {
        state = .loading
//        group.enter()
        ClientService.shared.getCouponDetails(providerId: providerId) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                self.state = .error
                self.alertMesssage = error.localizedDescription
//                self.group.leave()
            } else {
                
                self.couponDetailsData = result?.data
                self.state = .populated
//                self.group.leave()
            }
        }
    }
    
    func incrementViewNum() {
        
    }
    
    func initAdsPhoto() {
        state = .loading
//        group.notify(queue: .main) {
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
//        }
        
    }
    
    
}
