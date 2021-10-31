//
//  MarketListViewModel.swift
//  foz
//
//  Created by Ahmed Medhat on 31/10/2021.
//

import Foundation

class MarketListViewModel {
    
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
        ClientService.shared.getAllMarketCoupon { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                self.state = .error
                self.alertMesssage = error.localizedDescription
            } else {
                
                self.proccessFetchedMarketCouponData(data: result!.data)
                self.state = .populated
            }
        }
    }
    
    func getCellViewModel(at indesxPath: IndexPath) -> MarketListCellViewModel {
        return marketListCellViewModel[indesxPath.row]
    }
    
    func createCellViewModel(data: MarketCouponsData) -> MarketListCellViewModel {
        let discountText = data.discount + "%"
        let realPrice = data.offer_price +  " ريال "
        let priceBeforDiscount = data.price_before_discount +  " ريال "
        return MarketListCellViewModel(providerImage: data.provider_image, priceBeforDiscout: priceBeforDiscount, discount: discountText, price: realPrice)
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
