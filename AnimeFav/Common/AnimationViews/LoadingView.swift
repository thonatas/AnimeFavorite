//
//  LoadingView.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 4/26/22.
//

import UIKit
import Lottie
import SnapKit

final public class LoadingView: UIView {
    
    private lazy var animationView: LOTAnimationView = {
        let uiview = LOTAnimationView(name: "loadingAnimation", bundle: Bundle(for: LoadingView.self))
        uiview.contentMode = .scaleAspectFit
        uiview.loopAnimation = true
        return uiview
    }()
    
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.tintColor = .white
        label.textAlignment = .center
        return label
    }()
    
    public init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        addLoadingView()
        addLoadingLabel()
    }
    
    func addLoadingView() {
        self.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
    }
    
    func addLoadingLabel() {
        self.addSubview(loadingLabel)
        loadingLabel.snp.makeConstraints { make in
            make.top.equalTo(animationView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    public func showAnimation(_ isShown: Bool = true) {
        isShown ? startAnimating() : stopAnimating()
    }
    
    private func startAnimating() {
        let currentWindow: UIWindow? = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        self.frame = currentWindow!.bounds
        self.alpha = 0
        currentWindow?.addSubview(self)
        animationView.animationProgress = 0.20
        animationView.play()
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
    }
    
    private func stopAnimating() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0
        } completion: { [animationView] _ in
            animationView.stop()
            self.removeFromSuperview()
        }
    }
    
    public func setLoadingText(_ text: String) {
        loadingLabel.text = text
    }
}

