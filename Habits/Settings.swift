//
//  Settings.swift
//  Habits
//
//  Created by Natasha Machado on 2023-05-25.
//

import Foundation

struct Settings {
  
    static var shared = Settings()
    private let defaults = UserDefaults.standard
}

private func archiveJSON<T: Encodable>(value: T, key: String) {
    let data = try! JSONEncoder().encode(value)
    let string = String(data: data, encoding: .utf8)
  defaults.set(string, forKey: key)
}

private func unarchiveJSON<T: Decodable>(key: String) -> T? {
    guard let string = defaults.string(forKey: key),
        let data = string.data(using: .utf8) else {
            return nil
    }
    return try! JSONDecoder().decode(T.self, from: data)
}


var favoriteHabits: [Habit] {
    get {
        return unarchiveJSON(key: "favoriteHabits") ?? []
    }
    set {
        archiveJSON(value: newValue, key: "favoriteHabits")
    }
}

enum Setting {
    static let favoriteHabits = "favoriteHabits"
}
