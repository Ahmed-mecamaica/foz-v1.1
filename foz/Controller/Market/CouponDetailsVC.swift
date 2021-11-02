//
//  CouponDetailsVC.swift
//  foz
//
//  Created by Ahmed Medhat on 01/11/2021.
//

import UIKit
import SDWebImage

class CouponDetailsVC: UIViewController {

    @IBOutlet weak var headerAdPhoto: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var providerLogo: UIImageView!
    @IBOutlet weak var priceBeforDiscountLbl: UILabel!
    @IBOutlet weak var lineOnPriceBeforDiscount: CurveShadowView!
    @IBOutlet weak var discountPercsentLbl: UILabel!
    @IBOutlet weak var couponPriceLbl: UILabel!
    @IBOutlet weak var headerViewOfCoupon: UIView!
    
    @IBOutlet weak var viewsNumLbl: UILabel!
    @IBOutlet weak var expiredDateLbl: UILabel!
    
    @IBOutlet weak var lastBidAmountLbl: UILabel!
    @IBOutlet weak var lastBidUserNameLbl: UILabel!
    @IBOutlet weak var directBuyAmountLbl: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    lazy var viewModel: CouponDetailsViewModel = {
        return CouponDetailsViewModel()
    }()
    static var providerId = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lineOnPriceBeforDiscount.transform = CGAffineTransform(rotationAngle: -35)
        headerViewOfCoupon.layer.borderWidth = 2
        headerViewOfCoupon.layer.borderColor = #colorLiteral(red: 0.9137254902, green: 0.5803921569, blue: 0.03137254902, alpha: 1)
        initFetchDetailsData()
    }
    
    func initFetchDetailsData() {
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
                                self!.headerAdPhoto.alpha = 0
                                self!.scrollView.alpha = 0
                            }
                            
                        case .populated:
                        print("coupon details data \(self!.viewModel.couponDetailsData)")
                            self!.spinner.stopAnimating()
                            if let adImageUrl = self!.viewModel.adsPhotoData?.image_url {
                                self?.headerAdPhoto.sd_setImage(with: URL(string: adImageUrl))
                            }
                            if let couponDetailsData = self?.viewModel.couponDetailsData {
                                self?.providerLogo.sd_setImage(with: URL(string:couponDetailsData.provider_image)!)
                                self?.priceBeforDiscountLbl.text = couponDetailsData.price_before_discount
                                self?.discountPercsentLbl.text = couponDetailsData.discount + "%"
                                self?.couponPriceLbl.text = couponDetailsData.offer_price
                                self?.viewsNumLbl.text = "مشاهدة \(couponDetailsData.views)"
                                self?.expiredDateLbl.text = "ينتهي في: " + couponDetailsData.expire_date
                                self?.lastBidAmountLbl.text = "\(couponDetailsData.last_amount) ريال"
                                self?.lastBidUserNameLbl.text = couponDetailsData.last_username
                                self?.directBuyAmountLbl.text = couponDetailsData.offer_price + " ريال"
                            }
                        
                            UIView.animate(withDuration: 0.5) {
                                self!.headerAdPhoto.alpha = 1
                                self!.scrollView.alpha = 1
                            }
                            
                        case .loading:
                            self!.spinner.startAnimating()
                            UIView.animate(withDuration: 0.5) {
                                self!.headerAdPhoto.alpha = 0
                                self!.scrollView.alpha = 0
                            }
                        }
                }
            }
            viewModel.initAdsPhoto()
            viewModel.initFetchCouponDetailsData(providerId: CouponDetailsVC.providerId)
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func backBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
