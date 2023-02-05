//
//  DynamicAppIcon.swift
//  spotster
//
//  Created by Colton Lathrop on 2/3/23.
//

import Foundation
import UIKit

func setAppIcon() {
    if UIApplication.shared.supportsAlternateIcons {
        let currentIcon = getCurrentAppIcon()
        if UIApplication.shared.alternateIconName == currentIcon {
            return
        } else {
            UIApplication.shared.setAlternateIconName(currentIcon)
        }
    }
}

func getCurrentAppIcon() -> String{
    let date = Date()
    let calendar = Calendar.current
    let month = calendar.component(.month, from: date)
    
    switch month {
    case 2:
        return "AppIcon-FEB"
    case 3:
        return "AppIcon-MAR"
    case 4:
        return "AppIcon-APR"
    case 6:
        return "AppIcon-JUN"
    case 10:
        return "AppIcon-OCT"
    case 12:
        return "AppIcon-DEC"
    default:
        return "AppIcon"
    }
}
