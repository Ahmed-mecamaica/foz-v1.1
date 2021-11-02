//
//  MarketVC.swift
//  foz
//
//  Created by Ahmed Medhat on 31/10/2021.
//

import UIKit
import SDWebImage

class MarketVC: UIViewController {

    
    @IBOutlet weak var headerAdImage: UIImageView!
    @IBOutlet weak var marketCouponCollectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    lazy var viewModel: MarketListViewModel = {
        return MarketListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        marketCouponCollectionView.delegate = self
        marketCouponCollectionView.dataSource = self
        initFetchMarketData()
        initCollectionView()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func initCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: marketCouponCollectionView.frame.width/2 - 30, height: 300)
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 12)
//        flowLayout.scrollDirection = .
        self.marketCouponCollectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
    
    
    
    func initFetchMarketData() {
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
                        self!.spinner.stopAnimating()
                    UIView.animate(withDuration: 0.5) {
                        self!.headerAdImage.alpha = 0
                            self!.marketCouponCollectionView.alpha = 0
                        }
                        
                    case .populated:
                        self!.spinner.stopAnimating()
                        if let adImageUrl = self!.viewModel.adsPhotoData?.image_url {
                            self?.headerAdImage.sd_setImage(with: URL(string: adImageUrl))
                        }
                        UIView.animate(withDuration: 0.5) {
                            self!.headerAdImage.alpha = 1
                            self!.marketCouponCollectionView.alpha = 1
                        }
                        
                    case .loading:
                        self!.spinner.startAnimating()
                        UIView.animate(withDuration: 0.5) {
                            self!.headerAdImage.alpha = 0
                            self!.marketCouponCollectionView.alpha = 0
                        }
                    }
            }
        }
        
        viewModel.reloadCollectionViewClousure = { [weak self] () in
            DispatchQueue.main.async {
                self?.marketCouponCollectionView.reloadData()
            }
        }
        viewModel.initAdsPhoto()
        viewModel.initFetchMarketData()
    }

    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}


extension MarketVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.marketNumberOfCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MarketCell
        cell.headerView.CurveHeaderViewInsideMarketVC()
        cell.footerView.CurveFooterViewInsideMarketVC(height: cell.headerView.frame.height)
        cell.layer.cornerRadius = 10
        cell.lineOverLastPrice.transform = CGAffineTransform(rotationAngle: -35)
        let cellvm = viewModel.getCellViewModel(at: indexPath)
        
        cell.marketListCellViewModel = cellvm
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let providerCouponsVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "market-coupon-details-vc") as! CouponDetailsVC
        self.viewModel.userPressed(at: indexPath)
        let selectedMarket = viewModel.selectedMarket
        CouponDetailsVC.providerId = "\(selectedMarket!.id)"
        present(providerCouponsVC, animated: true, completion: nil)
//        print("data passed successfully and provider id is \()")

    }
}
