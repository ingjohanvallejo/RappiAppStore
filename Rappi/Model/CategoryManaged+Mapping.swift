//
//  CategoryManaged+Mapping.swift
//  Rappi
//
//  Created by Johan Vallejo on 19/02/17.
//  Copyright © 2017 kijho. All rights reserved.
//

import Foundation

extension CategoryManaged {
    func mappedObject() -> CategoryApp {
        return CategoryApp(id: self.id, name: self.name)
    }
}
