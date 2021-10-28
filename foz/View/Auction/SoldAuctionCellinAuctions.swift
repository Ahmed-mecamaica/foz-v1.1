//
//  SoldAuctionCellinAuctions.swift
//  foz
//
//  Created by Ahmed Medhat on 23/09/2021.
//

import UIKit

class SoldAuctionCellinAuctions: UICollectionViewCell {
    
    @IBOutlet weak var productTitleLbl: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productIdLbl: UILabel!
    
    var soldAuctionListCellinAuctions: SoldAuctionListCellinAuctions? {
        didSet {
            productImage.sd_setImage(with: URL(string: soldAuctionListCellinAuctions!.image_url))
            productIdLbl.text = soldAuctionListCellinAuctions?.id
            productTitleLbl.text = soldAuctionListCellinAuctions?.title
        }
    }
}
