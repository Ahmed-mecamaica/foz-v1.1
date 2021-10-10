//
//  DiscountVC.swift
//  foz
//
//  Created by Ahmed Medhat on 04/10/2021.
//

import UIKit

class DiscountVC: UIViewController {

    @IBOutlet weak var discountTblView: UITableView!
    @IBOutlet weak var paymentPopupView: UIView!
    @IBOutlet weak var buyBtnINPaymentView: BorderBtn!
    @IBOutlet weak var visaRadioBtn: UIImageView!
    @IBOutlet weak var stcRadioBtn: UIImageView!
    @IBOutlet weak var walletRadioBtn: UIImageView!
    @IBOutlet weak var paymentDonePopupView: CurveShadowView!
    
    let transparentView = UIView()
    
    let emptyRadioBtnImageName = "circle"
    let fillRadioBtnImageName = "circle.dashed.inset.fill"
    override func viewDidLoad() {
        super.viewDidLoad()

        discountTblView.delegate = self
        discountTblView.dataSource = self
       initPaymentView()
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
        UIView.animate(withDuration: 0.4) {
            self.paymentPopupView.alpha = 0
            self.paymentDonePopupView.alpha = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.removePaymentMethodView()
        }
    }
    
}

extension DiscountVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DiscountCell
        cell.lineOnPriceBeforDiscount.transform = CGAffineTransform(rotationAngle: -35)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        showPaymentMethods()
        
        
        //MARK:-action sheet
        
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
    }
}
