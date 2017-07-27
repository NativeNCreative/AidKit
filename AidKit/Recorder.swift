//
//  Recorder.swift
//  AidKit
//
//  Created by Rezeq, Maher on 7/27/17.
//  Copyright © 2017 NativeNCreative. All rights reserved.
//

import Foundation

import Foundation
import ReplayKit

class Recorder : NSObject, RPScreenRecorderDelegate, RPPreviewViewControllerDelegate {

    public var presentedViewController: UIViewController?

    // TODO: create another initializer with delegate as param
    override init() {
        super.init()
        RPScreenRecorder.shared().delegate = self
    }
    // TODO: Create a callback block after start recording to report error or recording started successfully
    func startRecording() {

        guard #available(iOS 10.0, *), (RPScreenRecorder.shared().isAvailable) else {
            // TODO Log error
            // Fallback on earlier versions
            return
        }

        RPScreenRecorder.shared().startRecording(handler: {(error: Error?) in
            if error == nil {
                NSLog("Yaay -> No Errors ")
                // Recording started
            }
        })

    }

    func stopRecording() {

        guard #available(iOS 10.0, *), !RPScreenRecorder.shared().isRecording else {
            // TODO Log error
            // Recording is not active
            return
        }

        RPScreenRecorder.shared().stopRecording { [unowned self]  (preview, error) in

            if let preview = preview {
                preview.previewControllerDelegate = self
                if let presentedViewController = self.previewController() {
                    presentedViewController.present(preview, animated: true)
                }
            }
        }
    }

    func previewController() -> UIViewController?{
        if((presentedViewController) != nil) {
            return presentedViewController
        }
        var topViewController: UIViewController? = nil

        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            while let viewController = viewController.presentedViewController {
                topViewController = viewController
            }
        }
        return topViewController
    }

    public func screenRecorder(_ screenRecorder: RPScreenRecorder, didStopRecordingWithError error: Error, previewViewController: RPPreviewViewController?) {
        NSLog("Yaay -> No Errors ")
    }

    public func screenRecorderDidChangeAvailability(_ screenRecorder: RPScreenRecorder) {
        NSLog("Not Available")
    }

    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        previewController.dismiss(animated: true)
    }
    
}
