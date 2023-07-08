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

class PlanePicker: UIViewController {
        var imageView: UIImageView?
        
        var images = [UIImage(named: "image1"), UIImage(named: "image2"), UIImage(named: "image3")]
        var currentIndex = 0
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let imageX = (view.bounds.width - .imageSideSize) / 2
            let imageY = (view.bounds.height - .imageSideSize) / 2
            
            imageView = UIImageView(frame: CGRect(x: imageX, y: imageY, width: .imageSideSize, height: .imageSideSize))
            guard let imageView = imageView else { return }
            
            imageView.contentMode = .scaleToFill
            imageView.image = images[currentIndex]
            view.addSubview(imageView)
            
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            swipeLeft.direction = .left
            view.addGestureRecognizer(swipeLeft)
            
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            swipeRight.direction = .right
            view.addGestureRecognizer(swipeRight)
        }
        
        @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
            switch gesture.direction {
            case .left:
                currentIndex += 1
                if currentIndex >= images.count {
                    currentIndex = 0
                }
                animateImage(from: imageView.frame.origin.x, to: -view.bounds.width - imageView.bounds.width / 2, moveCurrentImage: false)
            case .right:
                currentIndex -= 1
                if currentIndex < 0 {
                    currentIndex = images.count - 1
                }
                animateImage(from: imageView.bounds.maxX, to: view.bounds.width, moveCurrentImage: true)
            default:
                break
            }
        }
        
        func animateImage(from startX: CGFloat, to endX: CGFloat, moveCurrentImage: Bool) {
            let nextImageView = UIImageView(frame: CGRect(x: startX, y: imageView.frame.origin.y, width: imageView.bounds.width, height: imageView.bounds.height))
            nextImageView.contentMode = .scaleToFill
            nextImageView.image = images[currentIndex]
            view.addSubview(nextImageView)
            
            UIView.animate(withDuration: 0.3, animations: { [self] in
                nextImageView.frame.origin.x = endX
                imageView.frame.origin.x = startX - (endX - startX)
            }) { [self] _ in
                if moveCurrentImage {
                    imageView.image = images[currentIndex]
                }
                nextImageView.removeFromSuperview()
            }
        }
    }

