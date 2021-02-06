//
//  TrailerViewController.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 25/01/21.
//

import UIKit
import youtube_ios_player_helper

class TrailerViewController: UIViewController {
    
    @IBOutlet weak var playerView: YTPlayerView!
    
    var animeTrailer: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerView.delegate = self
        
        if let trailer = animeTrailer,
           let videoId = getVideoID(from: trailer) {
            playerView.load(withVideoId: videoId, playerVars: ["playsinline": "1"])
        }

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
