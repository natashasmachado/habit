//
//  Habit.swift
//  Habits
//
//  Created by Natasha Machado on 2023-05-25.
//

import Foundation


struct Habit {
    let name: String
    let category: Category
    let info: String
}

extension Habit: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
  
    static func == (lhs: Habit, rhs: Habit) -> Bool {
        return lhs.name == rhs.name
    }
}

extension Habit: Comparable {
    static func < (lhs: Habit, rhs: Habit) -> Bool {
        return lhs.name < rhs.name
    }
}
