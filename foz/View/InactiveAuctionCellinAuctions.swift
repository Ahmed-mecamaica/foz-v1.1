//
//  InactiveAuctionCellinAuctions.swift
//  foz
//
//  Created by Ahmed Medhat on 23/09/2021.
//

import UIKit
import SDWebImage

class InactiveAuctionCellinAuctions: UICollectionViewCell {
    @IBOutlet weak var auctionIdLbl: UILabel!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productImageLbl: UIImageView!
    
    var inactiveAuctionListCellinAuctions: InactiveAuctionListCellinAuctions? {
        didSet {
            productImageLbl.sd_setImage(with: URL(string: (inactiveAuctionListCellinAuctions?.image_url)!))
            auctionIdLbl.text = inactiveAuctionListCellinAuctions?.id
            productNameLbl.text = inactiveAuctionListCellinAuctions?.title
        }
    }
}
