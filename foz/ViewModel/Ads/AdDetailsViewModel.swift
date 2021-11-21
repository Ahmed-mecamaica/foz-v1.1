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
    
    
    var coupnInAdDetailsData: CouponInAdDetailsData?
    
    private var adDetailsCouponCellViewModel: [AdDetailsCouponCellViewModel] = [AdDetailsCouponCellViewModel]() {
        didSet {
            self.reloadCollectionViewClousure?()
        }
    }
    
    var adsNumberOfCell: Int {
        return 1
//        return adDetailsCouponCellViewModel.count
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
    var selectedCoupon: CouponInAdDetailsData?
    
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
                guard result?.data.coupon == nil else {
//                    self.proccessFetchedCouponInAdDetailsData(data: result!.data.coupon!)
                    self.coupnInAdDetailsData = result?.data.coupon
                    return
                }
                
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
    
    
//    func getCellViewModel(at indesxPath: IndexPath) -> AdDetailsCouponCellViewModel {
//        return adDetailsCouponCellViewModel[0]
//    }
//
//    func createCellViewModel(data: CouponInAdDetailsData) -> AdDetailsCouponCellViewModel {
//        return AdDetailsCouponCellViewModel(id: data.id, couponCode: data.code, couponPrice: data.price, priceAfterDiscount: data.price_after_discount, expiredDate: data.expire_date)
//    }
//
//    private func proccessFetchedCouponInAdDetailsData(data: CouponInAdDetailsData) {
//        self.coupnInAdDetailsData = data
//        var vms = [AdDetailsCouponCellViewModel]()
////        for provider in data {
//            vms.append(createCellViewModel(data: data))
////        }
//        self.adDetailsCouponCellViewModel = vms
//    }
}

extension AdDetailsViewModel {
    func userPressed(at indexPath: IndexPath) {
        let category = self.coupnInAdDetailsData
        if category!.id != 0 {
            self.selectedCoupon = category
            self.isAllowSegue = true
        }
        else {
            self.isAllowSegue = false
            self.selectedCoupon = nil
            self.alertMesssage = "this coupon not available"
        }
        
    }
}
