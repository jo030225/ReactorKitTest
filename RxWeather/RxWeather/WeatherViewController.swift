//
//  WeatherViewController.swift
//  RxWeather
//
//  Created by 조주혁 on 2023/03/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class WeatherViewController: UIViewController {
    
    let reactor = WeatherReactor(useCase: DefaultWeatherUseCase(repository: WeatherRepository()))
    let disposeBag = DisposeBag()
    
    private lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Refresh", for: .normal)
        return button
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .large
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetting()
        bind(reactor: reactor)
    }
    
    private func layoutSetting() {
        view.backgroundColor = .white
        
        view.addSubview(tempLabel)
        view.addSubview(refreshButton)
        view.addSubview(activityIndicatorView)
        
        tempLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.trailing.lessThanOrEqualToSuperview().inset(10)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(tempLabel.snp.top).offset(-30)
        }
        
        activityIndicatorView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(refreshButton.snp.centerY).offset(-50)
        }
    }
    
    private func bind(reactor: WeatherReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: WeatherReactor) {
        reactor.action.onNext(.viewDidLoad)
        
        refreshButton.rx.tap
            .map { WeatherReactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: WeatherReactor) {
        reactor.state
            .map { $0.temp }
            .bind(to: tempLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
    }

}

