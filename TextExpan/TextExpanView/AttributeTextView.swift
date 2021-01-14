//
//  AttributeTextView.swift
//  TextExpan
//
//  Created by lym on 2021/1/8.
//

import Foundation
import UIKit

// 富文本视图
class AttributeTextView: UITextView {
    // 关闭高亮富文本的长按选中功能
    override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer is UILongPressGestureRecognizer {
            gestureRecognizer.isEnabled = false
        }
        super.addGestureRecognizer(gestureRecognizer)
    }

    // 打开或禁用复制，剪切，选择，全选等功能 UIMenuController
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        // 返回false为禁用，true为开启
        if action == #selector(copy(_:)) || action == #selector(selectAll(_:)) || action == #selector(select(_:)) {
            return true
        }
        return false
    }
}
