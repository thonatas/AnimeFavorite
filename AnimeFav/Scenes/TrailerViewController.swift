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
        label.font = UIFont.systemFont(ofSize: 27, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var playerView: YTPlayerView = {
        let playerView = YTPlayerView()
        playerView.delegate = self
        return playerView
    }()
    
    var animeTrailer: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
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
            make.height.equalTo((view.frame.width)/9)
        }
        
        playerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(496)
        }
    }
}

// MARK: - YTPlayerView Delegate
extension TrailerViewController: YTPlayerViewDelegate {
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
        case .buffering:
            print("Buffering")
        case .ended:
            print("Ended")
        case .paused:
            print("Paused")
        case .playing:
            print("Playing")
        case .unknown:
            print("Unknown")
        case .unstarted:
            print("Unstarted")
        default:
            break
        }
    }
}
