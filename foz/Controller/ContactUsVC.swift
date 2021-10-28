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
    
    @IBOutlet weak var bottomConstraintOfsendMessageStackView: NSLayoutConstraint!
    
    lazy var viewModel: ContactUsMessageListViewModel = {
        return ContactUsMessageListViewModel()
    }()
    
    var isSendArray: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTblView.delegate = self
        messageTblView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        hideKeyboardWhenPanGestureAround()
        initFetchData()
    }
    
    //show keyboard
    @objc func keyboardWillShow(notification: Notification) {
        
        let keyboardSize = (notification.userInfo?  [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
//
         let keyboardHeight = keyboardSize?.height

         if #available(iOS 11.0, *){

            self.bottomConstraintOfsendMessageStackView.constant = keyboardHeight! + 20 //+ chatTxtField.frame.size.height//keyboardHeight! - view.safeAreaInsets.bottom
//             self.scrollTobottomCell()
          }
          else {
            self.bottomConstraintOfsendMessageStackView.constant = keyboardHeight! + 20 //+ chatTxtField.frame.size.height//keyboardHeight! - view.safeAreaInsets.bottom
//              self.scrollTobottomCell()
             }
        
           UIView.animate(withDuration: 0.5) {
               
              self.view.layoutIfNeeded()

           }
        self.scrollTobottomCell()
       }

    //hide keyboard
      @objc func keyboardWillHide(notification: Notification){

        self.bottomConstraintOfsendMessageStackView.constant = 30

           UIView.animate(withDuration: 0.5) {

              self.view.layoutIfNeeded()

           }
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
        
        viewModel.reloadCollectionViewClousure = { [weak self] () in
            self!.isSendArray = self!.viewModel.isSend
            DispatchQueue.main.async {
                self?.messageTblView.reloadData()
                self?.scrollTobottomCell()
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
            messageTxtField.text = ""
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.initFetchData()
            }
        }
    }
    
}

extension ContactUsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contactUsMessageNumberOfCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if messageTblView.isDragging {
//
//        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ContactUsCell
        if isSendArray[indexPath.row] == "send" {
            cell.messageLeadingConstraint.constant = 5
            cell.messageTrailingConstraint.constant = 40
            cell.messageBackgroundView.backgroundColor = #colorLiteral(red: 0.0002558765991, green: 0.6109670997, blue: 0.5671326518, alpha: 1)
        }
        else  {
            cell.messageLeadingConstraint.constant = 40
            cell.messageTrailingConstraint.constant = 5
            cell.messageBackgroundView.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)

        }

        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.contactUsMessageCellViewModel = cellVM
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 400
//    }
    
    private func scrollTobottomCell() {
        if viewModel.contactUsMessageNumberOfCell != 0 {
            let bottomCell = IndexPath(row: viewModel.contactUsMessageNumberOfCell - 1, section: 0)
            messageTblView.scrollToRow(at: bottomCell, at: .top, animated: true)
            messageTblView.layoutIfNeeded()
        }
        
    }
}
