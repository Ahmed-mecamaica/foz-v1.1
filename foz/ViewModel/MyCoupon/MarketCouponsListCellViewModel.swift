//
//  MarketCouponsListCellViewModel.swift
//  foz
//
//  Created by Ahmed Medhat on 23/11/2021.
//

import Foundation

struct MarketCouponsListCellViewModel {
    let id: Int
    let userId: Int
    let providerLogo: String
    let price: String
    let discount: String
    let priceAfterDiscount: Int
    let expiredDate: String
    let serialNum: String
}
