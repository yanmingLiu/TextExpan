//
//  SecondViewController.swift
//  TextExpan
//
//  Created by lym on 2021/3/1.
//

import UIKit

class SecondViewController: UIViewController {
    let cellId = "cell"
    
    var tableView: UITableView!

    var dataArray = [Int]()
    
    var inputBar: InputBar!
    
    var bottomSpace: UIView!
    
    // inputs view
    var switchingKeybaord: Bool = false
    
    let emojiListViewH: CGFloat = 420
    let addViewH: CGFloat = 200
    
    var showingListView: UIView?

    lazy var emojiListView: EmojiListView = {
        let listView = EmojiListView()
        listView.alpha = 0
        return listView
    }()

    lazy var addView: UIView = {
        let listView = UIView()
        listView.alpha = 0
        listView.backgroundColor = .systemPink
        return listView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...30 {
            dataArray.append(i)
        }
        
        view.backgroundColor = .white
        
        addTableView()
        addInputView()
        setupLayout()
        
        addNotification()
    }
    
    private func addTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTapTableView))
        tap.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tap)
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }

    private func addInputView() {
        inputBar = InputBar()
        inputBar.delegate = self
        view.addSubview(inputBar)
        
        bottomSpace = UIView()
        bottomSpace.backgroundColor = inputBar.backgroundColor
        view.addSubview(bottomSpace)
        
        view.addSubview(emojiListView)
        emojiListView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(emojiListViewH)
            make.top.equalTo(self.view.snp.bottom).offset(0)
        }

        view.addSubview(addView)
        addView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(addViewH)
            make.top.equalTo(self.view.snp.bottom).offset(0)
        }
    }
    
    private func setupLayout() {
        bottomSpace.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(UIWindow.safeAreaInsets.bottom)
        }
        
        inputBar.snp.makeConstraints { make in
            make.bottom.equalTo(bottomSpace.snp.top)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(inputBar.snp.top)
        }
    }
}


extension SecondViewController {
    @objc private func onTapTableView() {
        inputBar.refreshState(state: .normal)
    }
        
}



extension SecondViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        cell.contentView.backgroundColor = UIColor.random
        return UITableViewCell()
    }
}

extension SecondViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension UIColor {
    /// 随机颜色
    class var random: UIColor {
        return UIColor(red: CGFloat(arc4random() % 256) / 255.0, green: CGFloat(arc4random() % 256) / 255.0, blue: CGFloat(arc4random() % 256) / 255.0, alpha: 0.5)
    }
}
