//
//  UIWindow+EventInterceptor.swift
//  AidKit
//
//  Created by Rezeq, Maher on 7/27/17.
//  Copyright © 2017 NativeNCreative. All rights reserved.
//

import UIKit

fileprivate var isSwizzled = false

@available(iOS 8.0, *)
extension UIWindow {

    public func swizzler() {

        guard !isSwizzled else {
            return
        }

        let sendEvent = class_getInstanceMethod(object_getClass(self), #selector(UIApplication.sendEvent(_:)))
        let swizzledSendEvent = class_getInstanceMethod(object_getClass(self), #selector(UIWindow.swizzledSendEvent(_:)))
        method_exchangeImplementations(sendEvent, swizzledSendEvent)

        isSwizzled = true
    }

    public func swizzledSendEvent(_ event: UIEvent) {
        handle(event)
        swizzledSendEvent(event)
    }

    private func handle(_ event: UIEvent) {

        switch event.type {

        case .touches: AKManager.sharedInstance.visualizer.handleEvent(event)

        case .motion:  break

        case .presses: break

        case .remoteControl: break
            
        default: break
        }
    }
}


