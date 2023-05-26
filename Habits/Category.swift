//
//  Category.swift
//  Habits
//
//  Created by Natasha Machado on 2023-05-25.
//

import Foundation

struct Category {
    let name: String
    let color: Color
}


extension Category: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
 
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.name == rhs.name
    }
}
