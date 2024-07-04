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
import RxSwift
import RxCocoa

import KakaoSDKUser
import RxKakaoSDKUser

final class FilterListView: BaseView {
    let loginButton = UIButton().then {
        $0.setTitle("카카오 로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemBlue
    }
    let tableView = UITableView(frame: .zero, style: .plain)
    
    override func setupSubviews() {
        addSubview(loginButton)
        addSubview(tableView)
    }
    
    override func setupConstraints() {
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(32)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}

final class FilterListViewController: ViewController<FilterListView> {
    let disposeBag = DisposeBag()
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        bindAction()
    }
    
    private func setupTableView() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.tableView.register(FilterCell.self, forCellReuseIdentifier: FilterCell.reuseIdentifier)
    }
    
    private func bindAction() {
        contentView.loginButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                print("login action")
                
                UserApi.shared.rx.loginWithKakaoAccount()
                    .subscribe(onNext:{ (oauthToken) in
                        print("loginWithKakaoAccount() success.")

                        //do something
                        let token = oauthToken
                        print("oauthToken > \(token)")
                    }, onError: {error in
                        print(error)
                    })
                    .disposed(by: self.disposeBag)
            }
            .store(in: &cancellables)
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
