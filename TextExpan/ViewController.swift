//
//  ViewController.swift
//  TextExpan
//
//  Created by lym on 2021/1/14.
//

import SnapKit
import UIKit

class ViewController: UIViewController {
    var textView: TextExpanView!

    var inputBar: InputBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)

        addNotification()

        addInputView()

        addTextExpanView()

        textView.contentOriginText = "微信朋友圈文字全文-收起效果的实现：1主要通过富文本的link实现点击，2是计算出最大的字符数拼接...全文的字符location，然后通过截取处理，自动布局让子view的高度去撑开父视图的高度。 动态输入的实现，text view随着文字的输入动态变换高度，父视图也跟着变化。"
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputBar.endEditing(true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        textView.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(40 + view.safeAreaInsets.top)
        }
    }
}

extension ViewController {
    func addTextExpanView() {
        textView = TextExpanView()
        view.addSubview(textView)

        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40 + view.safeAreaInsets.top)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }

    func addInputView() {
        inputBar = InputBar()
        view.addSubview(inputBar)

        inputBar.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-view.safeAreaInsets.top)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
}

extension ViewController {
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: Notification) {
        let endFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval

        inputBar.keyboardRect = endFrame

        let offset = UIScreen.main.bounds.height - endFrame.origin.y

        UIView.animate(withDuration: duration) {
            self.inputBar.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(-offset)
            }
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval

        UIView.animate(withDuration: duration) {
            self.inputBar.snp.updateConstraints { make in
                make.bottom.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }
    }
}
