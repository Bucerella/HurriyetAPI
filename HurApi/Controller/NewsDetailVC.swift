//
//  NewsDetailVC.swift
//  HurApi
//
//  Created by Buse ERKUŞ on 23.11.2018.
//  Copyright © 2018 Buse ERKUŞ. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class NewsDetailVC: UIViewController {

    let mainView : UIView = {
       
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    let scrollView : UIScrollView = {
       
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    let imageView : UIImageView = {
       
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        return img
    }()
    let newsTitle : UILabel = {
        
       let label = UILabel()
       label.translatesAutoresizingMaskIntoConstraints = false
       label.numberOfLines = 0
       label.font = UIFont.monospacedDigitSystemFont(ofSize: 20.0, weight: UIFont.Weight.bold)
       label.textAlignment = .center
       return label
    }()
    let newsDetail : UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 14.0, weight: UIFont.Weight.medium)
        label.textAlignment = .center
        return label
    }()
    let baseView : UIView = {
       
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    func setupUI(){
        
        self.view.addSubview(baseView)
        baseView.addSubview(scrollView)
        scrollView.addSubview(mainView)
        mainView.addSubview(imageView)
        mainView.addSubview(newsTitle)
        mainView.addSubview(newsDetail)
        
        baseView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        scrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        mainView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(scrollView.snp.height).priority(250)
            make.width.equalTo(scrollView.snp.width)
        }
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        self.imageView.clipsToBounds = true
        
        let aspectRatioConstraintX = NSLayoutConstraint(item: self.imageView,attribute: .height,relatedBy: .equal,toItem: self.imageView,attribute: .width,multiplier: (9.0 / 16.0), constant: 0)
        self.imageView.addConstraint(aspectRatioConstraintX)
        
        newsTitle.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.right.equalToSuperview().offset(-16)
            make.left.equalToSuperview().offset(16)
        }
        newsDetail.snp.makeConstraints { (make) in
            make.top.equalTo(newsTitle.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    
    var newsID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        getNewsDetail()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    let apikey = "5697e0baec844cf292078399c9630290"
    
    func getNewsDetail(){
        let url = URL(string: "https://api.hurriyet.com.tr/v1/articles/\(self.newsID)")!
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue(self.apikey, forHTTPHeaderField: "apikey")
        
        let dataTask = URLSession.shared.dataTask(with: req) { (data, response, error) in
            
            if error != nil {
                print("Error")
            }
            guard let data = data else{
                return
            }
            do{
                
                let rootJSONObj = try JSONSerialization.jsonObject(with: data
                    , options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,AnyObject>
                
                
                var img = "not"
                let files = rootJSONObj["Files"] as! [[String:Any]]
                
                if files.count != 0{
                    
                    let firstJsonObj = files[0]
                    let fileUrl = firstJsonObj["FileUrl"] as! String
                    img = fileUrl
                    
                }
                
                let _title = rootJSONObj["Title"] as! String
                let _desc = rootJSONObj["Text"] as! String
                
                //let encodedString = _desc.html2String
                
                DispatchQueue.main.async {
                    if img == "not"{
                        self.imageView.image = UIImage(named: "hh_placeholder")
                    }else{
                        
                        let imgURL = URL(string: img)!
                        self.imageView.kf.setImage(with: imgURL, placeholder: UIImage(named: "hh_placeholder"), options: [], progressBlock: nil, completionHandler: nil)
                    }
                    
                    self.newsTitle.text = _title
                    self.newsDetail.text = _desc.html2String
                    
                }
            }catch{
                
            }
        }
        dataTask.resume()
    }
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}


