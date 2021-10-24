//
//  ActiveAuctionVC.swift
//  foz
//
//  Created by Ahmed Medhat on 06/09/2021.
//

import UIKit
import AVFoundation
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
    
    @IBOutlet weak var videoView: CustomRoundedView!
    @IBOutlet weak var completeWatchingBtn: UIButton!
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var timer = Timer()
    var transparentView = UIView()
    let image = UIImageView()
    var auctionId = ""
    static var activeAuctionVideoUrl = ""
    static var adId = ""
    lazy var viewModel: ActiveAuctionViewModel = {
        return ActiveAuctionViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        progressBar.progress = 1.0
//        let auctionVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "auction_vc_id") as! AuctionsVC
//        auctionVC.sideSelectionDelegate = self
        initFetchData()
        initAdVideoView(videoUrl: ActiveAuctionVC.activeAuctionVideoUrl)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = videoView.bounds
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        player.pause()
        dismiss(animated: true, completion: nil)
    }
    
    func initAdVideoView(videoUrl: String) {
        videoView.alpha = 0
        completeWatchingBtn.alpha = 0
        //https://192.168.1.217/macber/laravel/fooooooz/storage/ads/videos/default.mp4
//        "https://content.jwplatform.com/manifests/vM7nH0Kl.m3u8"
        if let adsurl = URL(string: videoUrl) {
            self.player = AVPlayer(url: adsurl)
            self.playerLayer = AVPlayerLayer(player: self.player)
            self.playerLayer.videoGravity = .resize
            self.videoView.layer.addSublayer(self.playerLayer)
            self.videoView.addSubview(completeWatchingBtn)
            self.player.play()
            self.player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main, using: { (time) in
                    if self.player!.currentItem?.status == .readyToPlay {
                        self.videoView.alpha = 1
                        let duration = self.player!.currentItem?.duration.seconds
//                        self.adSecondCounter = Int(duration!)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3 ) { [self] in
                            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                                completeWatchingBtn.alpha = 1
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
    
    func initFetchData() {
        viewModel.showAlertClosure = { [weak self] in
            
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert(message)
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                switch self!.viewModel.state {
                    case .error, .empty:
                    UIView.animate(withDuration: 1.2) {
                            self!.scrollView.alpha = 0
                        }
                        self!.spinner.stopAnimating()
                        
                    case .loading:
                    UIView.animate(withDuration: 1.2) {
                            self!.scrollView.alpha = 0
                        }
                        self!.spinner.startAnimating()
                        
                    case .populated:
                    UIView.animate(withDuration: 1.2) {
                            self!.scrollView.alpha = 1
                        }
                        self!.spinner.stopAnimating()
                        
                        self?.productName.text = self!.viewModel.activeAuctionData?.data.auction.title
                        
                        self?.productDescription.text = self!.viewModel.activeAuctionData?.data.auction.description
                        self?.productImage.sd_setImage(with: URL(string: (self!.viewModel.activeAuctionData?.data.auction.image_url)!))
                        self?.lastBidValue.text = "\(self!.viewModel.activeAuctionData!.data.last_bid.amount)"
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
    
    @IBAction func completeWatchingBtnPressed(_ sender: Any) {
        viewModel.showAlertClosure = { [weak self] in
            
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert(message)
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                switch self!.viewModel.state {
                    case .error, .empty:
                        self!.spinner.stopAnimating()
                        
                    case .loading:
                        self!.spinner.startAnimating()
                        
                    case .populated:
                        if let message = self?.viewModel.alertMessage {
                            self?.showAlert(message)
                        }
                        self!.spinner.stopAnimating()
                }
            }
        }
        viewModel.completeWatchingVideoAd(adID: ActiveAuctionVC.adId)
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
