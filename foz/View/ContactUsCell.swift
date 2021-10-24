//
//  ContactUsCell.swift
//  foz
//
//  Created by Ahmed Medhat on 14/10/2021.
//

import UIKit

class ContactUsCell: UITableViewCell {

    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var messageBackgroundView: CurveView!
    @IBOutlet weak var messageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTrailingConstraint: NSLayoutConstraint!
    
    var contactUsMessageCellViewModel: ContactUsMessageCellViewModel? {
        didSet {
            messageLbl.text = contactUsMessageCellViewModel?.mesaage
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
