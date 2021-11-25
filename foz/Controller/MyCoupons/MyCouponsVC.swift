//
//  MyCouponsVC.swift
//  foz
//
//  Created by Ahmed Medhat on 23/11/2021.
//

import UIKit

class MyCouponsVC: UIViewController {

    @IBOutlet weak var allCouponsTblView: UITableView!
    @IBOutlet weak var marketCouponsTblView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var currentBalanceView: UIView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    lazy var viewModel: MyCouponsListViewModel = {
        return MyCouponsListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegateAndDataSource()
        initCurrentBalanceView()
        initFetchAllCouponsData()
//        initFetchMarketCouponsData()
        allCouponsTblView.alpha = 0
        marketCouponsTblView.alpha = 0
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmentController(_ sender: Any) {
        switch segmentController.selectedSegmentIndex {
        case 0:
            allCouponsTblView.alpha = 1
            marketCouponsTblView.alpha = 0
        case 1:
            allCouponsTblView.alpha = 0
            marketCouponsTblView.alpha = 1
        default:
            break
        }
    }
    
    //this func to fetch coupons of all and market coupons section
    func initFetchAllCouponsData() {
        viewModel.showAlertClosure = { [weak self] in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMesssage {
                    self?.showAlert(message: message)
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
                        self!.spinner.stopAnimating()
                    UIView.animate(withDuration: 0.5) {
                            self!.allCouponsTblView.alpha = 0
                            self!.marketCouponsTblView.alpha = 0
                        }
                        
                    case .populated:
                        self!.spinner.stopAnimating()
                        UIView.animate(withDuration: 0.5) {
                            self!.allCouponsTblView.alpha = 1
                            if self!.segmentController.selectedSegmentIndex == 1 {
                                self!.marketCouponsTblView.alpha = 1
                            }
                        }
                        
                    case .loading:
                        self!.spinner.startAnimating()
                        UIView.animate(withDuration: 0.5) {
                            self!.allCouponsTblView.alpha = 0
                            self!.marketCouponsTblView.alpha = 0
                        }
                    }
            }
        }
        
        viewModel.reloadCollectionViewClousure = { [weak self] () in
            DispatchQueue.main.async {
                self?.allCouponsTblView.reloadData()
                self?.marketCouponsTblView.reloadData()
            }
        }
        viewModel.initFetchMarketCouponsData()
        viewModel.initFetchAllCouponsData()
    }
    
    //call this func to set delegate and data source for table view
    func setDelegateAndDataSource() {
        allCouponsTblView.delegate = self
        marketCouponsTblView.delegate = self
        allCouponsTblView.dataSource = self
        marketCouponsTblView.dataSource = self
    }
    
    //call this func to customiz the current balance view
    func initCurrentBalanceView() {
        currentBalanceView.layer.cornerRadius = currentBalanceView.frame.height / 2 - 5
        currentBalanceView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        currentBalanceView.layer.borderWidth = 0.9
    }
    
    //call this func to show alert on screen
    func showAlert(message: String) {
        let alertvc = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertvc.addAction(UIAlertAction(title: "ok", style: .default))
        present(alertvc, animated: true, completion: nil)
    }
}


extension MyCouponsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == allCouponsTblView {
            return viewModel.allCouponNumberOfCell
        }else if tableView == marketCouponsTblView {
            return viewModel.marketCouponNumberOfCell
        }
        else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == allCouponsTblView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AllCouponsCell
            cell.giftBtn.myCouponBorderBtn(height: cell.giftBtn.frame.height)
            cell.useCouponBtn.myCouponBorderBtn(height: cell.giftBtn.frame.height)
            let cellvm = viewModel.getAllCellViewModel(at: indexPath)
            cell.allCouponsListCellViewModel = cellvm
            if cell.couponTypeLbl.text == "auction" && cell.allCouponsListCellViewModel?.in_market == 0 {
                let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Cairo", size: 12.0)! ]
                let myAttrString = NSAttributedString(string: "عرض في السوق", attributes: myAttribute)
                cell.showInMarketBtn.setAttributedTitle(myAttrString, for: .normal)
                cell.showInMarketBtn.isHidden = false
            } else if cell.couponTypeLbl.text == "gift" {
                print(cell.couponTypeLbl.text)
                let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Cairo", size: 12.0)! ]
//                let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "Cairo", size: 12.0)! ]
                let myAttrString = NSAttributedString(string: "تحديد المتجر", attributes: myAttribute)
                cell.showInMarketBtn.setAttributedTitle(myAttrString, for: .normal)
                
                cell.showInMarketBtn.isHidden = false
            }
            else {
                cell.showInMarketBtn.isHidden = true
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MarketCouponsCell
            cell.directSaleBtn.myCouponBorderBtn(height: cell.directSaleBtn.frame.height)
            cell.priceEditeBtn.myCouponBorderBtn(height: cell.directSaleBtn.frame.height)
            cell.cancelOfferBtn.myCouponRedBorderBtn(height: cell.directSaleBtn.frame.height)
            let cellvm = viewModel.getmarketCellViewModel(at: indexPath)
            cell.marketCouponsListCellViewModel = cellvm
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185
    }
}
