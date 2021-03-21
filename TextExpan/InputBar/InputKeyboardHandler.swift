//
//  InputKeyboardHandler.swift
//  TextExpan
//
//  Created by lym on 2021/3/21.
//

import UIKit

extension SecondViewController: InputBarDelegate {
    func didChangeInputHeight(height: CGFloat) {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25) {
            self.adjustTableView(height: height)
        }
    }

    func didChageState(state: InputBarState) {
        switch state {
        case .normal:
            inputBar.endEdite()
            resetInputBarLayout()
            resetShowingListViewLayout()

        case .text:
            inputBar.beginEdite()
            resetShowingListViewLayout()

        case .emoji:
            showCustomKeyboardView(view: emojiListView, height: emojiListViewH)

        case .add:
            showCustomKeyboardView(view: addView, height: addViewH)

        case .voice:
            resetInputBarLayout()
            resetShowingListViewLayout()
        }
    }
}

extension SecondViewController {
    func showCustomKeyboardView(view: UIView, height: CGFloat) {
        switchingKeybaord = true
        inputBar.endEdite()
        resetShowingListViewLayout()

        view.isHidden = false

        self.view.layoutIfNeeded()

        UIView.animate(withDuration: 0.25) {
            view.alpha = 1
            view.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(-height)
            }
            self.bottomSpace.snp.updateConstraints { make in
                make.height.equalTo(height)
            }

            self.view.layoutIfNeeded()
            self.adjustTableView(height: height)
        } completion: { _ in
            self.switchingKeybaord = false
            self.showingListView = view
        }
    }

    func resetShowingListViewLayout() {
        UIView.animate(withDuration: 0.2) {
            self.showingListView?.alpha = 0

            self.showingListView?.isHidden = true
            self.showingListView?.snp.updateConstraints({ make in
                make.top.equalTo(self.view.snp.bottom).offset(0)
            })
            self.view.layoutIfNeeded()
        }
    }

    func resetInputBarLayout() {
        UIView.animate(withDuration: 0.25) {
            self.bottomSpace.snp.updateConstraints { make in
                make.height.equalTo(UIWindow.safeAreaInsets.bottom)
            }
            self.view.layoutIfNeeded()
        }
    }

    // 调整tableview显示 到最后一行
    private func adjustTableView(height: CGFloat) {
        let offsetY = tableView.contentSize.height - tableView.bounds.height
        print("contentSize = \(tableView.contentSize), height = \(tableView.bounds.height)")
        if offsetY > 0 {
            tableView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: false)
        }
    }
}


extension SecondViewController {
    func addNotification() {
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(keyboardWillChangeFrameNotification(notification:)),
                         name: UIResponder.keyboardWillChangeFrameNotification,
                         object: nil)
        
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(keyboardWillHideNotification(notification:)),
                         name: UIResponder.keyboardWillHideNotification,
                         object: nil)
    }

    @objc func keyboardWillChangeFrameNotification(notification: Notification) {
        // 如果正在切换键盘，就不要执行后面的代码
        if switchingKeybaord {
            return
        }

        let userInfo = notification.userInfo!
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let beginFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue

        let curve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey]! as AnyObject).uint32Value
        let options = UIView.AnimationOptions(rawValue: UInt(curve!) << 16 | UIView.AnimationOptions.beginFromCurrentState.rawValue)
        
        let offset = UIScreen.main.bounds.height - endFrame.origin.y
        let bottom = endFrame.size.height

        print("beginFrame = \(beginFrame),\nendFrame = \(endFrame)\noffset = \(offset), bottom = \(bottom)")

        if offset > 0 {
            switchingKeybaord = true
            self.resetShowingListViewLayout()

            UIView.animate(withDuration: duration, delay: 0, options: [options]) {
                self.bottomSpace.snp.updateConstraints { (make) in
                    make.height.equalTo(offset)
                }
                self.view.layoutIfNeeded()
                self.adjustTableView(height: offset)
                
            } completion: { (_) in
                self.switchingKeybaord = false
            }
        }
    }
    
    @objc func keyboardWillHideNotification(notification: Notification) {
        if switchingKeybaord {
            return
        }
        inputBar.refreshState(state: .normal)
    }
}
