//
//  HomeVC.swift
//  foz
//
//  Created by Ahmed Medhat on 26/08/2021.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var sideMenuBtn: UIButton!
    @IBOutlet weak var adAreaImage: UIImageView!
    @IBOutlet weak var homeTblView: UITableView!
    
    var sectionBackgroundArray = ["auction_home", "ads_home", "offers_home", "market_home", "reward_home", "coupons_home"]
    var sectionTitleArray = ["المزادات", "الإعلانات", "العروض", "السوق", "المكافآت", "كوبوناتي"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        homeTblView.delegate = self
        homeTblView.dataSource = self
        sideMenuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        animateTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    
    func animateTable() {
            self.homeTblView.reloadData()

            let cells = homeTblView.visibleCells
            let tableHeight: CGFloat = homeTblView.bounds.size.height

            for i in cells {
                let cell: UITableViewCell = i as UITableViewCell
                cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
            }

            var index = 0

            for a in cells {
                self.homeTblView.isHidden = false
                let cell: UITableViewCell = a as UITableViewCell
                UIView.animate(withDuration: 1.5, delay: 0.04 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .transitionFlipFromTop, animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0);
                }, completion: nil)

                index += 1
            }
        }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell") as! HomeTableViewCell
        cell.cellTitleLbl.text = sectionTitleArray[indexPath.row]
        let imageName = sectionBackgroundArray[indexPath.row]
        cell.cellImage.image = UIImage(named: imageName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let auctionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "auction_vc_id")
            DispatchQueue.main.async {
                self.present(auctionVC, animated: true, completion: nil)
            }
        }
    }
}
