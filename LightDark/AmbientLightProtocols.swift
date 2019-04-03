//
//  AmbientLightProtocols.swift
//  LightDark
//
//  Created by Kenneth Cluff on 4/3/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import UIKit

protocol AmbientStatus {
    var statusBarStyle: UIStatusBarStyle { get set }
    /**
     Changing the status bar must be called from the rootViewController of the applications key window. Otherwise it will have no effect.
     Since the full suite of responses to the mode change message isn't needed, all we need to do is listen for the notification then read its contents and act on them.
     
     - Author:
     Ken Cluff
     
     - returns:
     Doesn't return a value
     
     - parameters:
     - mode: An enumeration 'DisplayMode' which will be either 'light' or 'dark.' As of Swift 5, this must invoke the 'setNeedsStatusBarAppearanceUpdate()' method and set a parameter used to tell what type of status bar to display. The example below assumes an instance variable named 'statusBarStyle' typed as a UIStatusBarStyle is updated thusly before the method 'setNeedsStatusBarAppearanceUpdate' is called.
     
     switch mode {
     
     case .dark:
     
     statusBarStyle = .lightContent
     
     case .light:
     
     statusBarStyle = .default
     
     }
     
     - Version:
     1.0
     */
    func handleStatusBarChangeNotification(_ notification: Notification)
}

protocol AmbientLightAware where Self: UIViewController {
    var currentLight: CGFloat { get set }
    
    func updateUIWith(_ notification: Notification)
    func setText(to color: UIColor)
    func setNavBar(_ mode: DisplayMode)
    func setTabBar(_ mode: DisplayMode)
    func setBackgroundColors(to color: UIColor)
}

extension AmbientLightAware {
    func setBackgroundColors(to color: UIColor) {
        view.backgroundColor = color
        view.layoutIfNeeded()
    }
    
    func setNavBar(_ mode: DisplayMode) {
        let barStyle: UIBarStyle
        let colorSet: DisplayColors
        switch mode {
        case .dark:
            barStyle = .black
            colorSet = DisplayColors.getDark()
        case .light:
            barStyle = .default
            colorSet = DisplayColors.getLight()
        }
        // Appearance only works on new instances, so this sets the current instance
        navigationController?.navigationBar.barTintColor = colorSet.backgroundColor
        navigationController?.navigationBar.barStyle = barStyle
        navigationController?.navigationBar.tintColor = colorSet.textColor
        
        UINavigationBar.appearance().barTintColor = colorSet.backgroundColor
        UINavigationBar.appearance().barStyle = barStyle
        UINavigationBar.appearance().tintColor = colorSet.textColor
    }
    
    func setTabBar(_ mode: DisplayMode) {
        let colorSet: DisplayColors
        switch mode {
        case .dark:
            colorSet = DisplayColors.getDark()
        case .light:
            colorSet = DisplayColors.getLight()
        }
        
        // Appearance only works on new instances, so this sets the current instance
        tabBarController?.tabBar.tintColor = colorSet.tintColor
        tabBarController?.tabBar.backgroundColor = colorSet.backgroundColor
        
        UITabBar.appearance().tintColor = colorSet.tintColor
        UITabBar.appearance().backgroundColor = colorSet.backgroundColor
    }
    
    func updateUIWith(_ notification: Notification) {
        let userInfo = notification.userInfo
        guard let colorSet = userInfo?[displayColorKey] as? DisplayColors else { return }
        view.tintColor = colorSet.tintColor
        setNavBar(colorSet.mode)
        setBackgroundColors(to: colorSet.backgroundColor)
        setText(to: colorSet.textColor)
        setTabBar(colorSet.mode)
        view.layoutIfNeeded()
    }
}
