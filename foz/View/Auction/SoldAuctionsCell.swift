//
//  SoldAuctionsCell.swift
//  foz
//
//  Created by Ahmed Medhat on 29/09/2021.
//

import UIKit
import SDWebImage
class SoldAuctionsCell: UICollectionViewCell {
    
    @IBOutlet weak var auctionNum: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var bidWinnerName: UILabel!
    @IBOutlet weak var bidWinnerImage: UIImageView!
    @IBOutlet weak var bidTotalAmount: UILabel!
    
    var soldAuctionCellViewModel: SoldAuctionsCellViewModel? {
        didSet {
            auctionNum.text = soldAuctionCellViewModel?.auctionNum
            productImage.sd_setImage(with: URL(string: soldAuctionCellViewModel!.productImage))
            bidWinnerImage.sd_setImage(with: URL(string: soldAuctionCellViewModel!.bidWinnerImage))
            productName.text = soldAuctionCellViewModel?.productName
            bidWinnerName.text = soldAuctionCellViewModel?.bidWinnerName
            bidTotalAmount.text = "\(soldAuctionCellViewModel!.bidTotalAmount)"
        }
    }
}
