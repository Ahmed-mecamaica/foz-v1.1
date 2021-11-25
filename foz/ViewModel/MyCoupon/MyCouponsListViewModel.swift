//
//  MyCouponsListViewModel.swift
//  foz
//
//  Created by Ahmed Medhat on 23/11/2021.
//

import Foundation


class MyCouponsListViewModel {
    
    let group = DispatchGroup()
        
    var allCouponsData: [AllCouponData] = [AllCouponData]()
    var marketCouponsData: [AllCouponData] = [AllCouponData]()
    
    private var allCouponListCellViewModel: [AllCouponsListCellViewModel] = [AllCouponsListCellViewModel]() {
        didSet {
            self.reloadCollectionViewClousure?()
        }
    }
    
    private var marketCouponListCellViewModel: [MarketCouponsListCellViewModel] = [MarketCouponsListCellViewModel]() {
        didSet {
            self.reloadCollectionViewClousure?()
        }
    }
    
    var allCouponNumberOfCell: Int {
        return allCouponListCellViewModel.count
    }
    var marketCouponNumberOfCell: Int {
        return marketCouponListCellViewModel.count
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
    
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var reloadCollectionViewClousure: (()->())?
    
    var isAllowSegue: Bool = false
    var selectedCouponInsideAll: AllCouponData?
    var selectedCouponInsideMarket: AllCouponData?

    
    func initFetchAllCouponsData() {
        state = .loading
//        group.enter()
        ClientService.shared.fetchAllCoupon { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                self.state = .error
                self.alertMesssage = error.localizedDescription
//                self.group.leave()
            } else {
                self.proccessFetchedAllCouponsData(data: result!.data )
                self.state = .populated
//                self.group.leave()
            }
        }
    }
    
    func initFetchMarketCouponsData() {
        state2 = .loading
        ClientService.shared.fetchMarketCoupon { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                self.state2 = .error
                self.alertMesssage = error.localizedDescription
            } else {
                self.proccessFetchedMarketCouponsData(data: result!.data )
                self.state2 = .populated
            }
        }
    }
    
    
    func getAllCellViewModel(at indesxPath: IndexPath) -> AllCouponsListCellViewModel {
        return allCouponListCellViewModel[indesxPath.row]
    }
    
    func getmarketCellViewModel(at indesxPath: IndexPath) -> MarketCouponsListCellViewModel {
        return marketCouponListCellViewModel[indesxPath.row]
    }
    
    func createAllCellViewModel(data: AllCouponData) -> AllCouponsListCellViewModel {
        let expiredDate = "expired: " + data.expire_date!
        let couponSerial = "code: " + data.serial_number!

        return AllCouponsListCellViewModel(id: data.id ?? 0, userId: data.user_id ?? 0, providerLogo: data.provider?.image_url ?? "", priceAfterDiscount: data.price_after_discount , expiredDate: expiredDate, serialNum: couponSerial, type: data.type ?? "", in_market: data.in_market)
    }
    
    func createMarketCellViewModel(data: AllCouponData) -> MarketCouponsListCellViewModel {
        let expiredDate = "expired: " + data.expire_date!
        let couponSerial = "code: " + data.serial_number!
        let discount = "\(data.discount!)" + "%"
        return MarketCouponsListCellViewModel(id: data.id ?? 0, userId: data.user_id ?? 0, providerLogo: data.provider?.image_url ?? "", price: data.price ?? "", discount: discount, priceAfterDiscount: data.price_after_discount, expiredDate: expiredDate, serialNum: couponSerial)
    }
    
    private func proccessFetchedAllCouponsData(data: [AllCouponData]) {
        self.allCouponsData = data
        var vms = [AllCouponsListCellViewModel]()
        for coupon in data {
            vms.append(createAllCellViewModel(data: coupon))
        }
        self.allCouponListCellViewModel = vms
    }
    
    private func proccessFetchedMarketCouponsData(data: [AllCouponData]) {
        self.marketCouponsData = data
        var vms = [MarketCouponsListCellViewModel]()
        for coupon in data {
            vms.append(createMarketCellViewModel(data: coupon))
        }
        self.marketCouponListCellViewModel = vms
    }
}

extension MyCouponsListViewModel {
    func userPressedInsideAllCoupon(at indexPath: IndexPath) {
        let coupon = self.allCouponsData[indexPath.row]
        if coupon.id != 0 {
            self.selectedCouponInsideAll = coupon
            self.isAllowSegue = true
        }
        else {
            self.isAllowSegue = false
            self.selectedCouponInsideAll = nil
            self.alertMesssage = "This item is not for sale"
        }
        
    }
    
    func userPressedInsideMarketCoupon(at indexPath: IndexPath) {
        let coupon = self.marketCouponsData[indexPath.row]
        if coupon.id != 0 {
            self.selectedCouponInsideMarket = coupon
            self.isAllowSegue = true
        }
        else {
            self.isAllowSegue = false
            self.selectedCouponInsideMarket = nil
            self.alertMesssage = "This item is not for sale"
        }
        
    }
}
