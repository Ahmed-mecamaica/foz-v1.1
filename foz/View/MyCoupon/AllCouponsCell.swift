//
//  AllCouponsCell.swift
//  foz
//
//  Created by Ahmed Medhat on 23/11/2021.
//

import UIKit
import SDWebImage

class AllCouponsCell: UITableViewCell {

    @IBOutlet weak var providerMainLogoImage: UIImageView!
    @IBOutlet weak var couponPriceAfterDIscountLbl: UILabel!
    @IBOutlet weak var couponExpiredDate: UILabel!
    @IBOutlet weak var couponSerialNumLbl: UILabel!
    @IBOutlet weak var providerLogoInsideCouponImage: UIImageView!
    @IBOutlet weak var showInMarketBtn: UIButton!
    @IBOutlet weak var giftBtn: UIButton!
    @IBOutlet weak var useCouponBtn: UIButton!
    @IBOutlet weak var couponTypeHolderView: BottomRadiusView!
    @IBOutlet weak var couponTypeLbl: UILabel!
    
    var allCouponsListCellViewModel: AllCouponsListCellViewModel? {
        didSet {
            providerMainLogoImage.sd_setImage(with: URL(string:  allCouponsListCellViewModel!.providerLogo))
            providerLogoInsideCouponImage.sd_setImage(with: URL(string:  allCouponsListCellViewModel!.providerLogo))
            couponPriceAfterDIscountLbl.text = "\(allCouponsListCellViewModel!.priceAfterDiscount)"
            couponExpiredDate.text = allCouponsListCellViewModel?.expiredDate
            couponSerialNumLbl.text = allCouponsListCellViewModel?.serialNum
            couponTypeLbl.text = allCouponsListCellViewModel?.type
            initCouponTypeHolderView()
            if allCouponsListCellViewModel?.type == "auction" && allCouponsListCellViewModel?.in_market == 0 {
                showInMarketBtn.setTitle("عرض في السوق", for: .normal)
                showInMarketBtn.isHidden = false
            } else if allCouponsListCellViewModel?.type == "gift" {
                showInMarketBtn.setTitle("تحديد المتجر", for: .normal)
                showInMarketBtn.layoutIfNeeded()
                showInMarketBtn.isHidden = false
            }
            else {
                showInMarketBtn.isHidden = true
            }
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

    
    //this func to initialize coupon type holder view
    func initCouponTypeHolderView() {
        couponTypeHolderView.layer.borderColor = #colorLiteral(red: 0.007843137255, green: 0.5607843137, blue: 0.5607843137, alpha: 1)
        couponTypeHolderView.layer.cornerRadius = 15
        couponTypeHolderView.layer.borderWidth = 1
    }
}
