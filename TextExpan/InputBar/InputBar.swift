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
    var maxTextLength: Int = 500

    private var emojiButton: UIButton!
    private var voiceButton: UIButton!
    private var addButton: UIButton!

    private lazy var emojiListView: EmojiListView = {
        let view = EmojiListView()
        return view
    }()

    private var showEmoji: Bool = false

    private let maxHeight: CGFloat = 100
    private let minHeight: CGFloat = 40

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
        return textView.text.count + (newText.count - range.length) <= maxTextLength
    }

    func textViewDidChange(_ textView: UITextView) {
        let bounds = textView.bounds
        let newSize = textView.sizeThatFits(CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude))
        var newHeight = CGFloat(ceilf(Float(newSize.height)))
        
        if newHeight == bounds.height {
            return
        }
        if newHeight <= minHeight && bounds.height <= minHeight {
            return
        }
        if newHeight > maxHeight && bounds.height >= maxHeight {
            return
        }
        if newHeight >= maxHeight {
            newHeight = maxHeight
        }
        textView.isScrollEnabled = newHeight >= maxHeight

        textView.setContentOffset(.zero, animated: false)
        textView.snp.updateConstraints { make in
            make.height.lessThanOrEqualTo(newHeight)
        }
        layoutIfNeeded()
    }
}

