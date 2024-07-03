//
//  FilterListViewController.swift
//  CameraTest
//
//  Created by 이숭인 on 7/3/24.
//

import UIKit
import Then
import SnapKit
import Combine
import CombineCocoa

final class FilterListView: BaseView {
    let tableView = UITableView(frame: .zero, style: .plain)
    
    override func setupSubviews() {
        addSubview(tableView)
    }
    
    override func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}

final class FilterListViewController: ViewController<FilterListView> {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    private func setupTableView() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.tableView.register(FilterCell.self, forCellReuseIdentifier: FilterCell.reuseIdentifier)
    }
}

extension FilterListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        CIFilterType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterCell.reuseIdentifier, for: indexPath) as? FilterCell else {
            return UITableViewCell()
        }
        
        let filterType = CIFilterType.allCases[indexPath.row]
        cell.configure(title: filterType.rawValue)
        
        return cell
    }
}

extension FilterListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filterType = CIFilterType.allCases[indexPath.row]
        
        let filterViewController = HomeViewController(filterType: filterType)
        navigationController?.pushViewController(filterViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
