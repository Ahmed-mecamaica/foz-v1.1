//
//  AdsInsideCategoryCell.swift
//  foz
//
//  Created by Ahmed Medhat on 17/11/2021.
//

import UIKit
import SDWebImage

class AdsInsideCategoryCell: UITableViewCell {

    @IBOutlet weak var adThumbnail: UIImageView!
    
    
    var adsInsideCategoryCellViewModel: AdsInsideCategoryCellViewModel? {
        didSet {
            adThumbnail.sd_setImage(with: URL(string: "\(adsInsideCategoryCellViewModel!.adthumbnail)"))
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
