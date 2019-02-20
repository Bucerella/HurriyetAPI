//
//  NewsVC.swift
//  HurApi
//
//  Created by Buse ERKUŞ on 21.11.2018.
//  Copyright © 2018 Buse ERKUŞ. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class NewsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = news[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
        cell.setData(model:  model)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        //tableview'in otomatik boyutunu belirttik.
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = news[indexPath.row]
        self.news_id = model.id
        performSegue(withIdentifier: "goToDetail", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = "Geri"
        self.navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "goToDetail" {
            
            let vc = segue.destination as! NewsDetailVC
            vc.newsID = self.news_id
            
        }
    }
    
    var news_id = String()
    
    let apikey = "5697e0baec844cf292078399c9630290"
    var news : [NewsModel] = []
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "hh_logo")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        self.navigationItem.titleView = imageView
        
        
        
       setupUI()
       getNews()
    }
    
    func getNews(){
        let url = URL(string: "https://api.hurriyet.com.tr/v1/articles?$top=20")!
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue(apikey, forHTTPHeaderField: "apikey")
        
        let dataTask = URLSession.shared.dataTask(with: req){
            data, response, error in
            
            if error != nil {
                print("error = \(String(describing:error?.localizedDescription))")
            }
            guard let data = data else {
               
                return
            }
            do{
                let rootJSONArray = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                if rootJSONArray.count != 0{
                    self.news.removeAll()
                 }
                for d in rootJSONArray{
                    let jsonObj = d as! [String:Any]
                    
                    var fileURL : String = "not"
                    let _title = jsonObj["Title"] as! String
                    let _id = jsonObj["Id"] as! String
                    let _files = jsonObj["Files"] as! [[String:Any]] // Obje olarak alıyor.
                    
                    if _files.count != 0{
                        let filesJsonObj = _files[0]
                        fileURL = filesJsonObj["FileUrl"] as! String
                    }
                    self.news.append(NewsModel(id: _id,image: fileURL,title: _title))
                }
                
                DispatchQueue.main.async {
                    if self.refreshControl.isRefreshing{
                        self.refreshControl.endRefreshing()
                    }
                    self.tableView.reloadData()
                }
            }
            catch{
            
            }
        }
        dataTask.resume()
    }
    
    let mainView:UIView = {
       let view = UIView()
       view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    func setupUI(){
        self.view.addSubview(mainView)
        mainView.addSubview(tableView)
        
        mainView.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
        }
        tableView.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
        }
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        tableView.backgroundColor = UIColor(rgb: 0xebebeb)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsCell.self, forCellReuseIdentifier: "NewsCell")
        addRefreshControl()
    }
    
    func addRefreshControl() {
        refreshControl.tintColor = UIColor(rgb: 0xc54545)
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refreshList(){
        
        getNews()
        
    }
}


class NewsCell : UITableViewCell {
    
    let mainView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    
    }()
    
    let newsImage : UIImageView = {
       
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    
    }()
    
    let title : UILabel = {
       
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.bold)
        label.textColor = UIColor(rgb : 0x212121)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        //Satır sayısını kısıtlamamasını sağlamış olduk.
        return label
    }()
    
    let bottomView : UIView = {
       
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xc45454)
        view.alpha = 0.7
        return view
        
    }()
    
    func setupUI(){
        addSubview(mainView)
        mainView.addSubview(newsImage)
        mainView.addSubview(title)
        mainView.addSubview(bottomView)
        
        mainView.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
        }
        newsImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        let aspectRatioConstraintX = NSLayoutConstraint(item: self.newsImage,attribute: .height,relatedBy: .equal,toItem: self.newsImage,attribute: .width,multiplier: (9.0 / 16.0), constant: 0)
        self.newsImage.addConstraint(aspectRatioConstraintX)
        
        newsImage.clipsToBounds = true
        
        title.snp.makeConstraints { (make) in
            
        make.top.equalTo(newsImage.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(8)
            make.width.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview().offset(-10)
        }


    }
    
    func setData(model : NewsModel){
        
        title.text = model.title
        
        if model.image == "not" {
            newsImage.image = UIImage(named: "hh_placeholder")
        }else{
            let imageURL = URL(string: model.image)!
            newsImage.kf.setImage(with: imageURL)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Geçersiz red component")
        assert(green >= 0 && green <= 255, "Geçersiz green component")
        assert(blue >= 0 && blue <= 255, "Geçersiz blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}


