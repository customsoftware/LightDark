//
//  AmbientNavigationViewController.swift
//  LightDark
//
//  Created by Kenneth Cluff on 3/30/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import UIKit

class AmbientNavigationViewController: UINavigationController {
    var statusBarStyle: UIStatusBarStyle = .default
    var currentLight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(handleUIUpdate(_:)), name: .UILightStateDidChange, object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    @objc private func handleUIUpdate(_ notification: Notification) {
        updateUIWith(notification)
    }
}

extension AmbientNavigationViewController: AmbientLightAware {
    func setStatusBar(_ mode: DisplayMode) {
        switch mode {
        case .dark:
            statusBarStyle = .lightContent
        case .light:
            statusBarStyle = .default
        }
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func setText(to color: UIColor) { }
}
