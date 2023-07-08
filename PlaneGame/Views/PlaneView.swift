//
//  CircleView.swift
//  CircleController
//
//  Created by Сергей Киров on 13.06.2023.
//

import UIKit

private extension CGFloat {
    static let planeSize = 90.0
    static let planeCrashMoment = 65.0
    static let animationFuration = 0.3
}

class PlaneView: UIView {
    private let planeSize: CGFloat = .planeSize
    private var imageView: UIImageView?
    private let saveManager = SaveManager()
    override init(frame: CGRect) {
        let newFrame = CGRect(x: frame.midX - planeSize / 2,
                              y: frame.midY ,
                              width: planeSize,
                              height: planeSize)
        super.init(frame: newFrame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        imageView = UIImageView(frame: bounds)
        guard let imageView = imageView else { return }
        let player = saveManager.loadPlayer()
        if let player = player {
            let image = saveManager.loadImage(fileName: player.plane)
            imageView.image = image
        } //else {
////            imageView.image = UIImage(named: "Plane1")
////        }
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
    }

    func moveBy(x: CGFloat, y: CGFloat) {
        let newX = frame.origin.x + x
        let newY = frame.origin.y + y
        
        guard let superview = superview else { return }
        
        let maxX = superview.bounds.width - planeSize - .planeCrashMoment
        let maxY = superview.bounds.height - planeSize
        
        let clampedX = max(.planeCrashMoment, min(newX, maxX))
        let clampedY = max(0, min(newY, maxY))

        frame.origin.x = clampedX
        frame.origin.y = clampedY
    }
}
