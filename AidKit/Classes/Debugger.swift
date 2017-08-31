//
//  Debugger.swift
//  AidKit
//
//  Created by Stein, Maxwell on 8/31/17.
//  Copyright © 2017 NativeNCreative. All rights reserved.
//

import UIKit

final public class Debugger: AKControllable {

    func start(_ configuration: Configurable) {
        guard configuration.isOn else {
            return
        }
        print(systemName + " " + version + " Device Type: " + model)
    }

    func stop() {

    }


    let deviceName = UIDevice.current.name
    let version = UIDevice.current.systemVersion
    let systemName = UIDevice.current.systemName
    let model = UIDevice.current.model



}
