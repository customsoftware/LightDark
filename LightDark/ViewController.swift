//
//  ViewController.swift
//  LightDark
//
//  Created by Kenneth Cluff on 3/28/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
// https://www.raywenderlich.com/652-uiappearance-tutorial-getting-started
// https://stackoverflow.com/questions/51042894/change-status-bar-color-dynamically-in-swift-4/51043079

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var threshHold: UISlider!
    @IBAction func newThreshhold(_ sender: UISlider) {
        currentLight =  UIScreen.main.brightness
        let newThreshHold = sender.value
        UserDefaults.standard.set(newThreshHold, forKey: lightThreshholdKey)
        lightObserver.refresh(currentLight)
    }
    
    @IBAction func changeDisplayMode(_ sender: UISegmentedControl) {
        guard let mode = ModeSelectionOptions(rawValue: sender.selectedSegmentIndex) else { return }
        let dynamicMode: Bool
        
        switch mode {
        case .dark:
            dynamicMode = false
            let darkColors = DisplayColors.getDark()
            NotificationCenter.default.post(name: .UILightStateDidChange, object: nil, userInfo: [displayColorKey : darkColors])
            
        case .light:
            dynamicMode = false
            let lightColors = DisplayColors.getLight()
            NotificationCenter.default.post(name: .UILightStateDidChange, object: nil, userInfo: [displayColorKey : lightColors])
            
        case .dynamic:
            dynamicMode = true
            currentLight =  UIScreen.main.brightness
            UserDefaults.standard.set(threshHold.value, forKey: lightThreshholdKey)
            lightObserver.refresh(currentLight)
        }
        
        UserDefaults.standard.set(dynamicMode, forKey: dontIgnoreLightThreshholdKey)
    }
    var statusBarStyle: UIStatusBarStyle = .default
    var currentLight: CGFloat = 0
    let lightObserver = AmbientChangeEngine()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(handleUIUpdate(_:)), name: .UILightStateDidChange, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lightObserver.setTint(self.view.tintColor)
    }
    
    @objc private func handleUIUpdate(_ notification: Notification) {
        updateUIWith(notification)
    }
}

extension ViewController: AmbientLightAware {
    func setStatusBar(_ mode: DisplayMode) {
//        switch mode {
//        case .dark:
//            statusBarStyle = .lightContent
//        case .light:
//            statusBarStyle = .default
//        }
//        
//        setNeedsStatusBarAppearanceUpdate()
    }
    
    func setText(to color: UIColor) {
        UILabel.appearance().tintColor = color
    }
}
