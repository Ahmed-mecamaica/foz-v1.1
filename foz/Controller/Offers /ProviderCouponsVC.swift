//
//  DiscountVC.swift
//  foz
//
//  Created by Ahmed Medhat on 04/10/2021.
//

import UIKit
import SkeletonView
import AVFoundation
import SDWebImage

class ProviderCouponsVC: UIViewController {

    @IBOutlet weak var discountTblView: UITableView!
    @IBOutlet weak var providerImage: UIImageView!
    @IBOutlet weak var paymentPopupView: UIView!
    @IBOutlet weak var buyBtnINPaymentView: BorderBtn!
    @IBOutlet weak var visaRadioBtn: UIImageView!
    @IBOutlet weak var stcRadioBtn: UIImageView!
    @IBOutlet weak var walletRadioBtn: UIImageView!
    @IBOutlet weak var paymentDonePopupView: CurveShadowView!
    
    @IBOutlet weak var videoView: CustomRoundedView!
    @IBOutlet weak var viewsNumLbl: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    lazy var viewModel: ProviderCouponsViewModel = {
       return ProviderCouponsViewModel()
    }()
    
    let transparentView = UIView()
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    let emptyRadioBtnImageName = "circle"
    let fillRadioBtnImageName = "circle.dashed.inset.fill"
    static var providerID = ""
    static var providerImageUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        discountTblView.rowHeight = 150
        discountTblView.estimatedRowHeight = 150
        discountTblView.delegate = self
        discountTblView.dataSource = self
        
        providerImage.sd_setImage(with: URL(string: ProviderCouponsVC.providerImageUrl))
        initPaymentView()
        initProviderCouponsData()
//        initProviderVideoAdData()
        print("provider id \(ProviderCouponsVC.providerID)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        discountTblView.isSkeletonable = true
        discountTblView.showGradientSkeleton(usingGradient: .init(baseColor: .lightGray), animated: true, delay: 0.25, transition: .crossDissolve(0.25))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    func initAdVideoView(videoUrl: String) {
        videoView.alpha = 0
//        completeWatchingBtn.alpha = 0
        if let adsurl = URL(string: videoUrl) {
            self.player = AVPlayer(url: adsurl)
            self.playerLayer = AVPlayerLayer(player: self.player)
            self.playerLayer.videoGravity = .resize
            self.playerLayer.frame = self.videoView.bounds
            self.videoView.layer.addSublayer(self.playerLayer)
//            self.videoView.addSubview(completeWatchingBtn)
            
            self.player.play()
            self.player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main, using: { (time) in
                    if self.player!.currentItem?.status == .readyToPlay {
                        self.videoView.alpha = 1
                        let duration = self.player!.currentItem?.duration.seconds
//                        self.adSecondCounter = Int(duration!)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3 ) { [self] in
                            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
//                                completeWatchingBtn.alpha = 1
//                                self.viewDoneBtn.isHidden = false
//                                self.videoCounterView.isHidden = true
                            })
                        }
                        let currentTime = CMTimeGetSeconds(self.player!.currentTime())

                        let secs = Int(currentTime)
//                        self.videoCounterLbl.text = NSString(format: "%02d:%02d", self.adSecondCounter, secs%60) as String//"\(secs/60):\(secs%60)"
                    }
                })
