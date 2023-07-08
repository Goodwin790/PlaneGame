//
//  SaveManager.swift
//  PlaneGame
//
//  Created by Сергей Киров on 07.07.2023.
//

import Foundation
import UIKit

enum Keys: String {
    case player
    case records
}

class SaveManager {
    
    var records = [Player]()
        
    func savePlayer(player: Player) {
        UserDefaults.standard.set(encodable: player, forKey: Keys.player.rawValue)
    }
    
    func loadPlayer() -> Player? {
        UserDefaults.standard.value(Player.self, forKey: Keys.player.rawValue)
    }
    
    func saveRecord(player: Player) {
        records = loadRecords()
        records.append(player)
        UserDefaults.standard.set(encodable: records, forKey: Keys.records.rawValue)
        
    }
    
    func loadRecords() -> [Player] {
        
        if let savedRecords = UserDefaults.standard.value([Player].self, forKey: Keys.records.rawValue) {
            return savedRecords
        } else {
            return []
        }
    }
    
    func savePlayerPhoto(image: UIImage) -> String? {
           guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
           
           let fileName = UUID().uuidString
           let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return nil}
           
           if FileManager.default.fileExists(atPath: fileURL.path) {
               do {
                   try FileManager.default.removeItem(atPath: fileURL.path)
                   print("Removed old image")
               } catch let error {
                   print("couldn't remove file at path", error)
               }
               
           }
           
           do {
               try data.write(to: fileURL)
               return fileName
           } catch let error {
               print("error saving file with error", error)
               return nil
           }
           
       }
    
     func savePlaneImage(image: UIImage) -> String? {
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
            
            let fileName = UUID().uuidString
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            guard let data = image.pngData() else { return nil}
            
            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try FileManager.default.removeItem(atPath: fileURL.path)
                    print("Removed old image")
                } catch let error {
                    print("couldn't remove file at path", error)
                }
                
            }
            
            do {
                try data.write(to: fileURL)
                return fileName
            } catch let error {
                print("error saving file with error", error)
                return nil
            }
            
        }
    
    func loadImage(fileName: String) -> UIImage? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        let image = UIImage(contentsOfFile: fileURL.path)
        return image
    }
    
}

extension UserDefaults {
    
    func set<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key)
        }
    }
    
    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = object(forKey: key) as? Data,
            let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }
}
