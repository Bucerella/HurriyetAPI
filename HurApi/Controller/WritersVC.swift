//
//  WritersVC.swift
//  HurApi
//
//  Created by Buse ERKUŞ on 24.11.2018.
//  Copyright © 2018 Buse ERKUŞ. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class WritersVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
   
    let mainView : UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let tableView : UITableView = {
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
        tableView.register(WritersCell.self, forCellReuseIdentifier: "WritersCell")
    }
    
    let apikey = "5697e0baec844cf292078399c9630290"
    var writers : [WritersModel] = []
    
    func getWriters() {
        let url = URL(string: "https://api.hurriyet.com.tr/v1/writers?$top=20")!
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
                
                let jsonArray = try JSONSerialization.jsonObject(with: data
                    , options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                
                if self.writers.count != 0{
                    self.writers.removeAll()
                }
             
                for veri in jsonArray {
                
                    let jsonObj = veri as! [String:Any]
                    
                     var imageUrl : String = "not"
                    let wid = jsonObj["Id"] as! String 
                    let wName = jsonObj["Fullname"] as! String
                    let wImage = jsonObj["Files"] as! [[String:Any]]
                    
                    if wImage.count != 0{
                        let fileJsonObj = wImage[0]
                        imageUrl = fileJsonObj["FileUrl"] as! String
                    }
                    
                    
                    self.writers.append(WritersModel(id: wid, writersmage: imageUrl, writersname: wName))
                    
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch{}
        }
        dataTask.resume()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        getWriters()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return writers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = writers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "WritersCell") as! WritersCell
        cell.setData(model: model)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        //tableview'in otomatik boyutunu belirttik.
    }
    
    class WritersCell : UITableViewCell {
        
        let mainView : UIView = {
           let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        let writerImage : UIImageView = {
            let img = UIImageView()
            img.contentMode = .scaleAspectFill
            img.translatesAutoresizingMaskIntoConstraints = false
            return img
        }()
        let writerName : UILabel = {
           let name = UILabel()
            name.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.semibold)
            //name.textColor = UIColor(rgb : 0x454545)
            name.translatesAutoresizingMaskIntoConstraints = false
            name.numberOfLines = 0
            return name
        }()
        let stackView : UIStackView = {
            let sv = UIStackView()
            sv.translatesAutoresizingMaskIntoConstraints = false
            sv.alignment = .fill
            sv.distribution = .fillProportionally
            sv.spacing = 16.0
            sv.axis = .horizontal
            
            return sv
        }()
        
        func setupUI() {
            addSubview(mainView)
            mainView.addSubview(stackView)
            stackView.addArrangedSubview(writerImage)
            stackView.addArrangedSubview(writerName)
            
            mainView.snp.makeConstraints { (make) in
                make.size.equalToSuperview()
            }
            
            stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            stackView.isLayoutMarginsRelativeArrangement = true
            
            stackView.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.right.equalToSuperview()
                make.left.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            
            writerImage.snp.makeConstraints { (make) in
                make.height.equalTo(54)
                make.width.equalTo(54)
            }
            
            writerImage.layer.borderWidth = 0
            writerImage.layer.masksToBounds = false
            writerImage.layer.cornerRadius = 27.0
            writerImage.clipsToBounds = true
            
            
            
        }
        
        func setData(model : WritersModel){
            
            writerName.text = model.writersname
            
            if model.writersmage == "not" {
                writerImage.image = UIImage(named: "hh_placeholder")
            }else{
                let imageURL = URL(string: model.writersmage)!
                writerImage.kf.setImage(with: imageURL)
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
    
    
}




