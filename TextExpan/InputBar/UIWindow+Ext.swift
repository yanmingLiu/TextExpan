//
//  UIWindow+Ext.swift
//  DouYinSwift5
//
//  Created by lym on 2020/7/23.
//  Copyright © 2020 lym. All rights reserved.
//

import UIKit

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }

    static var applicationKey: UIWindow? {
        var window: UIWindow?
        for (_, per) in UIApplication.shared.windows.enumerated() {
            if per.tag == 1024 {
                window = per
                break
            }
        }
        return window ?? UIWindow.key
    }

    static var statusBarFrame: CGRect {
        if #available(iOS 13.0, *) {
            return key?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            return UIApplication.shared.statusBarFrame
        }
    }

    static var statusBarHeight: CGFloat {
        return statusBarFrame.size.height
    }

    static var navBarHeight: CGFloat {
        return 44
    }

    static var navViewHeight: CGFloat {
        return statusBarHeight + navBarHeight
    }

    static var safeAreaInsets: UIEdgeInsets {
        return UIWindow.key?.safeAreaInsets ?? UIEdgeInsets.zero
    }

    class func getTopViewController(base: UIViewController? = UIWindow.applicationKey?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.viewControllers.last)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

extension UIScreen {
    static var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }

    static var height: CGFloat {
        return UIScreen.main.bounds.size.height
    }
}
