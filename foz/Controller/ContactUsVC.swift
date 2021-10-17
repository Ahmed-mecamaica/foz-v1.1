//
//  CotactUsVC.swift
//  foz
//
//  Created by Ahmed Medhat on 14/10/2021.
//

import UIKit

class ContactUsVC: UIViewController {

    @IBOutlet weak var messageTblView: UITableView!
    
    @IBOutlet weak var messageTxtField: UITextField!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    lazy var viewModel: ContactUsMessageListViewModel = {
        return ContactUsMessageListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTblView.delegate = self
        messageTblView.dataSource = self
        // Do any additional setup after loading the view.
        initFetchData()
    }
    
    func initFetchData() {
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
                        UIView.animate(withDuration: 2) {
                            self!.messageTblView.alpha = 0
                            
                        }
                        
                    case .populated:
                        self!.spinner.stopAnimating()
                        self!.messageTblView.reloadData()
                        UIView.animate(withDuration: 2) {
                            self!.messageTblView.alpha = 1
                        }
                        
                    case .loading:
                        self!.spinner.startAnimating()
                        UIView.animate(withDuration: 2) {
                            self!.messageTblView.alpha = 0
                        }
                    }
            }
        }
        viewModel.initFetchMessageData()
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func countLines(of label: UILabel, maxHeight: CGFloat) -> Int {
            // viewDidLayoutSubviews() in ViewController or layoutIfNeeded() in view subclass
            guard let labelText = label.text else {
                return 0
            }
            
            let rect = CGSize(width: label.bounds.width, height: maxHeight)
            let labelSize = labelText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font!], context: nil)
            
            let lines = Int(ceil(CGFloat(labelSize.height) / label.font.lineHeight))
            return labelText.contains("\n") && lines == 1 ? lines + 1 : lines
       }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendMessageBtnTapped(_ sender: Any) {
        if messageTxtField.text != "" {
            viewModel.initSendMessage(message: messageTxtField.text!)
            initFetchData()
            messageTxtField.text = ""
        }
    }
    
}

extension ContactUsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contactUsMessageNumberOfCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ContactUsCell
        if cell.contactUsMessageCellViewModel?.status == "recive" {
            cell.messageLeadingConstraint.constant = 40
            cell.messageTrailingConstraint.constant = 5
        }
        else {
            cell.messageLeadingConstraint.constant = 5
            cell.messageTrailingConstraint.constant = 40
        }
        cell.messageLbl.backgroundColor = .magenta
        cell.messageLbl.layer.cornerRadius = 5
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.contactUsMessageCellViewModel = cellVM
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 400
//    }
}
