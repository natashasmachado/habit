//
//  APIService.swift
//  Habits
//
//  Created by Natasha Machado on 2023-05-25.
//

import Foundation

struct HabitRequest: APIRequest {
  
  typealias Response = [String: Habit]
  var habitName: String?
  var path: String { "/habits" }
  
  
  extension Color: Codable {
    enum CodingKeys: String, CodingKey {
      case hue = "h"
      case saturation = "s"
      case brightness = "b"
    }
  }
  
  extension Category: Codable { }
  extension Habit: Codable { }
}
