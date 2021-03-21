//
//  InputView.swift
//  TextExpan
//
//  Created by lym on 2021/1/14.
//

import Foundation
import SnapKit
import UIKit

protocol InputBarDelegate: AnyObject {
    func didChangeInputHeight(height: CGFloat)
    func didChageState(state: InputBarState)
}

enum InputBarState {
    case normal
    case text
    case emoji
    case voice
    case add
}

class InputBar: UIView {
    weak var delegate: InputBarDelegate?

    var maxTextLength: Int = 500

    var barState: InputBarState = .normal

    private var showKeyboardButton: Bool = false {
        didSet {
            let image = UIImage(named: showKeyboardButton ? "btn_keyboard" : "btn_emoji")
            emojiButton.setBackgroundImage(image, for: .normal)
        }
    }

    private let textViewHeightMax: CGFloat = 84
    private let textViewHeightMin: CGFloat = 40
    private let margin: CGFloat = 8, btnwh: CGFloat = 34

    private var textView: UITextView!
    private var emojiButton: UIButton!
    private var voiceButton: UIButton!
    private var addButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan")
    }
}

extension InputBar {
    func refreshState(state: InputBarState) {
        self.barState = state
        showKeyboardButton = state == .emoji
        delegate?.didChageState(state: state)
    }
    
    func beginEdite() {
        textView.becomeFirstResponder()
    }
    
    func endEdite() {
        textView.resignFirstResponder()
    }
}

extension InputBar {
    @objc private func clickEmojiButton() {
        
        if barState != .emoji {
            refreshState(state: .emoji)
            showKeyboardButton = true
        } else {
            refreshState(state: .text)
            showKeyboardButton = false
        }
    }

    @objc private func clickVoiceButton() {
        // TODO: --
        print("TODO: --")
    }

    @objc private func clickAddButton() {
        if barState != .add {
            refreshState(state: .add)
        } else {
            refreshState(state: .text)
        }
    }
}

extension InputBar {
    private func setupUI() {
        voiceButton = UIButton()
        voiceButton.setBackgroundImage(UIImage(named: "btn_voice"), for: .normal)
        voiceButton.addTarget(self, action: #selector(clickVoiceButton), for: .touchUpInside)
        addSubview(voiceButton)

        addButton = UIButton(type: .custom)
        addButton.setBackgroundImage(UIImage(named: "btn_add"), for: .normal)
        addButton.addTarget(self, action: #selector(clickAddButton), for: .touchUpInside)
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
            make.height.equalTo(textViewHeightMin)
        }
    }
}

// MARK: - UITextViewDelegate

extension InputBar: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        showKeyboardButton = false
    }
    
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
        if newHeight <= textViewHeightMin && bounds.height <= textViewHeightMin {
            return
        }
        if newHeight > textViewHeightMax && bounds.height >= textViewHeightMax {
            return
        }
        if newHeight >= textViewHeightMax {
            newHeight = textViewHeightMax
        }
        textView.isScrollEnabled = newHeight >= textViewHeightMax

        textView.setContentOffset(.zero, animated: false)

        UIView.animate(withDuration: 0.25) {
            textView.snp.updateConstraints { make in
                make.height.equalTo(newHeight)
            }
            self.layoutIfNeeded()
        }
        self.delegate?.didChangeInputHeight(height: self.frame.size.height)
    }
}
