//
//  HomeVC.swift
//  foz
//
//  Created by Ahmed Medhat on 26/08/2021.
//

import UIKit
import SDWebImage

class HomeVC: UIViewController {

    @IBOutlet weak var sideMenuBtn: UIButton!
    @IBOutlet weak var adAreaImage: UIImageView!
    @IBOutlet weak var homeTblView: UITableView!
    @IBOutlet weak var headerAdSpinner: UIActivityIndicatorView!
    
    lazy var viewModel: ProvidersListViewModel = {
        return ProvidersListViewModel()
    }()
    
    var sectionBackgroundArray = ["auction_home", "ads_home", "offers_home", "market_home", "reward_home", "coupons_home"]
    var sectionTitleArray = ["المزادات", "الإعلانات", "العروض", "السوق", "المكافآت", "كوبوناتي"]
    var homeVCIsShown = false
    
    let rectInsets = UIEdgeInsets(top: -19, left: -61, bottom: -19, right: -61)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        homeTblView.delegate = self
        homeTblView.dataSource = self
        sideMenuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        homeTblView.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.homeVCIsShown = true
        }
        getHeaderAdPhoto()
        
        //make image cap
//
//        let capInsets = UIEdgeInsets(top: 12, left: 22, bottom: 20, right: 12)
//        adAreaImage.image = UIImage(named: "auction_home")
//        adAreaImage.image?.resizableImage(withCapInsets: capInsets)
//        adAreaImage.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if homeVCIsShown == false {
            UIView.animate(withDuration: 2) {
                self.homeTblView.alpha = 1
            }
            animateTable()
        }
        
    }
    
    func getHeaderAdPhoto() {
        
        viewModel.showAlertClosure = { [weak self] in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMesssage {
                    self?.showAlert(message)
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                switch self!.viewModel.state {
                    case .empty, .error:
                        self!.headerAdSpinner.stopAnimating()
                        UIView.animate(withDuration: 0.5) {
                            self!.adAreaImage.alpha = 0
                        }
                        
                    case .populated:
                        self!.headerAdSpinner.stopAnimating()
                    if let adImage = self?.viewModel.adsPhotoData {
                        self?.adAreaImage.sd_setImage(with: URL(string: adImage.image_url))
                    }
                        
                        UIView.animate(withDuration: 0.5) {
                            self!.adAreaImage.alpha = 1
                        }
                        
                    case .loading:
                        self!.headerAdSpinner.startAnimating()
                        UIView.animate(withDuration: 0.5) {
                            self!.adAreaImage.alpha = 0
                        }
                    }
            }
        }
        viewModel.initAdsPhoto()
      
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
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell") as! HomeTableViewCell
        
        cell.cellTitleLbl.text = sectionTitleArray[indexPath.row]
        let imageName = sectionBackgroundArray[indexPath.row]
        cell.cellImage.image = UIImage(named: imageName)
//        let insets = UIEdgeInsets(top: 12.0, left: 20.0, bottom: 22.0, right: 12)
//        cell.cellImage.image = cell.cellImage.image!.resizableImage(withCapInsets: insets, resizingMode: .stretch)
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
        else if indexPath.row == 1 {
            
            let offerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Ads-Home-VC")
            DispatchQueue.main.async {
                self.present(offerVC, animated: true, completion: nil)
            }
        }
        else if indexPath.row == 2 {
            
            let offerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "offer_category_vc")
            DispatchQueue.main.async {
                self.present(offerVC, animated: true, completion: nil)
            }
        }
        else if indexPath.row == 3 {
            
            let offerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "market-vc")
            DispatchQueue.main.async {
                self.present(offerVC, animated: true, completion: nil)
            }
        }
    }
}
