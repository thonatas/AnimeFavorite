//
//  ThemesViewController.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 4/27/22.
//

import UIKit
import Kingfisher
import RealmSwift
import SnapKit

class ThemesViewController: UIViewController, Themeable {
    // MARK: - Views
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = mainColor
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = secondaryColor
        return tableView
    }()
    
    // MARK: - Constants and Variables
    private var viewModel: ThemesViewModel?
    
    // MARK: - Initializers
    init(viewModel: ThemesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = mainColor
        self.title = "Temas"
        self.setupView()
    }
}

// MARK: - Layout
extension ThemesViewController: CodeView {
    func buildViewHierarchy() {
        self.view.addSubview(tableView)
    }
    
    func buildConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(15)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }
}

// MARK: - Table View Data Source
extension ThemesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.themes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let theme = viewModel?.themes[indexPath.row]
        cell.selectionStyle = .gray
        cell.textLabel?.text = theme?.title
        cell.textLabel?.textColor = viewModel?.currentTheme.appTheme.textColor
        cell.backgroundColor = viewModel?.currentTheme.appTheme.mainColor
        return cell
    }
}

// MARK: - Table View Delegate
extension ThemesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let theme = viewModel?.themes[indexPath.row] else { return }
        self.viewModel?.select(theme: theme)
    }
}

