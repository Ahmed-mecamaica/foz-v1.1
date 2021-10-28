//
//  ProviderCouponsViewModel.swift
//  foz
//
//  Created by Ahmed Medhat on 25/10/2021.
//

import Foundation

class ProviderCouponsViewModel {
    
    var providerVideoAdData: ProviderAdData?
    var providerCouponsData: [ProviderCouponsData] = [ProviderCouponsData]()
    
    private var providerCouponsCellViewModel: [ProviderCouponsCellViewModel] = [ProviderCouponsCellViewModel]() {
        didSet {
            self.reloadCollectionViewClousure?()
        }
    }
    
    var providerCouponsNumberOfCell: Int {
        return providerCouponsCellViewModel.count
    }
    
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var state2: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMesssage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var alertMesssage2: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var reloadCollectionViewClousure: (()->())?
    
    var isAllowSegue: Bool = false
    var selectedCoupon: ProviderCouponsData?

    
    func initProviderData(providerId: String) {
        state = .loading
        ClientService.shared.getProviderCoupons(providerId: providerId) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                self.state = .error
                self.alertMesssage = error.localizedDescription
            } else {
                self.state = .populated
                self.proccessFetchedProviderCouponsData(data: (result?.data)!)
            }
        }
    }
    
    func initProviderVideoAdData(providerId: String) {
        state2 = .loading
        ClientService.shared.getProviderVideoAd(providerId: providerId) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                self.state2 = .error
                print("error \(error)")
                self.alertMesssage2 = error.localizedDescription
            } else {
                self.providerVideoAdData = result?.data
                self.state2 = .populated
            }
        }
    }
    
    
    func getCellViewModel(at indesxPath: IndexPath) -> ProviderCouponsCellViewModel {
        return providerCouponsCellViewModel[indesxPath.row]
    }
    
    func createCellViewModel(data: ProviderCouponsData) -> ProviderCouponsCellViewModel {
        return ProviderCouponsCellViewModel(couponCode: data.code, realPrice: data.price_after_discount, priceBeforDiscount: data.price, expiredDate: data.expire_date)
    }
    
    private func proccessFetchedProviderCouponsData(data: [ProviderCouponsData]) {
        self.providerCouponsData = data
        var vms = [ProviderCouponsCellViewModel]()
        for coupon in data {
            vms.append(createCellViewModel(data: coupon))
        }
        self.providerCouponsCellViewModel = vms
    }
}


extension ProviderCouponsViewModel {
    func userPressed(at indexPath: IndexPath) {
        let coupon = self.providerCouponsData[indexPath.row]
        if coupon.price != "" {
            isAllowSegue = true
            selectedCoupon = coupon
        }
        else {
            isAllowSegue = false
        }
    }
}
