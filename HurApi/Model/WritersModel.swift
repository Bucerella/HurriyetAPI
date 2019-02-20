//
//  WritersModel.swift
//  HurApi
//
//  Created by Buse ERKUŞ on 24.11.2018.
//  Copyright © 2018 Buse ERKUŞ. All rights reserved.
//

import Foundation

class WritersModel {
    
    var id: String
    var writersmage:String
    var writersname:String
   
    init(id:String, writersmage:String, writersname:String) {
        self.id = id
        self.writersmage = writersmage
        self.writersname = writersname
    }
    
}
