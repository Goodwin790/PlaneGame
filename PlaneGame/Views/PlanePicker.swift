//
//  PlanePicker.swift
//  PlaneGame
//
//  Created by Сергей Киров on 06.07.2023.
//

import UIKit

private extension CGFloat {
    static let imageSideSize: CGFloat = 300.0
}

class PlanePicker: UIView {
    var imageView: UIImageView?
    var nextImageView: UIImageView?
    
    var images = [UIImage(named: "Plane1"), UIImage(named: "Plane2"), UIImage(named: "Plane3"), UIImage(named: "Plane4"), UIImage(named: "Plane5")]
    var currentIndex = 0
    
    var selectedImage: UIImage? {
        return images[currentIndex]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        addGestureRecognizer(swipeRight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupImageView()
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        guard let imageView = imageView else { return }
        switch gesture.direction {
        case .left:
            currentIndex += 1
            if currentIndex >= images.count {
                currentIndex = 0
            }
            animateImage(
                from: imageView.frame.width * 2,
                to: imageView.frame.origin.x,
                moveCurrentImage: true)
        case .right:
            currentIndex -= 1
            if currentIndex < 0 {
                currentIndex = images.count - 1
            }
            animateImage(
                from: -imageView.frame.width * 2,
                to: imageView.frame.origin.x,
                moveCurrentImage: true)
        default:
            break
        }
    }
    
    private func animateImage(from startX: CGFloat, to endX: CGFloat, moveCurrentImage: Bool) {
        guard let imageView = imageView else { return }
        let nextImageView = UIImageView(frame: CGRect(x: startX, y: 0, width: bounds.width, height: bounds.height))
        nextImageView.contentMode = .scaleToFill
        nextImageView.image = images[currentIndex]
        addSubview(nextImageView)
        
        UIView.animate(withDuration: 0.3, animations: {
            nextImageView.frame.origin.x = endX
        }) { [self] _ in
            if moveCurrentImage {
                imageView.image = images[currentIndex]
            }
            nextImageView.removeFromSuperview()
        }
    }
    
    private func setupImageView() {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        guard let imageView = imageView else { return }
        imageView.contentMode = .scaleToFill
        imageView.image = images[currentIndex]
        addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let imageView = imageView else { return }
        imageView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
    }
    
    func updateImage(image: UIImage?) {
        if let image = image {
            imageView?.image = image
        }
    }
    
}

