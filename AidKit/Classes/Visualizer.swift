//
//  Visualizer.swift
//  AidKit
//
//  Created by Rezeq, Maher on 7/27/17.
//  Copyright © 2017 NativeNCreative. All rights reserved.
//

import UIKit

/// Visualizer touch events life cycle
protocol TouchEventHandler {
    func touchEventBegin(_ touch: UITouch)
    func touchEventMoved(_ touch: UITouch)
    func touchEventStationary(_ touch: UITouch)
    func touchEventCancelled(_ touch: UITouch)
    func touchEventEnded(_ touch: UITouch)
}

final public class VisualizerConfiguration: Configurable {

    public var name: String = "Visualizer"
    public var isOn: Bool = false

    static let defaultColor = UIColor(red: 52.0 / 255.0, green: 152.0 / 255.0, blue: 219.0 / 255.0, alpha: 0.8)

    public var color: UIColor? = defaultColor

    public var image: UIImage? = {

        let rect = CGRect(x: 0.0, y: 0.0, width: 60.0, height: 60.0)

        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let contextRef = UIGraphicsGetCurrentContext()
        contextRef?.setFillColor(defaultColor.cgColor)
        contextRef?.fillEllipse(in: rect)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image?.withRenderingMode(.alwaysTemplate)
    }()

}
public class Visualizer: NSObject, Controllable {

    public var configuration: Configurable?

    fileprivate var enabled = false
    fileprivate var shapes = [Shape]()

    let topWindow = UIApplication.shared.keyWindow

    public required override init() {
        self.configuration = VisualizerConfiguration()
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

    public func start() {
        guard let configuration = configuration, configuration.isOn else {
            return
        }

        self.configuration = configuration
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

        guard enabled else {
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

    // MARK: - Touch events life cycle
    func touchEventBegin(_ touch: UITouch) {

        let view = dequeueTouchView()

        if let configuration = configuration {
            view.configuration = configuration as? VisualizerConfiguration
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
            }, completion: {(_) -> Void in
                view.removeFromSuperview()
            })
        }
    }

    func touchEventEnded(_ touch: UITouch) {

        if let view = findTouchView(touch) {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .allowUserInteraction, animations: { () -> Void  in
                view.alpha = 0.0
                view.endTouch()
            }, completion: {(_) -> Void in
                view.removeFromSuperview()
            })
        }
    }

    // MARK: - Commands
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
            touchView = Shape(configuration as? VisualizerConfiguration ?? VisualizerConfiguration())
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
