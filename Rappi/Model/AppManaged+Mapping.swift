//
//  AppManaged+Mapping.swift
//  Rappi
//
//  Created by Johan Vallejo on 19/02/17.
//  Copyright © 2017 kijho. All rights reserved.
//

import Foundation

extension AppManaged {
    func mappedObject() -> App {
        return App(id: self.id, name: self.name, price: self.price, summary: self.summary, artist: self.artist, categoryId: self.categoryId, image: self.image)
    }
}
