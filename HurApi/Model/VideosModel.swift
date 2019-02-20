//
//  VideosModel.swift
//  HurApi
//
//  Created by Buse ERKUŞ on 25.11.2018.
//  Copyright © 2018 Buse ERKUŞ. All rights reserved.
//

import Foundation

class VideosModel{
    
    var id: String
    var desc : String
    var videoUrl: String
    
    init(id: String, desc: String, videoUrl:String) {
        self.id = id
        self.desc = desc
        self.videoUrl = videoUrl
    }
    
}
