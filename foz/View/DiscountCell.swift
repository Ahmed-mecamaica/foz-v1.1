//
//  DiscountCell.swift
//  foz
//
//  Created by Ahmed Medhat on 04/10/2021.
//

import UIKit

class DiscountCell: UITableViewCell {

    @IBOutlet weak var realPriceLbl: UILabel!
    @IBOutlet weak var priceBeforDiscountLbl: UILabel!
    @IBOutlet weak var lineOnPriceBeforDiscount: UIView!
    @IBOutlet weak var couponCodeLbl: UILabel!
    @IBOutlet weak var expireDateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
