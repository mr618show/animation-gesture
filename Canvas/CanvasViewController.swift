//
//  ViewController.swift
//  Canvas
//
//  Created by Rui Mao on 3/30/18.
//  Copyright © 2018 Rui Mao. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var downArrow: UIImageView!
    @IBOutlet weak var trayView: UIView!
    var trayOriginalCenter: CGPoint!
    var trayCenterWhenOpen: CGPoint!
    var trayCenterWhenClosed: CGPoint!
    var newlyCreatedFace: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        trayCenterWhenOpen = CGPoint(x: trayView.center.x, y: trayView.frame.size.height/2)
        trayCenterWhenClosed = CGPoint(x: trayView.center.x, y: self.view.frame.height - trayView.frame.size.height/2)
    }

    @IBAction func onTrayPanGesture(_ recognizer: UIPanGestureRecognizer) {
        var finalPoint: CGPoint?
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x , y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        if recognizer.state == .ended {
            let velocity = recognizer.velocity(in: self.view)
            if velocity.y > 0 {
                // tray moving down
                finalPoint = trayCenterWhenClosed
            } else {
                // tray moving up
                finalPoint = trayCenterWhenOpen
            }

            UIView.animate(withDuration: 0.35, delay: 0,
                           usingSpringWithDamping: 0.9, //animating the ending tray motion with a bounce
                           initialSpringVelocity: 0.5,
                           options: UIViewAnimationOptions.curveEaseIn,
                           animations: {recognizer.view!.center = finalPoint!},
                           completion: nil)
        } else if recognizer.state == .changed {
                downArrow.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        
    }
    
    @IBAction func onSmileyPanGesture(_ recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            let imageView = recognizer.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            newlyCreatedFace.frame = imageView.frame
            newlyCreatedFace.contentMode = .scaleToFill
            view.addSubview(newlyCreatedFace)
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
            let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(recognizer:)))
            let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(handleSmileyRotation(recognizer:)))
    
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            newlyCreatedFace.addGestureRecognizer(pinchGestureRecognizer)
            newlyCreatedFace.addGestureRecognizer(rotationGestureRecognizer)
            newlyCreatedFace.isUserInteractionEnabled = true
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
        }
        let translation = recognizer.translation(in: self.view)
        
        if recognizer.state == .changed {
            newlyCreatedFace.center.x += translation.x
            newlyCreatedFace.center.y += translation.y
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
    }
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        print("detect pan")
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    
    }
    
    @objc func handlePinch(recognizer: UIPinchGestureRecognizer) {
        print("detect pinch")
        let view = recognizer.view as! UIImageView
        view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
        recognizer.scale = 1
        
    }
    
    @objc func handleSmileyRotation(recognizer: UIRotationGestureRecognizer) {
        print("detect rotation")
        let view = recognizer.view as! UIImageView
        view.transform = view.transform.rotated(by: recognizer.rotation)
        recognizer.rotation = 0
    }
    
    @objc func handleArrowRotation(recognizer: UIRotationGestureRecognizer) {
        print("detect rotation")
        let view = recognizer.view as! UIImageView
        view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
    }

    
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    
}

