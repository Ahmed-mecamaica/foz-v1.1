//
//  ViewController.swift
//  foz
//
//  Created by Ahmed Medhat on 15/08/2021.
//

import UIKit

class IntroVC: UIViewController {

    @IBOutlet weak var holderView: UIView!
    
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        congigure()
    }
    
    private func congigure() {
        // set up scrollView
        scrollView.frame =  holderView.bounds
        holderView.addSubview(scrollView)
        let titleArray = ["شارك في مئات المزادات", "عش اسهل تجربة للمزايدة اونلاين", "إستمتع بهدايا و كوبونات خصم يومية"]
        let subTitleArray = ["يمكنك المشاركة في كل المزادات على مدار اليوم بكل سهولة و يسر", "سهولة إتمام عملياتك للمزايدة و الدفع الإلكتروني", "إستفد بكوبونات خصم مع إمكانية الربح من بيعها"]
        for x in 0 ..< 3 {
            let pageView = UIView(frame: CGRect(x: CGFloat(x) * holderView.frame.size.width, y: 0, width: holderView.frame.size.width, height: holderView.frame.size.height))
            scrollView.addSubview(pageView)
            
            //title, image, button
            let backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: holderView.frame.width, height: holderView.frame.height))
            let imageView = UIImageView(frame: CGRect(x: 10, y: 50, width: pageView.frame.size.width - 20, height: 350))
            let title = UILabel(frame: CGRect(x: (pageView.frame.size.width/2) - 125, y: imageView.frame.size.height + 50, width: 270, height: 200))
            let subTitle = UILabel(frame: CGRect(x: (pageView.frame.size.width/2) - 125, y: imageView.frame.size.height + 130, width: 250, height: 200))
            let button = UIButton(frame: CGRect(x: 10, y: pageView.frame.size.height - 170, width: pageView.frame.size.width - 20, height: 60))
            let pageControl = UIPageControl(frame: CGRect(x: 10, y: pageView.frame.size.height - 100, width: pageView.frame.size.width - 20, height: 60))
            
            //background image
            backgroundImage.contentMode = .scaleAspectFit
            backgroundImage.image = UIImage(named: "intro_background_\(x+1)")
            pageView.addSubview(backgroundImage)
            
            //title
            title.textAlignment = .center
            title.numberOfLines = 0
            title.font = UIFont(name: "Cairo-SemiBold", size: 30)
            title.textColor = .white
            title.text = titleArray[x]
            pageView.addSubview(title)
            
            //subtitle
            subTitle.textAlignment = .center
            subTitle.font = UIFont(name: "Cairo-Light", size: 16)
            subTitle.numberOfLines = 0
            subTitle.textColor = .white
            subTitle.text = subTitleArray[x]
            pageView.addSubview(subTitle)
            subTitle.leadingAnchor.constraint(equalTo: pageView.leadingAnchor, constant: 40).isActive = true
            subTitle.trailingAnchor.constraint(equalTo: pageView.trailingAnchor, constant: 40).isActive = true
            
            
            //image
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "intro_\(x+1)")
            pageView.addSubview(imageView)
            
            //button
            button.tag = x + 1
            button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            button.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.6156862745, blue: 0.007843137255, alpha: 1)
            button.layer.cornerRadius = button.frame.size.height / 2
            button.setTitle("التالي", for: .normal)
            if x == 2 {
                button.setTitle("إبدأ", for: .normal)
                title.textColor = #colorLiteral(red: 0.1764705882, green: 0.7333333333, blue: 0.3294117647, alpha: 1)
            }
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            pageView.addSubview(button)
            
            //page control
            pageControl.numberOfPages = 3
            pageControl.currentPage = x
            pageView.addSubview(pageControl)
        }
        scrollView.contentSize = CGSize(width: holderView.frame.size.width * 3, height: 0)
        scrollView.isPagingEnabled = true
    }
    
    @objc func didTapButton(_ button: UIButton) {
        guard button.tag < 4 else {
            //dismiss
            return
        }
        if button.titleLabel?.text == "إبدأ" {
            let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
            let loginVC = storyboard.instantiateViewController(identifier: "login_view_controller") as! LoginVC
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: true)
        } else {
            //scroll to next page
            scrollView.setContentOffset(CGPoint(x: holderView.frame.size.width * CGFloat(button.tag), y: 0), animated: true)
        }
    }

}

