//
//  AuctionsVC.swift
//  foz
//
//  Created by Ahmed Medhat on 06/09/2021.
//

import UIKit
import SDWebImage

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
    @IBOutlet weak var productIdView: CurveView!
    @IBOutlet weak var activeAuctionSpinner: UIActivityIndicatorView!
    
    
    var viewModel = AuctionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        inactiveAuctionCollectionView.delegate = self
        inactiveAuctionCollectionView.dataSource = self
//        soldAuctionCollectionView.delegate = self
//        soldAuctionCollectionView.dataSource = self
        initView()
        initData()
        hideActiveAuctionView()
    }

    func hideActiveAuctionView() {
        productImage.isHidden = true
        productIdLbl.isHidden = true
        productNameLbl.isHidden = true
        providerLogoImage.isHidden = true
        activeAUctionDescLbl.isHidden = true
        activeAuctionEnterBtn.isHidden = true
        productIdView.isHidden = true
    }
    
    func showActiveAuctionComponent() {
        productImage.isHidden = false
        productIdLbl.isHidden = false
        productNameLbl.isHidden = false
        providerLogoImage.isHidden = false
        activeAUctionDescLbl.isHidden = false
        activeAuctionEnterBtn.isHidden = false
        productIdView.isHidden = false
    }
    
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
            if let message = self?.viewModel.alertMesssage {
                self?.showAlert(message)
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
                        UIView.animate(withDuration: 2) {
                            self!.inactiveAuctionCollectionView.alpha = 0
                        }
                        print("err")
                case .populated:
                    self!.activeAuctionSpinner.stopAnimating()
                    UIView.animate(withDuration: 2) {
                        self!.inactiveAuctionCollectionView.alpha = 1
                    }
                    self!.showActiveAuctionComponent()
                        print("data come back")
                    print("num of inactive : \(self!.viewModel.numberOfCell)")
                    self!.activeAUctionDescLbl.text = self!.viewModel.ActiveUctionData?.active.description
                    self!.productNameLbl.text = self!.viewModel.ActiveUctionData?.active.title
                    self!.productIdLbl.text = self!.viewModel.ActiveUctionData?.active.serial_number
                    self?.providerLogoImage.sd_setImage(with: URL(string: (self!.viewModel.ActiveUctionData?.active.provider_image)!))
                    self?.productImage.sd_setImage(with: URL(string: (self!.viewModel.ActiveUctionData?.active.image_url)!))
                case .loading:
                    self!.activeAuctionSpinner.startAnimating()
                    UIView.animate(withDuration: 2) {
                        self!.inactiveAuctionCollectionView.alpha = 0
                    }
                }
                
            }
        }
        
        viewModel.reloadCollectionViewClousure = { [weak self] () in
            DispatchQueue.main.async {
                self!.inactiveAuctionCollectionView.reloadData()
            }
        }
        viewModel.initData()
        
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension AuctionsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == inactiveAuctionCollectionView {
        print("num of inactive : \(viewModel.numberOfCell)")
            return viewModel.numberOfCell
            
//        } else {
//            print("doesn't enter inactive scope")
//            return 5
//        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! InactiveAuctionCellinAuctions
//        if collectionView == inactiveAuctionCollectionView {
            
            let cellVM = viewModel.getCellViewModel(at: indexPath)
            cell.inactiveAuctionListCellinAuctions = cellVM
            return cell
//        }
//        return cell
    }
}
