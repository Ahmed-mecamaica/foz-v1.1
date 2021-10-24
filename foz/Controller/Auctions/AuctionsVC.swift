//
//  AuctionsVC.swift
//  foz
//
//  Created by Ahmed Medhat on 06/09/2021.
//

import UIKit
import SDWebImage

protocol sideSelection  {
    func didTapAuction(auctionId: String)
}

class AuctionsVC: UIViewController {

    @IBOutlet weak var inactiveAuctionCollectionView: UICollectionView!
    @IBOutlet weak var soldAuctionCollectionView: UICollectionView!
    
    //MARK: actineAuction outlets
    @IBOutlet weak var activeAUctionDescLbl: UILabel!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var providerLogoImage: UIImageView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productIdLbl: UILabel!
    @IBOutlet weak var activeAuctionEnterBtn: RoundedButton!
    @IBOutlet weak var productIdView: CurveShadowView!
    @IBOutlet weak var activeAuctionSpinner: UIActivityIndicatorView!
    
    var sideSelectionDelegate: sideSelection!
    var viewModel = AuctionViewModel()
    var activeauctionId = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        inactiveAuctionCollectionView.delegate = self
        inactiveAuctionCollectionView.dataSource = self
        soldAuctionCollectionView.delegate = self
        soldAuctionCollectionView.dataSource = self
        initView()
        initData()
        hideActiveAuctionView(status: true)
        
        //logout
        LoginResponse.current = nil
    }

    func hideActiveAuctionView(status: Bool) {
        productImage.isHidden = status
        productIdLbl.isHidden = status
        productNameLbl.isHidden = status
        providerLogoImage.isHidden = status
        activeAUctionDescLbl.isHidden = status
        activeAuctionEnterBtn.isHidden = status
        productIdView.isHidden = status
    }
    
//    func showActiveAuctionComponent() {
//        productImage.isHidden = false
//        productIdLbl.isHidden = false
//        productNameLbl.isHidden = false
//        providerLogoImage.isHidden = false
//        activeAUctionDescLbl.isHidden = false
//        activeAuctionEnterBtn.isHidden = false
//        productIdView.isHidden = false
//    }
    
    func initView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: self.soldAuctionCollectionView.frame.width/2 - 50, height: self.soldAuctionCollectionView.frame.height)
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        flowLayout.scrollDirection = .horizontal
        soldAuctionCollectionView.layer.cornerRadius = 10
        inactiveAuctionCollectionView.layer.cornerRadius = 10
        soldAuctionCollectionView.setCollectionViewLayout(flowLayout, animated: true)
        inactiveAuctionCollectionView.setCollectionViewLayout(flowLayout, animated: true)

    }
    
    func initData() {
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
                        self!.activeAuctionSpinner.stopAnimating()
                    UIView.animate(withDuration: 0.7) {
                            self!.inactiveAuctionCollectionView.alpha = 0
                            self!.soldAuctionCollectionView.alpha = 0
                            self!.hideActiveAuctionView(status: true)
                        }
                        
                    case .populated:
                        self!.activeAuctionSpinner.stopAnimating()
//                        UIView.animate(withDuration: 2) {
//                            self!.inactiveAuctionCollectionView.alpha = 1
//                            self!.soldAuctionCollectionView.alpha = 1
//                        }
//                        self!.showActiveAuctionComponent()
                        
                        self!.activeAUctionDescLbl.text = self!.viewModel.activeAuctionData?.active.description
                        self!.productNameLbl.text = self!.viewModel.activeAuctionData?.active.title
                        self!.productIdLbl.text = self!.viewModel.activeAuctionData?.active.serial_number
                        
                        if let activeAuctionData = self!.viewModel.activeAuctionData {
                            self?.providerLogoImage.sd_setImage(with: URL(string: (activeAuctionData.active.provider_image)))
                            self?.productImage.sd_setImage(with: URL(string: (activeAuctionData.active.image_url)))
                            
                        }
                    
                        self?.activeauctionId = "\(self?.viewModel.activeAuctionData?.active.id)"
                        if let activeAuctionVideoData = self!.viewModel.activeAuctionViedoData {
                            ActiveAuctionVC.activeAuctionVideoUrl = activeAuctionVideoData.data.video_url
                            ActiveAuctionVC.adId = "\(activeAuctionVideoData.data.id)"
                            UIView.animate(withDuration: 0.7) {
                                self!.inactiveAuctionCollectionView.alpha = 1
                                self!.soldAuctionCollectionView.alpha = 1
                            }
                            self!.hideActiveAuctionView(status: false)
                        }
                    
                    case .loading:
                        self!.hideActiveAuctionView(status: true)
                        self!.activeAuctionSpinner.startAnimating()
                        UIView.animate(withDuration: 0.7) {
                            self!.inactiveAuctionCollectionView.alpha = 0
                            self!.soldAuctionCollectionView.alpha = 0
                        }
                    }
                
            }
        }
        
        viewModel.reloadCollectionViewClousure = { [weak self] () in
            DispatchQueue.main.async {
                self!.inactiveAuctionCollectionView.reloadData()
                self!.soldAuctionCollectionView.reloadData()
            }
        }
        
        viewModel.initData()
        viewModel.initFetchActiveAuctionVideoAdUrl(auctionId: self.activeauctionId)
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func enterActiveAuctionBtnTapped(_ sender: Any) {
//        sideSelectionDelegate.didTapAuction(auctionId: "\(viewModel.ActiveUctionData?.active.id)")
        let activeAuctionVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "active_auction_id") as! ActiveAuctionVC
        activeAuctionVC.auctionId = "\(viewModel.activeAuctionData!.active.id)"
        present(activeAuctionVC, animated: true, completion: nil)
    }
    
}

extension AuctionsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == inactiveAuctionCollectionView {
       
            return viewModel.inactiveAuctionNumberOfCell
            
        } else {
            
            return viewModel.soldAuctionNumberOfCell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == inactiveAuctionCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! InactiveAuctionCellinAuctions
            let cellVM = viewModel.getCellViewModel(at: indexPath)
            cell.inactiveAuctionListCellinAuctions = cellVM
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SoldAuctionCellinAuctions
            let cellVM = viewModel.getSoldCellViewModel(at: indexPath)
            cell.soldAuctionListCellinAuctions = cellVM
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == inactiveAuctionCollectionView {
            let inactiveAuctionVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "inactive_auction_vc")
            DispatchQueue.main.async {
                self.present(inactiveAuctionVC, animated: true, completion: nil)
            }
        }
        else {
            let inactiveAuctionVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "sold_auction_vc")
            DispatchQueue.main.async {
                self.present(inactiveAuctionVC, animated: true, completion: nil)
            }
        }
    }
}
