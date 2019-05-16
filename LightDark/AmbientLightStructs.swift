//
//  AmbientLightStructs.swift
//  LightDark
//
//  Created by Kenneth Cluff on 4/3/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import UIKit

struct DisplayColors {
    var textColor: UIColor
    var backgroundColor: UIColor
    var tintColor: UIColor
    var mode: DisplayMode
    
    static let lightColor = UIColor(displayP3Red: 244/255, green: 249/255, blue: 248/255, alpha: 1.0)
    static let darkColor = UIColor(displayP3Red: 64/255, green: 64/255, blue: 64/255, alpha: 1)
    static let defaultBlueColor = UIColor(displayP3Red: 0, green: 118/255, blue: 250/255, alpha: 1)
    
    static func getDark() -> DisplayColors {
        return DisplayColors(textColor: lightColor, backgroundColor: darkColor, tintColor: .lightGray, mode: .dark)
    }
    
    static func getLight() -> DisplayColors {
        let defaultColor: UIColor
        if let colors = UserDefaults.standard.array(forKey: defaultTintKey) as? [CGFloat] {
            defaultColor = UIColor(displayP3Red: colors[0], green: colors[1], blue: colors[2], alpha: colors[3])
        } else {
            defaultColor = defaultBlueColor
        }
        
        return DisplayColors(textColor: darkColor, backgroundColor: lightColor, tintColor: defaultColor, mode: .light)
    }
}
