//
//  RegisterUserVC.swift
//  foz
//
//  Created by Ahmed Medhat on 23/08/2021.
//

import UIKit

class classCell: UITableViewCell {
    
}

class RegisterUserVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userNameTxtField: CurveTextField!
    @IBOutlet weak var birthDateTxtField: CurveTextField!
    @IBOutlet weak var genderBtn: RegisterUserBorderBtn!
    @IBOutlet weak var cityBtn: RegisterUserBorderBtn!
    @IBOutlet weak var incomLevelBtn: RegisterUserBorderBtn!
    @IBOutlet weak var registerBtn: BorderBtn!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let tableView = UITableView()
    let transparentView = UIView()
    let datePicker = UIDatePicker()
    var selectedButton = RegisterUserBorderBtn()
    var tableViewArray: [DropListData] = [DropListData]()
    var genderArray: [String] = [String]()
    
    let viewModel: RegisterUserViewModel = {
        return RegisterUserViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        birthDateTxtField.delegate = self
        tableView.separatorStyle = .none
        tableView.register(classCell.self, forCellReuseIdentifier: "cell")
        hideKeyboardWhenTappedAround()
        createDatePicker()
        initIncomeLevels()
    }
    
    func createDatePicker() {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        //assign toolbar
        birthDateTxtField.inputAccessoryView = toolbar
        
        //assign date picker to the text field
        birthDateTxtField.inputView = datePicker
        
        //date picker mode
        datePicker.calendar = .none
        datePicker.datePickerMode = .date
        
        //date picker style
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }

        @objc func donePressed() {
            //set format
            let formatter = DateFormatter()
//            let hijriCalendar = Calendar.init(identifier: Calendar.Identifier.islamicCivil)
             formatter.locale = Locale.init(identifier: "en") // "ar" or "en" as you want to show numbers

//             formatter.calendar = hijriCalendar

             formatter.dateFormat = "dd-MM-yyyy"
             print(formatter.string(from: Date()))
    //        formatter.dateStyle = .medium
    //        formatter.timeStyle = .none
            birthDateTxtField.text = formatter.string(from: datePicker.date)
    //        print(birthDateTxtField.text)
            self.view.endEditing(true)
            
        }
    
    func initIncomeLevels() {
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert(message: message)
                }
            }
        }
        
        viewModel.updateLoadingState = { [weak self] () in
            guard  let self = self else {
                return
            }
            DispatchQueue.main.async {
                switch self.viewModel.state {
                case .empty, .error:
                    self.activityIndicator.stopAnimating()
                case .loading:
                    self.activityIndicator.startAnimating()
                case .populated:
                    self.activityIndicator.stopAnimating()
                }
            }
            
        }
        viewModel.initIncomeLevels()
        viewModel.initCities()
    }
    
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "تنبية", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "موافق", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func genderBtnPressed(_ sender: Any) {
        tableViewArray = []
        genderArray = ["ذكر", "آنثى"]
        selectedButton = genderBtn
        addTransparentView(frame: genderBtn.frame)
    }
    
    @IBAction func cityBtnPressed(_ sender: Any) {
        tableViewArray = []
        tableViewArray = viewModel.cities
        selectedButton = cityBtn
        addTransparentView(frame: genderBtn.frame)
    }
    
    @IBAction func incomeLevelBtnPressed(_ sender: Any) {
        tableViewArray = []
        tableViewArray = viewModel.incomelevels
        selectedButton = incomLevelBtn
        addTransparentView(frame: genderBtn.frame)
    }
    
    @IBAction func registerBtnPressed(_ sender: Any) {
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert(message: message)
                }
            }
        }
        
        viewModel.updateLoadingState = { [weak self] () in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                switch self!.viewModel.state {
                case .error, .empty:
                    self?.activityIndicator.stopAnimating()
                case .loading:
                    self?.activityIndicator.startAnimating()
                case .populated:
                    self?.activityIndicator.stopAnimating()
                    let storyboard = UIStoryboard(name: "Main", bundle: .main)
                    let otpVC = storyboard.instantiateViewController(identifier: "interests-VC")
                    self?.present(otpVC, animated: true, completion: nil)
                }
            }
        }
        
        viewModel.initSignupUser(userName: userNameTxtField.text ?? "", birthDate: birthDateTxtField.text ?? "", city: cityBtn.titleLabel?.text ?? "", gender: genderBtn.titleLabel?.text ?? "", incomeLevel: incomLevelBtn.titleLabel?.text ?? "")
    }
    
    func addTransparentView(frame: CGRect) {
        self.transparentView.frame = self.view.frame
        self.view.addSubview(transparentView)
        self.tableView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        tableView.reloadData()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        UIView.animate(withDuration: 0.4, delay: 0.1, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: 65, y: frame.origin.y + 50, width: frame.width, height: CGFloat(self.genderArray.count*100))
        }, completion: nil)
        transparentView.addGestureRecognizer(tapGesture)
    }
    
    @objc func removeTransparentView() {
        let frame = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: 0)
        }, completion: nil)
    }

}

extension RegisterUserVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewArray.count == 0 {
            return genderArray.count
        }
        return tableViewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! classCell
        if tableViewArray.count == 0 {
            cell.textLabel?.text = genderArray[indexPath.row]
        }
        else {
            cell.textLabel?.text = tableViewArray[indexPath.row].name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableViewArray.count == 0 {
            selectedButton.setTitle(genderArray[indexPath.row], for: .normal)
            selectedButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        }
        else {
            selectedButton.setTitle(tableViewArray[indexPath.row].name, for: .normal)
            selectedButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        }
        removeTransparentView()
    }
}
