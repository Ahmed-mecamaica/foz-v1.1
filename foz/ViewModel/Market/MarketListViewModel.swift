//
//  MarketListViewModel.swift
//  foz
//
//  Created by Ahmed Medhat on 31/10/2021.
//

import Foundation

class MarketListViewModel {
    
    let group = DispatchGroup()
    
    var adsPhotoData: DefaultAdsData?
    
    var marketCouponsData: [MarketCouponsData] = [MarketCouponsData]()
    
    private var marketListCellViewModel: [MarketListCellViewModel] = [MarketListCellViewModel]() {
        didSet {
            self.reloadCollectionViewClousure?()
        }
    }
    
    var marketNumberOfCell: Int {
        return marketListCellViewModel.count
    }
    
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
//    var state2: State = .empty {
//        didSet {
//            self.updateLoadingStatus?()
//        }
//    }
    
    var alertMesssage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var reloadCollectionViewClousure: (()->())?
    
    var isAllowSegue: Bool = false
    var selectedMarket: MarketCouponsData?

    
    func initFetchMarketData() {
        state = .loading
        group.enter()
        ClientService.shared.getAllMarketCoupon { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                self.state = .error
                self.alertMesssage = error.localizedDescription
                self.group.leave()
            } else {
                self.proccessFetchedMarketCouponData(data: result!.data)
                self.state = .populated
                self.group.leave()
            }
        }
    }
    
    func initAdsPhoto() {
        state = .loading
        
        group.notify(queue: .main) {
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
    
    func getCellViewModel(at indesxPath: IndexPath) -> MarketListCellViewModel {
        return marketListCellViewModel[indesxPath.row]
    }
    
    func createCellViewModel(data: MarketCouponsData) -> MarketListCellViewModel {
        let discountText = data.discount + "%"
        
        return MarketListCellViewModel(providerImage: data.provider_image, priceBeforDiscout: data.price_before_discount, discount: discountText, price: data.offer_price)
    }
    
    private func proccessFetchedMarketCouponData(data: [MarketCouponsData]) {
        self.marketCouponsData = data
        var vms = [MarketListCellViewModel]()
        for coupon in data {
            vms.append(createCellViewModel(data: coupon))
        }
        self.marketListCellViewModel = vms
    }
}

extension MarketListViewModel {
    func userPressed(at indexPath: IndexPath) {
        let provider = self.marketCouponsData[indexPath.row]
        if provider.provider_image != "" {
            self.selectedMarket = provider
            self.isAllowSegue = true
        }
        else {
            self.isAllowSegue = false
            self.selectedMarket = nil
            self.alertMesssage = "This item is not for sale"
        }
        
    }
}
