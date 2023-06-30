//
//  ViewController.swift
//  PlainGame
//
//  Created by Сергей Киров on 15.06.2023.
//

import UIKit

private extension CGFloat {
    static let dangerBorder = 70.0
    static let seam = 5.0
    static let scale = 1.0
    static let ufoStep = 1.0
}

private extension TimeInterval {
    static let interval = 0.005
}

class ViewController: UIViewController {
    
    private var planeIsCrash = false
    private var planeView: PlaneView!
    private var firstUfoView: UfoView!
    private var secondUfoView: UfoView!
    private var leftMountainsFirstImage: UIImageView!
    private var leftMountainsSecondImage: UIImageView!
    private var rightMountainsFirstImage: UIImageView!
    private var rightMountainsSecondImage: UIImageView!    
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var shootGesture: UITapGestureRecognizer?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLandscape()
        setupFlyingViews()
        setupPlaneGestureRecognizers()
        
    }
    
    private func setupPlaneGestureRecognizers() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        planeView.addGestureRecognizer(panGestureRecognizer)
        shootGesture = UITapGestureRecognizer(target: self, action: #selector(shoot(_:)))
        guard let shootGesture = shootGesture else { return }
        planeView.addGestureRecognizer(shootGesture)
    }

    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: view)
        
        switch gestureRecognizer.state {
        case .began, .changed:
            planeView.moveBy(x: translation.x, y: translation.y)
            gestureRecognizer.setTranslation(.zero, in: view)
        default:
            break
        }
    }
    
    @objc private func shoot(_ gestureRecognizer: UITapGestureRecognizer) {
        let pulit = Pulit(planeView: planeView)
        view.addSubview(pulit)
        pulit.startAnimation()
    }
    
    private func setupFlyingViews() {
        planeView = PlaneView(frame: view.bounds)
        firstUfoView = UfoView(frame: view.bounds)
        secondUfoView = UfoView(frame: view.bounds)
        view.addSubview(planeView)
        view.addSubview(firstUfoView)
        view.addSubview(secondUfoView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.animateUfo(ufoView: self.secondUfoView)
        }
        animateUfo(ufoView: firstUfoView)
        
    }
    
    private func setupLandscape() {
        let mountainsFirstImage = UIImageView(image: UIImage(named: "Mountains"))
        mountainsFirstImage.frame = view.bounds
        view.addSubview(mountainsFirstImage)
        
        let mountainSecondImage = UIImageView(image: UIImage(named: "Mountains"))
        mountainSecondImage.frame = view.bounds
        mountainSecondImage.frame.origin.y = -view.bounds.height
        mountainSecondImage.transform = CGAffineTransform(scaleX: .scale, y: -.scale)
        view.addSubview(mountainSecondImage)
        
        let landscapeFrame = CGRect(
            x: view.frame.origin.x + .dangerBorder,
            y: view.frame.origin.y,
            width: view.frame.width - .dangerBorder * 2,
            height: view.frame.height)
        
        let landscapeFirstImage = UIImageView(image: UIImage(named: "Landscape"))
        landscapeFirstImage.frame = landscapeFrame
        view.addSubview(landscapeFirstImage)
        
        let landscapeSecondImage = UIImageView(image: UIImage(named: "Landscape"))
        landscapeSecondImage.frame = landscapeFrame
        landscapeSecondImage.frame.origin.y = -view.bounds.height
        landscapeSecondImage.transform = CGAffineTransform(scaleX: .scale, y: -.scale)
        view.addSubview(landscapeSecondImage)
        
        animateLandscape(landscapeFirstImage, landscapeSecondImage)
        animateLandscape(mountainsFirstImage, mountainSecondImage)
    }
    
    func animateLandscape(_ firstImage: UIImageView, _ secondImage: UIImageView){
        let _ = Timer.scheduledTimer(withTimeInterval: .interval, repeats: true) { timer in
            self.isPlaneCrash()
            firstImage.frame.origin.y += .scale
            secondImage.frame.origin.y += .scale
            if (firstImage.layer.presentation()?.frame.origin.y) == self.view.bounds.origin.y {
                secondImage.frame.origin.y = -self.view.frame.height + .seam
            }
            if (secondImage.layer.presentation()?.frame.origin.y) == self.view.bounds.origin.y {
                firstImage.frame.origin.y = -self.view.frame.height + .seam
            }
            if self.planeIsCrash {
                timer.invalidate()
            }
        }
    }
    
    func animateUfo(ufoView: UfoView) {
        let minXUfo = view.frame.minX + .dangerBorder
        let maxXUfo = view.frame.maxX - .dangerBorder - ufoView.frame.width
        Timer.scheduledTimer(withTimeInterval: 0.005, repeats: true) {timer in
            self.isUfoCrash(ufo: ufoView)
            ufoView.frame.origin.y += .ufoStep
            if ufoView.layer.presentation()?.frame.origin.y ?? -.dangerBorder >= self.view.bounds.maxY {
                ufoView.frame.origin.y = self.view.frame.minY - .dangerBorder
                ufoView.frame.origin.x = .random(
                    in:
                        minXUfo...maxXUfo)
            }
            if ufoView.frame.intersects(self.planeView.frame.insetBy(dx: 0.0, dy: 20)) {
                self.planeIsCrash = true
            }
            if self.planeIsCrash {
                timer.invalidate()
            }
        }
    }
    
    func isUfoCrash(ufo: UfoView) {
        for subView in view.subviews {
            if let pulit = subView as? Pulit {
                if pulit.frame.intersects(ufo.frame) {
                    pulit.removeFromSuperview()
                    ufo.frame.origin.y = -view.frame.height
                }
            }
        }
    }

    func isPlaneCrash() {
        if planeView.frame.minX <= .dangerBorder || planeView.frame.maxX >= self.view.frame.maxX - .dangerBorder {
            planeIsCrash = true
        }
    }
    
}

