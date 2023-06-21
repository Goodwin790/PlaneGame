//
//  RightButton.swift
//  CircleController
//
//  Created by Сергей Киров on 13.06.2023.
//

import UIKit

class RightButton: UIButton, Moveable {
    weak var planeView: PlaneView?
    
    func move() {
        planeView?.moveBy(x: .step, y: 0)
    }
}
