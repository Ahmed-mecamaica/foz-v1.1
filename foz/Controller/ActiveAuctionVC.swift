//
//  ActiveAuctionVC.swift
//  foz
//
//  Created by Ahmed Medhat on 06/09/2021.
//

import UIKit
import SDWebImage

class ActiveAuctionVC: UIViewController {

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var lastBidValue: UILabel!
    @IBOutlet weak var providerLogo: UIImageView!
    @IBOutlet weak var lastBidUserName: UILabel!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var timer = Timer()
    var transparentView = UIView()
    let image = UIImageView()
    var auctionId = ""
    
    lazy var viewModel: ActiveAuctionViewModel = {
        return ActiveAuctionViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        progressBar.progress = 1.0
//        let auctionVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "auction_vc_id") as! AuctionsVC
//        auctionVC.sideSelectionDelegate = self
        initFetchData()
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func initFetchData() {
        viewModel.showAlertClosure = { [weak self] in
            if let message = self?.viewModel.alertMessage {
                self?.showAlert(message)
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                switch self!.viewModel.state {
                    case .error, .empty:
                        UIView.animate(withDuration: 2) {
                            self!.scrollView.alpha = 0
                        }
                        self!.spinner.stopAnimating()
                        
                    case .loading:
                        UIView.animate(withDuration: 2) {
                            self!.scrollView.alpha = 0
                        }
                        self!.spinner.startAnimating()
                        
                    case .populated:
                        UIView.animate(withDuration: 2) {
                            self!.scrollView.alpha = 1
                        }
                        self!.spinner.stopAnimating()
                        
                        self?.productName.text = self!.viewModel.activeAuctionData?.data.auction.title
                        
                        self?.productDescription.text = self!.viewModel.activeAuctionData?.data.auction.description
                        self?.productImage.sd_setImage(with: URL(string: (self!.viewModel.activeAuctionData?.data.auction.image_url)!))
                        self?.lastBidValue.text = self!.viewModel.activeAuctionData?.data.last_bid.amount
                        self?.lastBidUserName.text = self!.viewModel.activeAuctionData?.data.last_bid.username
                        self?.providerLogo.sd_setImage(with: URL(string: (self!.viewModel.activeAuctionData?.data.auction.provider_image)!))
                }
            }
        }
        
        viewModel.initFetch(auctionID: auctionId)
    }
    
    func addTransparentView() {
        self.transparentView.frame  = self.view.frame
        self.view.addSubview(transparentView)
        self.image.frame = CGRect(x: 20, y: 1500, width: 300, height: 300)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 1
        blurEffectView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        self.transparentView.addSubview(blurEffectView)
        
        image.image = UIImage(named: "cograts")
        image.contentMode = .scaleAspectFit
        self.view.addSubview(image)
        
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.transparentView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        UIView.animate(withDuration: 2, delay: 0.1, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.9
            self.image.frame = CGRect(x: 20, y: 300, width: self.view.frame.width - 20, height: 300)
        }, completion: nil)
        transparentView.addGestureRecognizer(tapGesture)
    }
    
    @objc func removeTransparentView() {
        UIView.animate(withDuration: 2) {
            self.transparentView.alpha = 0
            self.image.frame = CGRect(x: 20, y: 1500, width: 300, height: 300)
        }
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func bidBtnPressed(_ sender: Any) {
        addTransparentView()
//        progressBar.progress = 1.0
//        var progress: Float = 1.0
//        progressBar.progress = progress
//        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
//            progress -= 0.01
//            self.progressBar.progress = progress
//        })
    }
    
}

extension ActiveAuctionVC: sideSelection {
    func didTapAuction(auctionId: String) {
        self.auctionId = auctionId
        print("id ==== \(self.auctionId)")
    }
}
