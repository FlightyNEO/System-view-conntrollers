//
//  OwnActivity.swift
//  System view conntrollers
//
//  Created by Arkadiy Grigoryanc on 19/04/2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import UIKit

final class GitActivity: UIActivity {
    
    private var _activityTitle: String
    private var _activityImage: UIImage?
    
    private var activityItems = [Any]()
    private var action: ([Any]) -> Void
    
    override var activityTitle: String? {
        return _activityTitle
    }
    
    override var activityImage: UIImage? {
        return _activityImage
    }
    
    override var activityType: UIActivity.ActivityType? {
        return .init("gitActibity")
    }
    
    override class var activityCategory: UIActivity.Category {
        return .action
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }
    
    override func prepare(withActivityItems activityItems: [Any]) {
        self.activityItems = activityItems
    }
    
    override func perform() {
        action(activityItems)
        activityDidFinish(true)
    }
    
    init(title: String, image: UIImage?, performAction: @escaping ([Any]) -> Void) {
        _activityTitle = title
        _activityImage = image
        action = performAction
        super.init()
    }
    
}
