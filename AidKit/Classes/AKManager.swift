//
//  AKManager.swift
//  AidKit
//
//  Created by Rezeq, Maher on 7/27/17.
//  Copyright © 2017 NativeNCreative. All rights reserved.
//

import UIKit

/// Native component identifier
public enum ComponentId: String {
    case recorder = "recorder"
    case visualizer = "visualizer"
    case debugger = "debugger"
}

/// Component class managed by AKManager
public class Component {
   public var controllable: Controllable?
   public var configurable: Configurable?

    public init(controllable: Controllable, configurable: Configurable) {
        self.controllable = controllable
        self.configurable = configurable
    }
}

/// Controllable protocol for controlling the components managed by AKManager
public protocol Controllable: class {
    var configuration: Configurable? { get set }
    func start()
    func stop()
}

/// Configurable protocol for components configuration
public protocol Configurable {
    var isOn: Bool { get set }
    var name: String { get set }
}

/// AKManager is a singleton class for managing the debugging tools
final public class AKManager: NSObject {

    // MARK: - Public Variables
    @objc static public let shared = AKManager()

    fileprivate var components: [ComponentId : Component] = [ComponentId: Component]()

    // MARK: - Object life cycle
    private override init() {
        super.init()
        NotificationCenter
            .default
            .addObserver(self, selector: #selector(AKManager.applicationDidBecomeActiveNotification(_:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    public func registerComponent(_ component: Component, _ identifier: ComponentId) {
        components[identifier] = component
    }

    public func controllableFor(_ identifier: ComponentId) -> Controllable? {
        if let component = components[identifier] {
            return component.controllable
        }
        return nil
    }

    public func setConfiguration(_ configuration: Configurable, _ identifier: ComponentId) {
        if let component: Component = components[identifier] {
            component.configurable = configuration
        }
    }

    public func configuration( _ identifier: ComponentId) -> Configurable? {
        if let component: Component = components[identifier] {
            return component.configurable
        }
        return nil
    }

    public func componentFor(_ identifier: ComponentId) -> Component? {
        return components[identifier]
    }

    @objc public func start() {
        for component in components.values {
            if let configuration = component.configurable {
                component.controllable?.configuration = configuration
            }
            component.controllable?.start()
        }
    }

    @objc public func stop() {
        for component in components.values {
            component.controllable?.stop()
        }
    }

    // MARK: - Helper Functions
    @objc internal func applicationDidBecomeActiveNotification(_ notification: Notification) {
        UIApplication.shared.keyWindow?.swizzler()
    }

    public func registerNativeComponents() {
        registerComponent(Component(controllable: Visualizer(), configurable: VisualizerConfiguration()), ComponentId.visualizer)
        registerComponent(Component(controllable: Recorder(), configurable: RecorderConfiguration()), ComponentId.recorder)
        registerComponent(Component(controllable: Debugger(), configurable: DebuggerConfiguration()), ComponentId.debugger)
    }
}
