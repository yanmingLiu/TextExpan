//
//  TextExpanView.swift
//  TextExpan
//
//  Created by lym on 2021/1/14.
//

import Foundation
import SnapKit
import UIKit

class TextExpanView: UIView {
    var contentOriginText = "" {
        didSet {
            refreshUI()
        }
    }

    private var avatar: UIImageView!
    private var nameLabel: UILabel!
    private var textView: AttributeTextView!

    private var expan: Bool = false
    private let linkText = "FullText"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        setupUI()

        refreshUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TextExpanView {
    func refreshUI() {
        nameLabel.text = "会杀猪的ioser"
        
        // 2行文字能显示的最大字符数 = 文本框宽度 * 2 - more所占的宽度
        let moreWidth:CGFloat = 70
        var maxTextLength = 0
        var onelineWidth = (UIScreen.main.bounds.width - 48 - 8 - 16 * 2)
        var curentLine = 1
        var curentLinecharacterWidth: CGFloat = 0

        for c in contentOriginText.charactersArray {
            maxTextLength += 1

            if String(c) == "\n" {
                print("c = \(c)")
                curentLine += 1
                curentLinecharacterWidth = 0
                onelineWidth -= moreWidth
                if curentLine > 2 {
                    maxTextLength -= 1
                    break
                } else {
                    continue
                }

            } else {
                let lineFontWidth = String(c).width(for: UIFont.systemFont(ofSize: 16))
                curentLinecharacterWidth += lineFontWidth
                if curentLinecharacterWidth >= onelineWidth {
                    print("c = \(c), lineFontWidth = \(lineFontWidth), curentLinecharacterWidth = \(curentLinecharacterWidth), curentLine = \(curentLine), onelineWidth = \(onelineWidth)")
                    curentLine += 1
                    curentLinecharacterWidth = 0
                    onelineWidth -= moreWidth
                    if curentLine > 2 {
                        break
                    } else {
                        continue
                    }
                }
            }
        }
        print("maxTextLength = \(maxTextLength)")
        
        // 全文
        let textAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.gray]
        var attributedString = NSMutableAttributedString(string: contentOriginText, attributes: textAttributes)

        if contentOriginText.count > maxTextLength {
            var fullText: NSMutableAttributedString

            let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.gray]
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = 4

            if expan {
                paragraph.lineBreakMode = .byWordWrapping
                attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraph], range: NSRange(location: 0, length: attributedString.length))

                fullText = NSMutableAttributedString(string: "\n收起", attributes: attributes)
                fullText.addAttributes([NSAttributedString.Key.link: linkText], range: NSRange(location: 0, length: fullText.length))

            } else {
                paragraph.lineBreakMode = .byCharWrapping
                attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraph], range: NSRange(location: 0, length: attributedString.length))

                attributedString = attributedString.attributedSubstring(from: NSRange(location: 0, length: maxTextLength)) as! NSMutableAttributedString
                fullText = NSMutableAttributedString(string: "...展开", attributes: attributes)
                fullText.addAttributes([NSAttributedString.Key.link: linkText], range: NSRange(location: 3, length: fullText.length - 3))
            }
            attributedString.append(fullText)
            textView.attributedText = attributedString

            let height = heightOfAttributedString(attributedString)
            textView.snp.updateConstraints { make in
                make.height.equalTo(height)
            }
            layoutSubviews()

        } else {
            textView.attributedText = attributedString
        }
    }

    // 计算富文本的高度
    func heightOfAttributedString(_ attributedString: NSAttributedString) -> CGFloat {
        let maxWidth = UIScreen.main.bounds.size.width - 16 * 2 - 8 - 48
        let height: CGFloat = attributedString.boundingRect(with: CGSize(width: maxWidth, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).height
        return ceil(height) + 1
    }
}

extension TextExpanView {
    private func setupUI() {
        avatar = UIImageView()
        avatar.backgroundColor = .orange
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 24
        addSubview(avatar)

        nameLabel = UILabel()
        nameLabel.font = .boldSystemFont(ofSize: 16)
        addSubview(nameLabel)

        textView = AttributeTextView()
        textView.backgroundColor = .white
        textView.delegate = self
        textView.textColor = .gray
        textView.font = .systemFont(ofSize: 16)
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsets.zero
        textView.linkTextAttributes = [:]
        addSubview(textView)

        avatar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(48)
            make.height.equalTo(48)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatar).offset(4)
            make.left.equalTo(avatar.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
        }

        textView.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.right.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.height.equalTo(44)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
    }
}

// MARK: UITextViewDelegate

extension TextExpanView: UITextViewDelegate {
    // 点击链接
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let selectdText: String = textView.attributedText.attributedSubstring(from: characterRange).string
        print("点击了：\(selectdText) \n  链接值：\(URL.absoluteString) ")
        if URL.absoluteString == linkText {
            expan = !expan
            refreshUI()
        }
        return false
    }
}
