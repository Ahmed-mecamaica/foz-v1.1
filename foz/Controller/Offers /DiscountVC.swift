//
//  DiscountVC.swift
//  foz
//
//  Created by Ahmed Medhat on 04/10/2021.
//

import UIKit

class DiscountVC: UIViewController {

    @IBOutlet weak var discountTblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        discountTblView.delegate = self
        discountTblView.dataSource = self
    }

}

extension DiscountVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DiscountCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
