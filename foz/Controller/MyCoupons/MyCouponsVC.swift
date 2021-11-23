//
//  MyCouponsVC.swift
//  foz
//
//  Created by Ahmed Medhat on 23/11/2021.
//

import UIKit

class MyCouponsVC: UIViewController {

    @IBOutlet weak var allCouponsTblView: UITableView!
    @IBOutlet weak var marketCouponsTblView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var currentBalanceView: UIView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegateAndDataSource()
        initCurrentBalanceView()
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmentController(_ sender: Any) {
        switch segmentController.selectedSegmentIndex {
        case 0:
            allCouponsTblView.alpha = 1
            marketCouponsTblView.alpha = 0
        case 1:
            allCouponsTblView.alpha = 0
            marketCouponsTblView.alpha = 1
        default:
            break
        }
    }
    
    //call this func to set delegate and data source for table view
    func setDelegateAndDataSource() {
        allCouponsTblView.delegate = self
        marketCouponsTblView.delegate = self
        allCouponsTblView.dataSource = self
        marketCouponsTblView.dataSource = self
    }
    
    //call this func to customiz the current balance view
    func initCurrentBalanceView() {
        currentBalanceView.layer.cornerRadius = currentBalanceView.frame.height / 2 - 5
        currentBalanceView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        currentBalanceView.layer.borderWidth = 1.5
    }
    //call this func to show alert on screen
    func showAlert(message: String) {
        let alertvc = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertvc.addAction(UIAlertAction(title: "ok", style: .default))
        present(alertvc, animated: true, completion: nil)
    }
}


extension MyCouponsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}
