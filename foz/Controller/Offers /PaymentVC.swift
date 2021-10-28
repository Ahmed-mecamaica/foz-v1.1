//
//  OffersVC.swift
//  foz
//
//  Created by Ahmed Medhat on 03/10/2021.
//

import UIKit
import WebKit

class PaymentVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    static var couponId = ""
    static var couponPrice = ""
    var userId = UserDefaults.standard.value(forKey: "user-id")
    static var screen = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://foz.qbizns.com/current/api/payment/check_out?coupon=\(PaymentVC.couponId)&price=\(PaymentVC.couponPrice)&user=\(userId!)&screen=\(PaymentVC.screen)")
        print("url is: \(url!)")
        let request = URLRequest(url: url!)
        webView.load(request)
        
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        PaymentVC.couponId = ""
        PaymentVC.couponPrice = ""
        PaymentVC.screen = ""
        dismiss(animated: true)
    }
    
    
}


