//
//  AnimeDetailsViewController.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 23/01/21.
//

import UIKit
import Kingfisher
import Cosmos
//import RealmSwift

class AnimeDetailsViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var labelAnimeTitle: UILabel!
    @IBOutlet weak var imageAnime: UIImageView!
    @IBOutlet weak var labelSynopsis: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelAnimeType: UILabel!
    @IBOutlet weak var labelAnimeSource: UILabel!
    @IBOutlet weak var labelAnimeEpisodes: UILabel!
    @IBOutlet weak var labelAnimeRank: UILabel!
    @IBOutlet weak var labelAnimeScore: UILabel!
    @IBOutlet weak var labelAnimeStatus: UILabel!
    @IBOutlet weak var buttonWatchTrailler: UIButton!
    @IBOutlet weak var viewUserFunctions: UIView!
    @IBOutlet weak var labelUserEpisodes: UILabel!
    @IBOutlet weak var buttonFavorite: UIButton!
    @IBOutlet weak var rateFiveStar: CosmosView!
    @IBOutlet weak var viewUserEpi: UIView!
    @IBOutlet weak var viewStarred: UIView!
    @IBOutlet weak var stepperEpisodes: UIStepper!
    
    // MARK: - Attributes
    var animeId: Int?
    var animeManager = AnimeManager()
    var animeRepo = AnimeRepository()
    var anime: Anime?
    var userEpisodes: Int?
    var animeTrailer: String?
    
    // MARK: - View Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        animeManager.delegate = self
        
        guard let id = animeId else { return }
        animeManager.fetchAnimeDetails(byId: id)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        renderButtonWatch()
        updateRatingCosmos()
    }
    
    // MARK: - Actions
    @IBAction func buttonFavoritePressed(_ sender: UIButton) {
        
        let imageButton = sender.currentImage
        guard let animeSafe = anime else { return }
        
        
        if imageButton == UIImage(systemName: "heart") {
            buttonFavorite.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            animeSafe.isFavorite = true
            
            animeRepo.addFavorite(animeSafe)
            
            viewUserEpi.isHidden = false
            viewStarred.isHidden = false
        
        } else {
            buttonFavorite.setImage(UIImage(systemName: "heart"), for: .normal)
            animeSafe.isFavorite = false
            
            animeRepo.removeFavorite(id: animeSafe.id)
            
            viewUserEpi.isHidden = true
            viewStarred.isHidden = true
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeFavorites"), object: nil)
        
    }
    
    @IBAction func stepperUserEpisodes(_ sender: UIStepper) {
        userEpisodes = Int(sender.value)
        labelUserEpisodes.text = String(userEpisodes ?? 1)
        anime?.userEpisodes = labelUserEpisodes.text ?? "1"
        
        if let animeSafe = anime {
            animeRepo.updateUserEpisodes(animeSafe, userEpisodes: animeSafe.userEpisodes)
        }
        
    }
    
    @IBAction func buttonTrailerPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: K.segueToTrailer, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segueToTrailer {
            
            let destinationVC = segue.destination as! TrailerViewController
            
            if let trailer = animeTrailer {
                destinationVC.animeTrailer = trailer
            }
        }
    }
    
    // MARK: - Methods
    func updateAnimeDetails(_ anime: Anime?) {
        labelAnimeTitle.text = anime?.title ?? "Sem Título Encontrado"
        
        anime?.getImageCache(uiImageView: imageAnime)
        
        labelAnimeType.text = anime?.type ?? "-"
        labelAnimeSource.text = anime?.source ?? "-"
        labelAnimeRank.text = anime?.rankString
        labelAnimeScore.text = "\(anime?.score ?? 0.0)"
        labelAnimeStatus.text = anime?.status
        labelSynopsis.text = anime?.synopsis ?? "Sem Sinopse"
        animeTrailer = anime?.trailerUrl ?? ""
        
        if let episodes = anime?.episodes {
            labelAnimeEpisodes.text = "\(episodes)"
        } else {
            labelAnimeEpisodes.text = "?"
        }
        
        if let idSafe = anime?.id {
            let isFavorite = animeRepo.isFavorited(id: idSafe)
            
            if isFavorite {
                buttonFavorite.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                viewUserEpi.isHidden = false
                viewStarred.isHidden = false
                
                labelUserEpisodes.text = animeRepo.getAnimeFavoriteUserEpisodes(id: idSafe)
                if let valueUserEpisodes = Double(labelUserEpisodes.text ?? "1.0") {
                    stepperEpisodes.value = valueUserEpisodes
                }
                
                let evaluation = animeRepo.getAnimeFavoriteEvaluation(id: idSafe)
               
                if let evaluationDouble = Double(evaluation) {
                    print("evaluation ===== \(evaluationDouble)")
                    rateFiveStar.rating = evaluationDouble
                }
                
                anime?.isFavorite = true
                
            } else {
                buttonFavorite.setImage(UIImage(systemName: "heart"), for: .normal)
                viewUserEpi.isHidden = true
                viewStarred.isHidden = true
                anime?.isFavorite = false
            }
        }

    }
    
    func renderButtonWatch() {
        buttonWatchTrailler.layer.cornerRadius = 5
        buttonWatchTrailler.layer.borderWidth = 1
        buttonWatchTrailler.layer.borderColor = CGColor(red: 24.0/255.0, green: 119.0/255.0, blue: 1.0, alpha: 1.0)
    }
    
    func updateRatingCosmos() {
        rateFiveStar.didFinishTouchingCosmos = { rating in
            if let animeSafe = self.anime {
                let ratingString = String(describing: rating)
                self.animeRepo.updateUserEvaluation(animeSafe, userEvaluation: ratingString)
            }
        }
    }
}

// MARK: - Anime Manager Delegate
extension AnimeDetailsViewController: AnimeManagerDelegate {
    func getInformtationAnime(_ animeNetwork: AnimeManager, animes: [Anime]) {
        
        DispatchQueue.main.async {
            self.anime = animes.first
            self.updateAnimeDetails(self.anime)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
    
    
}
