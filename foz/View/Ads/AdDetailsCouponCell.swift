//
//  AdDetailsCouponCell.swift
//  foz
//
//  Created by Ahmed Medhat on 21/11/2021.
//

import UIKit

class AdDetailsCouponCell: UITableViewCell {
    @IBOutlet weak var couponPriceLbl: UILabel!
    @IBOutlet weak var priceBeforDiscountLbl: UILabel!
    @IBOutlet weak var couponIdLbl: UILabel!
    @IBOutlet weak var couponExpiredDateLbl: UILabel!
    
    var adDetailsCouponCellViewModel: AdDetailsCouponCellViewModel? {
        didSet {
            couponPriceLbl.text = "\(adDetailsCouponCellViewModel!.couponPrice)"
            priceBeforDiscountLbl.text = "\(adDetailsCouponCellViewModel!.priceAfterDiscount)"
            couponIdLbl.text = adDetailsCouponCellViewModel!.couponCode
            couponExpiredDateLbl.text = adDetailsCouponCellViewModel?.expiredDate
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
