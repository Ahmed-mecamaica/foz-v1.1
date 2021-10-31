//
//  MarketCell.swift
//  foz
//
//  Created by Ahmed Medhat on 31/10/2021.
//

import UIKit
import SDWebImage

class MarketCell: UICollectionViewCell {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var providerImage: UIImageView!
    @IBOutlet weak var lineOverLastPrice: CurveShadowView!
    @IBOutlet weak var priceBeforDiscoutLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var footerView: UIView!
    
    var marketListCellViewModel: MarketListCellViewModel? {
        didSet {
            providerImage.sd_setImage(with: URL(string: marketListCellViewModel!.providerImage))
            discountLbl.text = marketListCellViewModel!.discount
            priceBeforDiscoutLbl.text = marketListCellViewModel!.priceBeforDiscout
            priceLbl.text = marketListCellViewModel?.price
        }
    }
}
