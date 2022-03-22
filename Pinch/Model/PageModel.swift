//
//  PageModel.swift
//  Pinch
//
//  Created by Anuj Soni on 22/03/22.
//

import Foundation

struct Page : Identifiable{
let id : Int
let imageName : String
}


extension Page{
var thumbnailImageName:String{
"thumb-\(self.imageName)"
}
}
