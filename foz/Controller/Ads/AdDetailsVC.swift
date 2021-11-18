//
//  AdDetailsVC.swift
//  foz
//
//  Created by Ahmed Medhat on 18/11/2021.
//

import UIKit
import SDWebImage
import AVFoundation

class AdDetailsVC: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var pageTitleLbl: UILabel!
    @IBOutlet weak var headerAdPhoto: UIImageView!
    @IBOutlet weak var providerLogoImage: UIImageView!
    @IBOutlet weak var adDescriptionLbl: UILabel!
    @IBOutlet weak var adHolderView: CustomRoundedView!
    @IBOutlet weak var showVidCompleteBtn: UIButton!
    
    static var adId = ""
    
    lazy var viewModel: AdDetailsViewModel = {
        return AdDetailsViewModel()
    }()
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    static var adVideoUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAdsDetails()
        initAdVideoView(videoUrl: AdDetailsVC.adVideoUrl)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAlphaForComponent(alpha: 0)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = adHolderView.bounds
    }
    
    //this func to control alpha for component of controller
    func setAlphaForComponent(alpha: CGFloat) {
        headerAdPhoto.alpha = alpha
        providerLogoImage.alpha = alpha
        adDescriptionLbl.alpha = alpha
        adHolderView.alpha = alpha
    }
    
    func fetchAdsDetails() {
        
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
                            self!.setAlphaForComponent(alpha: 0)
                        }
                            
                        case .populated:
                            self!.spinner.stopAnimating()
                        
                            if let adData = self!.viewModel.adDetails {
                                self!.adDescriptionLbl.text = adData.description
                                self!.providerLogoImage.sd_setImage(with: URL(string: adData.ad_logo))
                                print("ad logo: \(adData.ad_logo)")
                            }
                        
                            if let adPhoto = self!.viewModel.adsPhotoData {
                                self!.headerAdPhoto.sd_setImage(with: URL(string: adPhoto.image_url))
                            }
                            UIView.animate(withDuration: 0.5) {
                                self!.setAlphaForComponent(alpha: 1)
                            }
                            
                        case .loading:
                            self!.spinner.startAnimating()
                            UIView.animate(withDuration: 0.5) {
                                self!.setAlphaForComponent(alpha: 0)
                            }
                        }
                }
            }
        viewModel.initFetchAdDataData(adId: AdDetailsVC.adId)
        viewModel.initAdsPhoto()
    }
    
    func initAdVideoView(videoUrl: String) {
        adHolderView.alpha = 0
        showVidCompleteBtn.alpha = 0
        //https://192.168.1.217/macber/laravel/fooooooz/storage/ads/videos/default.mp4
//        "https://content.jwplatform.com/manifests/vM7nH0Kl.m3u8"
        if let adsurl = URL(string: videoUrl) {
            self.player = AVPlayer(url: adsurl)
            self.playerLayer = AVPlayerLayer(player: self.player)
            self.playerLayer.videoGravity = .resize
            self.adHolderView.layer.addSublayer(self.playerLayer)
            self.adHolderView.addSubview(showVidCompleteBtn)
            self.player.play()
            self.player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main, using: { (time) in
                    if self.player!.currentItem?.status == .readyToPlay {
                        self.adHolderView.alpha = 1
                        let duration = self.player!.currentItem?.duration.seconds
//                        self.adSecondCounter = Int(duration!)
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration! ) { [self] in
                            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                                showVidCompleteBtn.alpha = 1
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
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showVidCompleteBtnPressed(_ sender: Any) {
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
