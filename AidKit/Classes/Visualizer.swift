//
//  Visualizer.swift
//  AidKit
//
//  Created by Rezeq, Maher on 7/27/17.
//  Copyright © 2017 NativeNCreative. All rights reserved.
//

import UIKit

protocol TouchEventHandler {
    func touchEventBegin(_ touch: UITouch)
    func touchEventMoved(_ touch: UITouch)
    func touchEventStationary(_ touch: UITouch)
    func touchEventCancelled(_ touch: UITouch)
    func touchEventEnded(_ touch: UITouch)
}

public class Visualizer : NSObject, AKControllable {

    fileprivate var enabled = false
    fileprivate var shapes = [Shape]()
    fileprivate var configuration: VisualizerConfiguration?

    let topWindow = UIApplication.shared.keyWindow

    override init() {
        super.init()
        NotificationCenter
            .default
            .addObserver(self, selector: #selector(Visualizer.orientationDidChangeNotification(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    deinit {
        NotificationCenter
            .default
            .removeObserver(self)
    }

    @objc internal func orientationDidChangeNotification(_ notification: Notification) {
        clearScreen()
    }

    public func clearScreen() {
        for touch in shapes {
            touch.removeFromSuperview()
        }
    }

    public func isEnabled() -> Bool {
        return enabled
    }

    // MARK: - Start and Stop functions

    func start(_ configuration: Configurable) {
        guard configuration.isOn else {
            return
        }

        self.configuration = configuration as? VisualizerConfiguration
        enabled = true

        if let window = topWindow {
            for subview in window.subviews {
                if let subview = subview as? Shape {
                    subview.removeFromSuperview()
                }
            }
        }
    }

    public func stop() {
        enabled = false
        clearScreen()
    }

}

extension Visualizer : TouchEventHandler {

    open func handleEvent(_ event: UIEvent) {

        if !enabled {
            return
        }

        for touch in event.allTouches! {
            let phase = touch.phase

            switch phase {
            case .began:
                touchEventBegin(touch)

            case .moved:
                touchEventMoved(touch)

            case .stationary:
                touchEventStationary(touch)

            case .ended, .cancelled:
                touchEventEnded(touch)
            }
        }
    }

    // MARK: Touch Event Handler
    func touchEventBegin(_ touch: UITouch) {

        let view = dequeueTouchView()

        if let configuration = configuration {
            view.configuration = configuration
        }
        view.touch = touch
        view.beginTouch()
        view.center = touch.location(in: topWindow)

        print("\(view.frame) + \(view.center)")
        topWindow?.addSubview(view)
    }

    func touchEventMoved(_ touch: UITouch) {
        if let view = findTouchView(touch) {
            view.center = touch.location(in: topWindow)
        }
    }

    func touchEventStationary(_ touch: UITouch) {

    }

    func touchEventCancelled(_ touch: UITouch) {

        if let view = findTouchView(touch) {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .allowUserInteraction, animations: { () -> Void  in
                view.alpha = 0.0
                view.endTouch()
            }, completion: {(finished) -> Void in
                view.removeFromSuperview()
            })
        }
    }

    func touchEventEnded(_ touch: UITouch) {

        if let view = findTouchView(touch) {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .allowUserInteraction, animations: { () -> Void  in
                view.alpha = 0.0
                view.endTouch()
            }, completion: {(finished) -> Void in
                view.removeFromSuperview()
            })
        }
    }


    // MARK: Commands
    public func getTouches() -> [UITouch] {

        var touches: [UITouch] = []
        for view in shapes {
            guard let touch = view.touch else { continue }
            touches.append(touch)
        }
        return touches
    }

    // MARK: - Dequeue and locating TouchViews and handling events
    private func dequeueTouchView() -> Shape {
        var touchView: Shape?
        for view in shapes {
            if view.superview == nil {
                touchView = view
                break
            }
        }

        if touchView == nil {
            touchView = Shape()
            shapes.append(touchView!)
        }
        
        return touchView!
    }
    
    private func findTouchView(_ touch: UITouch) -> Shape? {
        for view in shapes {
            if touch == view.touch {
                return view
            }
        }
        
        return nil
    }
}
