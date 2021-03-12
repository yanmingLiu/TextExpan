//
//  SecondViewController.swift
//  TextExpan
//
//  Created by lym on 2021/3/1.
//

import UIKit

class SecondViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makelabel()
        
    }
    
    func makelabel() {
        let label = UILabel()
        let attrString = NSMutableAttributedString(string: "I bought if from Shibuya ;p,dont jelous me i km very very annoying ss bite me if u …")
        label.frame = CGRect(x: 16, y: 645, width: 343, height: 44)
        label.numberOfLines = 0
        let attr: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 16),.foregroundColor: UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1)]
        attrString.addAttributes(attr, range: NSRange(location: 0, length: attrString.length))
        view.addSubview(label)
        let strSubAttr1: [NSMutableAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16),.foregroundColor: UIColor(red: 0.13, green: 0.13, blue: 0.13,alpha:1.000000)]
        attrString.addAttributes(strSubAttr1, range: NSRange(location: 0, length: 25))

        let strSubAttr2: [NSMutableAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16),.foregroundColor: UIColor(red: 0.13, green: 0.13, blue: 0.13,alpha:1.000000)]
        attrString.addAttributes(strSubAttr2, range: NSRange(location: 25, length: 59))

        label.attributedText = attrString
        
        label.frame = CGRect(x: 20, y: 100, width: view.bounds.width - 40, height: 200)
    }
}
