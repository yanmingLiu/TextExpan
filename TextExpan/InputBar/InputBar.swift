//
//  InputView.swift
//  TextExpan
//
//  Created by lym on 2021/1/14.
//

import Foundation
import SnapKit
import UIKit

class InputBar: UIView {
    var textView: UITextView!

    var keyboardRect: CGRect! {
        didSet {
            emojiListView.frame = CGRect(x: 0, y: 0, width: keyboardRect.width, height: keyboardRect.height)
        }
    }

    private var emojiButton: UIButton!
    private var voiceButton: UIButton!
    private var addButton: UIButton!

    private lazy var emojiListView: EmojiListView = {
        let view = EmojiListView()
        return view
    }()

    private var showEmoji: Bool = false

    private let maxHeight: CGFloat = 64
    private var textHeight: CGFloat = 0
    private let margin: CGFloat = 8, btnwh: CGFloat = 24

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bottom = margin + safeAreaInsets.bottom
        voiceButton.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(-bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan")
    }
}

extension InputBar {
    @objc private func clickEmojiButton() {
        textView.becomeFirstResponder()
        showEmoji = !showEmoji
        if showEmoji {
            emojiListView.frame = keyboardRect
            textView.inputView = emojiListView
            emojiButton.setBackgroundImage(UIImage(named: "btn_keyboard"), for: .normal)

        } else {
            textView.inputView = nil
            emojiButton.setBackgroundImage(UIImage(named: "btn_emoji"), for: .normal)
        }
        textView.reloadInputViews()
    }
}

extension InputBar {
    private func setupUI() {
        voiceButton = UIButton()
        voiceButton.setBackgroundImage(UIImage(named: "btn_voice"), for: .normal)
        addSubview(voiceButton)

        addButton = UIButton(type: .custom)
        addButton.setBackgroundImage(UIImage(named: "btn_add"), for: .normal)
        addSubview(addButton)

        emojiButton = UIButton(type: .custom)
        emojiButton.setBackgroundImage(UIImage(named: "btn_emoji"), for: .normal)
        emojiButton.addTarget(self, action: #selector(clickEmojiButton), for: .touchUpInside)
        addSubview(emojiButton)

        textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.layer.cornerRadius = 8
        textView.backgroundColor = .white
        textView.inputAccessoryView = UIInputView(frame: .zero, inputViewStyle: .keyboard)
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.isScrollEnabled = false
        textView.delegate = self
        addSubview(textView)

        setupLayout()
    }

    private func setupLayout() {
        voiceButton.snp.makeConstraints { make in
            make.width.equalTo(btnwh)
            make.height.equalTo(btnwh)
            make.left.equalToSuperview().offset(margin)
            make.bottom.equalToSuperview().offset(-margin)
        }

        addButton.snp.makeConstraints { make in
            make.width.equalTo(btnwh)
            make.height.equalTo(btnwh)
            make.right.equalToSuperview().offset(-margin)
            make.bottom.equalTo(voiceButton)
        }

        emojiButton.snp.makeConstraints { make in
            make.width.equalTo(btnwh)
            make.height.equalTo(btnwh)
            make.right.equalTo(addButton.snp.left).offset(-margin)
            make.bottom.equalTo(voiceButton)
        }

        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(margin)
            make.left.equalTo(voiceButton.snp.right).offset(margin)
            make.right.equalTo(emojiButton.snp.left).offset(-margin)
            make.bottom.equalTo(voiceButton)
            make.height.lessThanOrEqualTo(32)
        }
    }
}

// MARK: - UITextViewDelegate

extension InputBar: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText newText: String) -> Bool {
        if newText == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return textView.text.count + (newText.count - range.length) <= 500
    }

    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.bounds.width - textView.textContainerInset.left - textView.textContainerInset.right, height: CGFloat(MAXFLOAT))
        let height = textView.text.size(for: textView.font!, size: size, lineBreakMode: .byCharWrapping).height
        
        textView.isScrollEnabled = height >= maxHeight

        if textHeight != height && height < maxHeight {
            textView.setContentOffset(.zero, animated: false)
            textHeight = height + 1
            textView.snp.updateConstraints { make in
                make.height.lessThanOrEqualTo(textHeight + textView.textContainerInset.top + textView.textContainerInset.bottom)
            }
            layoutIfNeeded()
        }
    }
}

extension String {
    func size(for font: UIFont, size: CGSize, lineBreakMode: NSLineBreakMode) -> CGSize {
        var attr: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        if lineBreakMode != .byWordWrapping {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = lineBreakMode
            attr[.paragraphStyle] = paragraphStyle
        }
        let rect = (self as NSString).boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attr, context: nil)
        return rect.size
    }
}