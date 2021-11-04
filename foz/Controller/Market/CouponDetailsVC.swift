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
    
    
    @IBOutlet weak var paymentPopupView: UIView!
    @IBOutlet weak var buyBtnINPaymentView: BorderBtn!
    @IBOutlet weak var visaRadioBtn: UIImageView!
    @IBOutlet weak var stcRadioBtn: UIImageView!
    @IBOutlet weak var walletRadioBtn: UIImageView!
    @IBOutlet weak var paymentDonePopupView: CurveShadowView!
    
    lazy var viewModel: CouponDetailsViewModel = {
        return CouponDetailsViewModel()
    }()
    
    let transparentView = UIView()
    let emptyRadioBtnImageName = "circle"
    let fillRadioBtnImageName = "circle.dashed.inset.fill"
    static var providerId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lineOnPriceBeforDiscount.transform = CGAffineTransform(rotationAngle: -35)
        headerViewOfCoupon.layer.borderWidth = 2
        headerViewOfCoupon.layer.borderColor = #colorLiteral(red: 0.9137254902, green: 0.5803921569, blue: 0.03137254902, alpha: 1)
        initPaymentView()
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
                                    PaymentVC.screen = "market"
                                    PaymentVC.couponPrice = "\(couponDetailsData.offer_price)"
                                    PaymentVC.couponId = "\(couponDetailsData.coupon_id)"
                                    
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
    
    func showPaymentMethods() {
        walletRadioBtn.image = UIImage(systemName: emptyRadioBtnImageName)
        visaRadioBtn.image = UIImage(systemName: emptyRadioBtnImageName)
        stcRadioBtn.image = UIImage(systemName: emptyRadioBtnImageName)
        
        self.transparentView.frame = self.view.frame
        self.view.addSubview(transparentView)
        self.view.addSubview(paymentPopupView)
        //TO DO:
//        self.view.addSubview(paymentDonePopupView)
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 1
        blurEffectView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        self.transparentView.addSubview(blurEffectView)
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removePaymentMethodView))
        UIView.animate(withDuration: 0.4) {
            self.transparentView.alpha = 0.5
            self.paymentPopupView.alpha = 1
        }
        transparentView.addGestureRecognizer(tapGesture)
    }
    
    func initPaymentView() {
        buyBtnINPaymentView.layer.cornerRadius = 12
        paymentPopupView.layer.borderWidth = 1
        paymentPopupView.layer.borderColor = #colorLiteral(red: 1, green: 0.5933408737, blue: 0, alpha: 1)
    }
    
    @IBAction func directBuyBtnInsideVCTapped(_ sender: Any) {
        showPaymentMethods()
    }
    
    @IBAction func visaBtnTapped(_ sender: Any) {
        if visaRadioBtn.image == UIImage(systemName: emptyRadioBtnImageName) {
            visaRadioBtn.image = UIImage(systemName: fillRadioBtnImageName)
            stcRadioBtn.image = UIImage(systemName: emptyRadioBtnImageName)
            walletRadioBtn.image = UIImage(systemName: emptyRadioBtnImageName)
        }
        else {
            visaRadioBtn.image = UIImage(systemName: emptyRadioBtnImageName)
        }
    }
    
    @IBAction func stcBtnTapped(_ sender: Any) {
        if stcRadioBtn.image == UIImage(systemName: emptyRadioBtnImageName) {
            stcRadioBtn.image = UIImage(systemName: fillRadioBtnImageName)
            visaRadioBtn.image = UIImage(systemName: emptyRadioBtnImageName)
            walletRadioBtn.image = UIImage(systemName: emptyRadioBtnImageName)
        }
        else {
            stcRadioBtn.image = UIImage(systemName: emptyRadioBtnImageName)
        }
    }
    
    @IBAction func walletBtnTapped(_ sender: Any) {
        if walletRadioBtn.image == UIImage(systemName: emptyRadioBtnImageName) {
            walletRadioBtn.image = UIImage(systemName: fillRadioBtnImageName)
            
            visaRadioBtn.image = UIImage(systemName: emptyRadioBtnImageName)
            stcRadioBtn.image = UIImage(systemName: emptyRadioBtnImageName)
        }
        else {
            walletRadioBtn.image = UIImage(systemName: emptyRadioBtnImageName)
        }
    }
    
    @IBAction func buyBtnInssidePaymentViewTapped(_ sender: Any) {
        let paymentVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "payment_vc") as! PaymentVC
//        DispatchQueue.main.async {
            self.present(paymentVC, animated: true, completion: nil)
//        }
    }
    
    @objc func removePaymentMethodView() {
        UIView.animate(withDuration: 0.4) {
            self.transparentView.alpha = 0
            self.paymentPopupView.alpha = 0
//            self.paymentDonePopupView.alpha = 0
        }
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
