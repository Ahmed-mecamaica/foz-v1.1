//
//  TermsAndConditionVC.swift
//  foz
//
//  Created by Ahmed Medhat on 17/10/2021.
//

import UIKit

class TermsAndConditionVC: UIViewController {

    @IBOutlet weak var termsAndConditionTxtView: UITextView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    lazy var viewModel: TermsAndConditionViewModel = {
        return TermsAndConditionViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initFetchDescription()
    }
    
    func initFetchDescription() {
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
                guard let self = self else {
                    return
                }
                switch self.viewModel.state {
                    case .empty, .error:
                        self.spinner.stopAnimating()
                    UIView.animate(withDuration: 0.5) {
                            self.termsAndConditionTxtView.alpha = 0
                            
                        }
                        
                    case .populated:
                        self.spinner.stopAnimating()
                        
                        UIView.animate(withDuration: 0.5) {
                            self.termsAndConditionTxtView.alpha = 1
                        }
                        
                    case .loading:
                        self.spinner.startAnimating()
                        UIView.animate(withDuration: 0.5) {
                            self.termsAndConditionTxtView.alpha = 0
                        }
                    }
            }
        }
        viewModel.initFetchData { [weak self] description in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.termsAndConditionTxtView.text = description
            }
            
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
