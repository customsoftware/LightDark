//
//  LightDarkEngine.swift
//  LightDark
//
//  Created by Kenneth Cluff on 3/28/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//
// https://www.raywenderlich.com/652-uiappearance-tutorial-getting-started
// https://stackoverflow.com/questions/51042894/change-status-bar-color-dynamically-in-swift-4/51043079

import UIKit

let displayColorKey = "DisplayColors"
let defaultTintKey = "kDefaultTint"
let lightThreshholdKey = "kLightThreshholdKey"
let dontIgnoreLightThreshholdKey = "kDontIgnoreLightThreshholdKey"
let selectedDisplayModeKey = "kSelectedDisplayModeKey"

class AmbientChangeEngine {
    var activeMode: DisplayMode = .light {
        didSet {
            switch activeMode {
            case .dark:
                let darkColors = DisplayColors.getDark()
                postNotification(darkColors)
            case .light:
                let lightColors = DisplayColors.getLight()
                postNotification(lightColors)
            }
        }
    }
    
    var lastLight: CGFloat = 0
    var defaultTint = UIApplication.shared.delegate?.window??.tintColor
    
    init() {
        registerForNotifications()
        lastLight = UIScreen.main.brightness
        restoreSettings()
    }
    
    func setTint(_ color: UIColor) {
        var rColor: CGFloat = 0
        var gColor: CGFloat = 0
        var bColor: CGFloat = 0
        var alpha: CGFloat = 1
        color.getRed(&rColor, green: &gColor, blue: &bColor, alpha: &alpha)
        let colorArray = [rColor,gColor,bColor,alpha]
        UserDefaults.standard.set(colorArray, forKey: defaultTintKey)
    }
    
    func refresh(_ testLight: CGFloat) {
        getLightChangeMode(with: testLight)
    }
    
    func getActiveColorSet() -> DisplayColors {
        let _activeColorSet: DisplayColors
        switch activeMode {
        case .dark:
            _activeColorSet = DisplayColors.getDark()
        case .light:
            _activeColorSet = DisplayColors.getLight()
        }
        return _activeColorSet
    }
}

fileprivate extension AmbientChangeEngine {
    
    func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleBrightnessChange(_:)), name: UIScreen.brightnessDidChangeNotification, object: nil)
    }
    
    func postNotification(_ colorSet: DisplayColors) {
        NotificationCenter.default.post(name: .UILightStateDidChange, object: nil, userInfo: [displayColorKey : colorSet])
    }
    
    func restoreSettings() {
        let selectedLightMode = UserDefaults.standard.integer(forKey: selectedDisplayModeKey)
        guard let mode = ModeSelectionOptions(rawValue: selectedLightMode) else { return }
        switch mode {
        case .dark:
            activeMode = .dark
            postNotification(DisplayColors.getDark())
        case .light:
            activeMode = .light
            postNotification(DisplayColors.getLight())
        case .dynamic:
            evaluateNewMode(lastLight)
        }
    }
    
    @objc func handleBrightnessChange(_ notification: Notification) {
        let testLight = UIScreen.main.brightness
        if testLight != lastLight {
            getLightChangeMode(with: testLight)
        }
        lastLight = testLight
    }
    
    func getLightChangeMode(with lightValue: CGFloat) {
        if UserDefaults.standard.bool(forKey: dontIgnoreLightThreshholdKey) {
            evaluateNewMode(lightValue)
        }
    }
    
    func evaluateNewMode(_ currentLightValue: CGFloat) {
        guard let threshHold = UserDefaults.standard.value(forKey: lightThreshholdKey) as? CGFloat else { return }
        if threshHold < currentLightValue {
            activeMode = .light
        } else {
            activeMode = .dark
        }
    }
}
