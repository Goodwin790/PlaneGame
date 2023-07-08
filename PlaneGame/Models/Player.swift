//
//  User.swift
//  PlaneGame
//
//  Created by Сергей Киров on 04.07.2023.
//

import Foundation

class Player: Codable {
    var photo: String
    let name: String
    var points: Int
    var plane: String
    var gameSpeed: Double
    
    init(photo: String, name: String, points: Int = 0, plane: String, gameSpeed: Double) {
        self.photo = photo
        self.name = name
        self.points = points
        self.plane = plane
        self.gameSpeed = gameSpeed
    }
}
