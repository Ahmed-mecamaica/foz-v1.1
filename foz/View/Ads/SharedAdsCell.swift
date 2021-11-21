//
//  SharedAdsCell.swift
//  foz
//
//  Created by Ahmed Medhat on 21/11/2021.
//

import UIKit
import SDWebImage

class SharedAdsCell: UITableViewCell {

    @IBOutlet weak var adLogoImage: UIImageView!
    @IBOutlet weak var adNameLbl: UILabel!
    @IBOutlet weak var adDescLbl: UILabel!
    
    var sharedAdsListCellViewModel: SharedAdsListCellViewModel? {
        didSet {
            adNameLbl.text = sharedAdsListCellViewModel?.adName
            adDescLbl.text = sharedAdsListCellViewModel?.adDesc
            adLogoImage.sd_setImage(with: URL(string: sharedAdsListCellViewModel!.adLogo))
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
