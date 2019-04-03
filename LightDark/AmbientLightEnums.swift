//
//  AmbientLightEnums.swift
//  LightDark
//
//  Created by Kenneth Cluff on 4/3/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import Foundation


// Since we cant store an array of weak objects, we will use notifications and send that to multiple objects
enum DisplayModeChange {
    case goLight
    case goDark
    case goSame
}

enum ModeSelectionOptions: Int {
    case dynamic
    case dark
    case light
}

enum DisplayMode {
    case dark
    case light
}