//            self.adTimer()
        }
    }
    
    func initProviderCouponsData() {
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
//                            self!.discountTblView.alpha = 0
                            self?.videoView.alpha = 0
                        }
                        
                    case .populated:
                        self!.spinner.stopAnimating()
                    
                        if let videoData = self?.viewModel.providerVideoAdData {
                            self!.initAdVideoView(videoUrl: videoData.video_url)
                            self?.viewsNumLbl.text = "\(videoData.views) مشاهدة"
                        }
                        else {
                            
                        }
                        UIView.animate(withDuration: 0.5) {
//                            self!.discountTblView.alpha = 1
                            self?.videoView.alpha = 1
                        }
                        
                    case .loading:
                        self!.spinner.startAnimating()
                        self?.videoView.alpha = 0
                    UIView.animate(withDuration: 0.5) {
//                            self!.discountTblView.alpha = 0
                        }
                    }
            }
        }
        
        viewModel.reloadCollectionViewClousure = { [weak self] () in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self!.discountTblView.stopSkeletonAnimation()
                self!.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                self?.discountTblView.reloadData()
            }
        }
        
        viewModel.initProviderData(providerId: ProviderCouponsVC.providerID)
        viewModel.initProviderVideoAdData(providerId: ProviderCouponsVC.providerID)
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func initPaymentView() {
        buyBtnINPaymentView.layer.cornerRadius = 12
        paymentPopupView.layer.borderWidth = 1
        paymentPopupView.layer.borderColor = #colorLiteral(red: 1, green: 0.5933408737, blue: 0, alpha: 1)
    }
    
    func showPaymentMethods() {
        walletRadioBtn.image = UIImage(systemName: emptyRadioBtnImageName)
        visaRadioBtn.image = UIImage(systemName: emptyRadioBtnImageName)
        stcRadioBtn.image = UIImage(systemName: emptyRadioBtnImageName)
        
        self.transparentView.frame = self.view.frame
        self.view.addSubview(transparentView)
        self.view.addSubview(paymentPopupView)
        self.view.addSubview(paymentDonePopupView)
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
    
    @objc func removePaymentMethodView() {
        UIView.animate(withDuration: 0.4) {
            self.transparentView.alpha = 0
            self.paymentPopupView.alpha = 0
            self.paymentDonePopupView.alpha = 0
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
        DispatchQueue.main.async {
            self.present(paymentVC, animated: true, completion: nil)
        }
        
        
        
//        UIView.animate(withDuration: 0.4) {
//            self.paymentPopupView.alpha = 0
//            self.paymentDonePopupView.alpha = 1
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.removePaymentMethodView()
//        }
    }
    
}

extension ProviderCouponsVC: UITableViewDelegate, SkeletonTableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ProviderCouponsCell
        cell.buyHalfView.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.5607843137, blue: 0.5607843137, alpha: 1)
        cell.discountHalfView.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.5607843137, blue: 0.5607843137, alpha: 1)
        cell.lineOnPriceBeforDiscount.transform = CGAffineTransform(rotationAngle: 0)
        let cellvm = viewModel.getCellViewModel(at: indexPath)
        cell.providerCouponsCellViewModel = cellvm
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "cell"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("num of coupons \(viewModel.providerCouponsNumberOfCell)")
        return viewModel.providerCouponsNumberOfCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        viewModel.userPressed(at: indexPath)
        if viewModel.isAllowSegue {
            PaymentVC.screen = "offer"
            PaymentVC.couponPrice = "\(viewModel.selectedCoupon!.price_after_discount)"
            PaymentVC.couponId = "\(viewModel.selectedCoupon!.id)"
            return indexPath
        }
        else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        showPaymentMethods()
    }
}


//MARK: action sheet

//        let alert = UIAlertController(title: "PAYMENT", message: "Please Select payment Option", preferredStyle: .actionSheet)
//
//            alert.addAction(UIAlertAction(title: "VISA", style: .default , handler:{ (UIAlertAction)in
//                print("User click Approve button")
//            }))
//
//            alert.addAction(UIAlertAction(title: "STCpay", style: .default , handler:{ (UIAlertAction)in
//                print("User click Edit button")
//            }))
//
//            alert.addAction(UIAlertAction(title: "WALLET", style: .destructive , handler:{ (UIAlertAction)in
//                print("User click Delete button")
//            }))
//
//            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
//                print("User click Dismiss button")
//            }))
//
//
//            //uncomment for iPad Support
//            //alert.popoverPresentationController?.sourceView = self.view
//
//            self.present(alert, animated: true, completion: {
//                print("completion block")
//            })
