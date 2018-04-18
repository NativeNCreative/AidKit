//
//  Debugger.swift
//  AidKit
//
//  Created by Stein, Maxwell on 8/31/17.
//  Copyright © 2017 NativeNCreative. All rights reserved.
//

import UIKit

final public class DebuggerConfiguration: Configurable {

    public var name: String = "Debugger"
    public var isOn: Bool = false
}

final public class Debugger: Controllable {
    public var configuration: Configurable?

    let deviceName = UIDevice.current.name
    let version = UIDevice.current.systemVersion
    let systemName = UIDevice.current.systemName
    let model = UIDevice.current.model

    public func start() {
        guard let configuration = configuration, configuration.isOn else {
            return
        }
        print(systemName + " " + version + " Device Type: " + model)
    }
    public func stop() {

    }
}
