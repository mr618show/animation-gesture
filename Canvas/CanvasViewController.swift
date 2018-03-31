//
//  ViewController.swift
//  Canvas
//
//  Created by Rui Mao on 3/30/18.
//  Copyright © 2018 Rui Mao. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var trayView: UIView!
    var trayOriginalCenter: CGPoint!
    var trayCenterWhenOpen: CGPoint!
    var trayCenterWhenClosed: CGPoint!
    var newlyCreatedFace: UIImageView!
    var smileyOriginalCenter: CGPoint!
    override func viewDidLoad() {
        super.viewDidLoad()
        trayCenterWhenOpen = CGPoint(x: trayView.center.x, y: trayView.frame.size.height/2)
        trayCenterWhenClosed = CGPoint(x: trayView.center.x, y: self.view.frame.height - trayView.frame.size.height/2)
    }

    @IBAction func onTrayPanGesture(_ recognizer: UIPanGestureRecognizer) {
        var finalPoint: CGPoint?
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x , y:view.center.y + translation.y / 10)
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
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.5,
                           options: UIViewAnimationOptions.curveEaseIn,
                           animations: {recognizer.view!.center = finalPoint!},
                           completion: nil)
        }
    }
    
    @IBAction func onSmileyPanGesture(_ recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            let imageView = recognizer.view as! UIImageView
            smileyOriginalCenter = imageView.center
            newlyCreatedFace = UIImageView(image: imageView.image)
            newlyCreatedFace.frame = imageView.frame
            newlyCreatedFace.contentMode = .scaleToFill
            view.addSubview(newlyCreatedFace)
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onNewSmileyPangesture(recognizer:)))
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
    
    @objc func onNewSmileyPangesture(recognizer: UIPanGestureRecognizer) {
        var smileyFinalPoint: CGPoint?
        let translation = recognizer.translation(in: self.view)
        if recognizer.state == .changed {
            if let view = recognizer.view {
                view.center = CGPoint(x:view.center.x + translation.x,
                                      y:view.center.y + translation.y)
                recognizer.setTranslation(CGPoint.zero, in: self.view)
            }
        } else if recognizer.state == .ended {
            let velocity = recognizer.velocity(in: self.view)
            if velocity.y > 0 && trayView.center == trayCenterWhenClosed {
                smileyFinalPoint = CGPoint(x: smileyOriginalCenter.x, y: smileyOriginalCenter.y + view.frame.height - trayView.frame.height)
            } else if velocity.y < 0 && trayView.center == trayCenterWhenOpen {
                smileyFinalPoint = smileyOriginalCenter
           }
            UIView.animate(withDuration: 0.35, delay: 0,
                           usingSpringWithDamping: 0.9,
                           initialSpringVelocity: 0.5,
                           options: UIViewAnimationOptions.curveEaseIn,
                           animations: {
                            if let finalPoint = smileyFinalPoint{
                            recognizer.view!.center = finalPoint}
                            },
                           completion: {finished in recognizer.view?.removeFromSuperview()})
        }
    }
    
    @objc func handlePinch(recognizer: UIPinchGestureRecognizer) {
        let view = recognizer.view as! UIImageView
        view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
        recognizer.scale = 1
    }
    
    @objc func handleSmileyRotation(recognizer: UIRotationGestureRecognizer) {
        let view = recognizer.view as! UIImageView
        view.transform = view.transform.rotated(by: recognizer.rotation)
        recognizer.rotation = 0
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    
}

