//
//  AdsCategoryCell.swift
//  foz
//
//  Created by Ahmed Medhat on 17/11/2021.
//

import UIKit
import SDWebImage

class AdsCategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var adNumberView: UIView!
    @IBOutlet weak var adNumberLbl: UILabel!
    @IBOutlet weak var adCategoryBackgroundImage: UIImageView!
    @IBOutlet weak var adCategoryNameLbl: UILabel!
    
    var categoryListCellViewModel: CategoryListCellViewModel? {
        didSet {
            
            adCategoryBackgroundImage.sd_setImage(with: URL(string: categoryListCellViewModel!.ctegoryBackgroundImage))
            adCategoryNameLbl.text = categoryListCellViewModel?.categoryName

            adNumberView.layer.borderWidth = 1
            adNumberView.layer.borderColor = CGColor.init(red: 255, green: 255, blue: 255, alpha: 1)
            
            if categoryListCellViewModel?.adsInsideCategoryNum == 0 {
                adNumberView.backgroundColor = .gray
                adNumberLbl.text = "0"
            }
            else if categoryListCellViewModel!.adsInsideCategoryNum > 99 {
                adNumberView.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.6156862745, blue: 0.007843137255, alpha: 1)
                adNumberLbl.text = "+99"
            }
            else {
                adNumberView.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.6156862745, blue: 0.007843137255, alpha: 1)
                adNumberLbl.text = "\(categoryListCellViewModel!.adsInsideCategoryNum)"
            }
            
        }
    }
}
