//
//  OffersCategoryVC.swift
//  foz
//
//  Created by Ahmed Medhat on 03/10/2021.
//

import UIKit

class OffersCategoryVC: UIViewController {

    @IBOutlet weak var offerCategoryTblView: UITableView!
    
    var categoryName = ["مطاعم", "كافيهات"]
    var categoryImageName = ["offer_category_one", "offers_category_two"]
    override func viewDidLoad() {
        super.viewDidLoad()

        offerCategoryTblView.delegate = self
        offerCategoryTblView.dataSource = self
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.5) {
            self.offerCategoryTblView.alpha = 1
        }
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension OffersCategoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! OfferCategoryCell
        cell.categoryImage.image = UIImage(named: categoryImageName[indexPath.row])
        cell.categoryNameLbl.text = categoryName[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ((offerCategoryTblView.frame.height/2) - 25)
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        if indexPath.row == 0 {
//            let restaurantVC = storyboard?.instantiateViewController(identifier: "") as
//        }
//        else {
//
//        }
    }
}
