//
//  InactiveAuctionsCell.swift
//  foz
//
//  Created by Ahmed Medhat on 28/09/2021.
//

import UIKit
import SDWebImage

class InactiveAuctionsCell: UICollectionViewCell {
    
    @IBOutlet weak var productNum: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var ProductTotalAmount: UILabel!
    @IBOutlet weak var auctionStartTime: UILabel!
    
    var inactiveAuctionCellViewModel: InactiveAuctionsCellViewModel? {
        didSet {
            productName.text = inactiveAuctionCellViewModel?.productName
            productNum.text = inactiveAuctionCellViewModel?.productNum
            productImage.sd_setImage(with: URL(string: inactiveAuctionCellViewModel!.productImage)!)
            ProductTotalAmount.text = inactiveAuctionCellViewModel?.ProductTotalAmount
            auctionStartTime.text = inactiveAuctionCellViewModel?.auctionStartTime
        }
    }
}
