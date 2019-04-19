//
//  UIImagePickerController+Extension.swift
//  System view conntrollers
//
//  Created by Arkadiy Grigoryanc on 19/04/2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import UIKit

extension UIImagePickerController {
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
    
    open override var shouldAutorotate: Bool {
        return true
    }
    
}
