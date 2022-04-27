//
//  LaunchScreenViewController.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 4/27/22.
//

import UIKit
import Lottie
import SnapKit

final class LaunchScreenViewController: UIViewController {
    // MARK: - Views
    private lazy var animationView: LOTAnimationView = {
        let uiview = LOTAnimationView(name: "launchScreenAnimation", bundle: Bundle(for: LoadingView.self))
        uiview.contentMode = .scaleAspectFit
        uiview.loopAnimation = true
        return uiview
    }()

    // MARK: - Life Cycle View
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 245/255, green: 195/255, blue: 133/255, alpha: 1)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showAnimation(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showAnimation(false)
            UIApplication.shared.keyWindow?.rootViewController = AnimeTabBarController()
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
    
 // MARK: - Layout
extension LaunchScreenViewController: CodeView {
    func buildViewHierarchy() {
        self.view.addSubview(animationView)
    }
    
    func buildConstraints() {
        animationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(300)
        }
    }
}

extension LaunchScreenViewController {
    public func showAnimation(_ isShown: Bool = true) {
        isShown ? startAnimating() : stopAnimating()
    }
    
    private func startAnimating() {
        animationView.animationProgress = 0.20
        animationView.play()
        UIView.animate(withDuration: 0.2) {
            self.animationView.alpha = 1
        }
    }
    
    private func stopAnimating() {
        UIView.animate(withDuration: 0.2) {
            self.animationView.alpha = 0
        } completion: { [animationView] _ in
            animationView.stop()
        }
    }
}
