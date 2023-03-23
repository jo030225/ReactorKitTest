//
//  MainViewController.swift
//  ReactorKitTest
//
//  Created by 조주혁 on 2023/03/23.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ReactorKit

class MainViewController: UIViewController {

    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    private lazy var increaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private lazy var decreaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .large
        return view
    }()
    
    private var disposeBag = DisposeBag()
    private let reactor = MainReactor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetting()
        bind(reactor: reactor)
    }
    
    private func bind(reactor: MainReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: MainReactor) {
        increaseButton.rx.tap
            .map{ MainReactor.Action.increase }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        decreaseButton.rx.tap
            .map{MainReactor.Action.decrease}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: MainReactor) {
        reactor.state
            .map{"\($0.value)"}
            .distinctUntilChanged()
            .bind(to: valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map{$0.isLoading}
            .distinctUntilChanged()
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
    }

    private func layoutSetting() {
        view.backgroundColor = .white
        
        view.addSubview(valueLabel)
        view.addSubview(increaseButton)
        view.addSubview(decreaseButton)
        view.addSubview(activityIndicatorView)
        
        valueLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        increaseButton.snp.makeConstraints { make in
            make.centerY.equalTo(valueLabel.snp.centerY)
            make.leading.equalTo(valueLabel.snp.trailing).offset(10)
        }
        
        decreaseButton.snp.makeConstraints { make in
            make.centerY.equalTo(valueLabel.snp.centerY)
            make.trailing.equalTo(valueLabel.snp.leading).offset(-10)
        }
        
        activityIndicatorView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(valueLabel.snp.centerY).offset(50)
        }
    }

}

