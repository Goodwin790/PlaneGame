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
    private var animationImages: [UIImage] = []
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
        for i in 1...3 {
            if let image = UIImage(named: "Plane\(i)") {
                animationImages.append(image)
            }
        }
        
        let imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        imageView.animationImages = animationImages
        imageView.animationDuration = 0.3
        imageView.animationRepeatCount = 0
        imageView.startAnimating()
    }

    func moveBy(x: CGFloat, y: CGFloat) {
        let newX = frame.origin.x + x
        let newY = frame.origin.y + y
        
        guard let superview = superview else { return }
        
        let maxX = superview.bounds.width - planeSize - .planeCrashMoment
        let maxY = superview.bounds.height - planeSize
        
        let clampedX = max(.planeCrashMoment, min(newX, maxX))
        let clampedY = max(0, min(newY, maxY))
        
        let newFrame = CGRect(x: clampedX,
                              y: clampedY,
                              width: planeSize,
                              height: planeSize)
        
        
        
        for button in superview.subviews {
            if let _ = button as? Moveable, button.frame.intersects(newFrame) {
                return
            }
            
        }
        
        frame.origin.x = clampedX
        frame.origin.y = clampedY
    }
}
