//
//  FilterCell.swift
//  CameraTest
//
//  Created by 이숭인 on 7/3/24.
//

import UIKit
import SnapKit
import Then

final class FilterCell: UITableViewCell {
    static let reuseIdentifier = String(describing: FilterCell.self)
    
    let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func setupSubviews() {
        contentView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
