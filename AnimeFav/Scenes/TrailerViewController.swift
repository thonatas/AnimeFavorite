//
//  TrailerViewController.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 25/01/21.
//

import UIKit
import youtube_ios_player_helper

class TrailerViewController: UIViewController {
    // MARK: - Views
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Trailer"
        label.textColor = .quaternaryColor
        label.font = UIFont.systemFont(ofSize: 27, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var playerView: YTPlayerView = {
        let playerView = YTPlayerView()
        return playerView
    }()
    
    private let aspectRatio = CGFloat(9.0/16.0)
    var animeTrailer: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .primaryColor
        if let trailer = animeTrailer,
           let videoId = getVideoID(from: trailer) {
            playerView.load(withVideoId: videoId, playerVars: ["playsinline": "1"])
        }
        self.setupView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        playerView.stopVideo()
    }
    
    func getVideoID(from urlString: String) -> String? {
        guard let url = urlString.removingPercentEncoding else { return nil }
        do {
            let regex = try NSRegularExpression.init(pattern: "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)", options: .caseInsensitive)
            let range = NSRange(location: 0, length: url.count)
            if let matchRange = regex.firstMatch(in: url, options: .reportCompletion, range: range)?.range {
                let matchLength = (matchRange.lowerBound + matchRange.length) - 1
                if range.contains(matchRange.lowerBound) &&
                    range.contains(matchLength) {
                    let start = url.index(url.startIndex, offsetBy: matchRange.lowerBound)
                    let end = url.index(url.startIndex, offsetBy: matchLength)
                    return String(url[start...end])
                }
            }
        } catch {
            print("Error GetID Youtube \(error.localizedDescription)")
        }
        return nil
    }
    
}

// MARK: - Layout
extension TrailerViewController: CodeView {
    func buildViewHierarchy() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(playerView)
    }
    
    func buildConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        playerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.center.equalToSuperview()
            make.height.equalTo((self.view.frame.width) * aspectRatio)
        }
    }
}
