//
//  MarketCouponsCell.swift
//  foz
//
//  Created by Ahmed Medhat on 23/11/2021.
//

import UIKit

class MarketCouponsCell: UITableViewCell {
    @IBOutlet weak var providerMainLogoImage: UIImageView!
    @IBOutlet weak var couponPriceLbl: UILabel!
    @IBOutlet weak var discountPercenageLbl: UILabel!
    @IBOutlet weak var couponPriceAfterDIscountLbl: UILabel!
    @IBOutlet weak var couponExpiredDate: UILabel!
    @IBOutlet weak var couponSerialNumLbl: UILabel!
    @IBOutlet weak var cancelOfferBtn: UIButton!
    @IBOutlet weak var priceEditeBtn: UIButton!
    @IBOutlet weak var directSaleBtn: UIButton!
    
    var marketCouponsListCellViewModel: MarketCouponsListCellViewModel? {
        didSet {
            providerMainLogoImage.sd_setImage(with: URL(string:  marketCouponsListCellViewModel!.providerLogo))
            couponPriceLbl.text = marketCouponsListCellViewModel!.price
            discountPercenageLbl.text = "\(marketCouponsListCellViewModel!.discount)"
            couponPriceAfterDIscountLbl.text = "\(marketCouponsListCellViewModel!.priceAfterDiscount)"
            couponExpiredDate.text = marketCouponsListCellViewModel?.expiredDate
            couponSerialNumLbl.text = marketCouponsListCellViewModel?.serialNum
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
