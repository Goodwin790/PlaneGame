//
//  Pulit.swift
//  PlaneGame
//
//  Created by Сергей Киров on 30.06.2023.
//

import UIKit

private extension CGFloat {
    static let pulitOffset = 7.0
    static let pulitSize = 15.0
    static let step = 20.0
}

class Pulit: UIView {

    init(planeView: UIView) {
        let pulitFrame = CGRect(x: planeView.frame.midX - .pulitOffset, y: planeView.frame.minY, width: .pulitSize, height: .pulitSize)
        super.init(frame: pulitFrame)
        
        backgroundColor = .orange
        layer.cornerRadius = .pulitSize / 2
    }
    
    func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            self.frame.origin.y -= .step
            if self.frame.origin.y < -.pulitSize {
                self.removeFromSuperview()
                timer.invalidate()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

