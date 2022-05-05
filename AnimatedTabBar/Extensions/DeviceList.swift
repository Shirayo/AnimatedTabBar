//
//  DeviceList.swift
//  AnimatedTabBar
//
//  Created by Vasili on 4.05.22.
//

import SwiftUI

public extension UIDevice {

    static let isPhoneX: Bool = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> Bool { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod9,1":                                       return false
            case "iPhone8,1":                                     return false
            case "iPhone8,2":                                     return false
            case "iPhone8,4":                                     return false
            case "iPhone9,1", "iPhone9,3":                        return false
            case "iPhone9,2", "iPhone9,4":                        return false
            case "iPhone10,1", "iPhone10,4":                      return false
            case "iPhone10,2", "iPhone10,5":                      return false
            case "iPhone10,3", "iPhone10,6":                      return true
            case "iPhone11,2":                                    return true
            case "iPhone11,4", "iPhone11,6":                      return true
            case "iPhone11,8":                                    return true
            case "iPhone12,1":                                    return true
            case "iPhone12,3":                                    return true
            case "iPhone12,5":                                    return true
            case "iPhone12,8":                                    return true
            case "iPhone13,1":                                    return true
            case "iPhone13,2":                                    return true
            case "iPhone13,3":                                    return true
            case "iPhone13,4":                                    return true
            case "iPhone14,4":                                    return true
            case "iPhone14,5":                                    return true
            case "iPhone14,2":                                    return true
            case "iPhone14,3":                                    return true
            case "iPhone14,6":                                    return false
            case "i386", "x86_64", "arm64":                       return mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS")
            default:
                return true
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()
    
}
