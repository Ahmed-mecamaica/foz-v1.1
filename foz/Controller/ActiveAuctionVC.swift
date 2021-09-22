//
//  ActiveAuctionVC.swift
//  foz
//
//  Created by Ahmed Medhat on 06/09/2021.
//

import UIKit

class ActiveAuctionVC: UIViewController {

    @IBOutlet weak var progressBar: UIProgressView!
    
    var timer = Timer()
    var transparentView = UIView()
    let image = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()

        progressBar.progress = 1.0
        
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
