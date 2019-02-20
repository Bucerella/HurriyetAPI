//
//  NewsModel.swift
//  HurApi
//
//  Created by Buse ERKUŞ on 21.11.2018.
//  Copyright © 2018 Buse ERKUŞ. All rights reserved.
//

import Foundation

class NewsModel {
    
    var id : String
    var image : String
    var title : String
    
    init(id : String, image : String, title: String){
        self.id = id
        self.image = image
        self.title = title
    }
    
}
