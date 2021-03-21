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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)


        addTextExpanView()
        // 正常情况

//        textView.contentOriginText = "微信朋友圈文字全文-收起效果的实现：1主要通过富文本的link实现点击，2是计算出最大的字符数拼接...全文的字符location，然后通过截取处理，自动布局让子view的高度去撑开父视图的高度。 动态输入的实现，text view随着文字的输入动态变换高度，父视图也跟着变化。"

        // \n情况
        
        textView.contentOriginText = "微\n信\n朋\n友\n圈文\n字全文-收起效果的实现：1主要通过富文本的link实现点击，2是计算出最大的字符数拼接...全文的字符location，然后通过截取处理，自动布局让子view的高度去撑开父视图的高度。 动态输入的实现，text view随着文字的输入动态变换高度，父视图也跟着变化。"
    }

}

extension ViewController {
    func addTextExpanView() {
        textView = TextExpanView()
        view.addSubview(textView)

        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(140)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }

}
