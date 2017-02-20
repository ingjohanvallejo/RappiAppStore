//
//  App.swift
//  Rappi
//
//  Created by Johan Vallejo on 19/02/17.
//  Copyright © 2017 kijho. All rights reserved.
//

import Foundation

class App {
    let id : String?
    let name : String?
    let price : String?
    let summary : String?
    let artist : String?
    let categoryId : String?
    let image : String?

    init(id: String?, name: String?, price: String?, summary: String?, artist: String?, categoryId: String?, image: String?) {
        self.id = id
        self.name = name
        self.price = price
        self.summary = summary
        self.artist = artist
        self.categoryId = categoryId
        self.image = image
    }

}
