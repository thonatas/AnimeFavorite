//
//  AnimeDetailsViewController.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 23/01/21.
//

import UIKit
import Kingfisher
import Cosmos
import RealmSwift

protocol AnimeRepositoryProtocol: AnyObject {
    func didRefreshRepository()
}

class AnimeDetailsViewController: UIViewController {
    // MARK: - Views
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Favorites"
        label.font = UIFont.systemFont(ofSize: 27, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private let animeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5.0
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "arrow.2.circlepath.circle")
        return imageView
    }()
    
    private let animeTypeView: AnimeInfoView = {
        let animeInfoView = AnimeInfoView()
        animeInfoView.title = "TIPO"
        animeInfoView.descriptionText = "?"
        return animeInfoView
    }()
    
    private let animeSourceView: AnimeInfoView = {
        let animeInfoView = AnimeInfoView()
        animeInfoView.title = "ORIGEM"
        animeInfoView.descriptionText = "?"
        return animeInfoView
    }()
    
    private let animeEpisodesView: AnimeInfoView = {
        let animeInfoView = AnimeInfoView()
        animeInfoView.title = "EPISÓDIOS"
        animeInfoView.descriptionText = "?"
        return animeInfoView
    }()
    
    private let animeRankView: AnimeInfoView = {
        let animeInfoView = AnimeInfoView()
        animeInfoView.title = "RANK"
        animeInfoView.descriptionText = "#?"
        return animeInfoView
    }()
    
    private let animeScoreView: AnimeInfoView = {
        let animeInfoView = AnimeInfoView()
        animeInfoView.title = "SCORE"
        animeInfoView.descriptionText = "0.0"
        return animeInfoView
    }()
    
    private let animeStatusView: AnimeInfoView = {
        let animeInfoView = AnimeInfoView()
        animeInfoView.title = "STATUS"
        animeInfoView.descriptionText = "?"
        return animeInfoView
    }()
    
    private let animeGradeView: AnimeInfoView = {
        let animeInfoView = AnimeInfoView()
        animeInfoView.title = "NOTA"
        return animeInfoView
    }()
    
    private let animeFavoriteView: AnimeInfoView = {
        let animeInfoView = AnimeInfoView()
        animeInfoView.title = "FAVORITO"
        return animeInfoView
    }()
    
    private lazy var trailerButton: UIButton = {
        let button = UIButton()
        let playImage = UIImage(systemName: "play.rectangle")?.withRenderingMode(.alwaysOriginal)
        button.setImage(playImage?.withTintColor(.systemBlue), for: .normal)
        button.setImage(playImage?.withTintColor(.systemGray), for: .disabled)
        button.setTitle(" Trailer", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.systemGray, for: .disabled)
        button.addTarget(self, action: #selector(trailerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var favoriteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "heart")
        let tap = UITapGestureRecognizer(target: self, action: #selector(favoriteImageViewTapped))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let episodesTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Qual episódio parei?"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private let episodesDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var episodesStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.stepValue = 1
        stepper.addTarget(self, action: #selector(episodesStepperValueChanged(_:)), for: .valueChanged)
        return stepper
    }()
    
    private let sinopsysTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return textView
    }()
    
    private lazy var fiveStarsCosmosView: CosmosView = {
        let cosmoView = CosmosView()
        cosmoView.settings.disablePanGestures = true
        cosmoView.settings.filledColor = .systemGray
        cosmoView.settings.emptyBorderColor = .systemGray
        cosmoView.settings.filledBorderColor = .systemGray
        cosmoView.isUserInteractionEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(updateRatingCosmos))
        cosmoView.addGestureRecognizer(tap)
        return cosmoView
    }()
    
    private var loadingView = LoadingView()
    
    // MARK: - Attributes
    private var animeTrailer: String?
    private var viewModel: AnimeDetailsViewModel?
    private var isFavorite: Bool = false {
        didSet {
            self.updateViews(isFavorite)
        }
    }
    private var episodes: String? {
        didSet {
            episodesDescriptionLabel.text = episodes ?? "1"
            episodesStepper.value = Double(episodes ?? "1") ?? 1.0
        }
    }
    weak var animeRepositoryProtocol: AnimeRepositoryProtocol?
    
    // MARK: - Initializers
    init(viewModel: AnimeDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.viewModel?.delegate = self
        self.isFavorite = viewModel?.anime.isFavorite ?? false
        self.setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel?.getAnimeDetails()
    }
}

// MARK: - Functions
extension AnimeDetailsViewController {
    // MARK: - Actions
    @objc
    private func favoriteImageViewTapped() {
        isFavorite.toggle()
        animeRepositoryProtocol?.didRefreshRepository()
    }
    
    @objc
    private func episodesStepperValueChanged(_ sender: UIStepper) {
        let userEpisodes = Int(sender.value)
        episodesDescriptionLabel.text = "\(userEpisodes)"
        viewModel?.updateUserEpisodes(userEpisodes)
    }
    
    @objc
    private func trailerButtonTapped() {
        let viewController = TrailerViewController()
        viewController.animeTrailer = animeTrailer
        self.present(viewController, animated: true)
    }
    
    @objc
    private func updateRatingCosmos() {
        fiveStarsCosmosView.settings.disablePanGestures = true
        fiveStarsCosmosView.didFinishTouchingCosmos = { rating in
            self.viewModel?.updateUserEvaluation(rating)
        }
    }
    
    private func updateViews(_ isFavorite: Bool) {
        favoriteImageView.image = UIImage(systemName: isFavorite ? "heart.fill" : "heart")
        fiveStarsCosmosView.isUserInteractionEnabled = isFavorite
        fiveStarsCosmosView.settings.filledColor = isFavorite ? .systemOrange : .systemGray
        fiveStarsCosmosView.settings.emptyBorderColor = isFavorite ? .systemOrange : .systemGray
        fiveStarsCosmosView.settings.filledBorderColor = isFavorite ? .systemOrange : .systemGray
        viewModel?.setFavoriteAnime(isFavorite)
        episodesStepper.isUserInteractionEnabled = isFavorite
        if !isFavorite {
            episodes = nil
        }
        
        self.loadViewIfNeeded()
    }
}

// MARK: - Layout
extension AnimeDetailsViewController: CodeView {
    func buildViewHierarchy() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(animeImageView)
        self.view.addSubview(animeTypeView)
        self.view.addSubview(animeSourceView)
        self.view.addSubview(animeEpisodesView)
        self.view.addSubview(animeRankView)
        self.view.addSubview(animeScoreView)
        self.view.addSubview(animeStatusView)
        self.view.addSubview(trailerButton)
        self.view.addSubview(episodesTitleLabel)
        self.view.addSubview(episodesDescriptionLabel)
        self.view.addSubview(episodesStepper)
        self.view.addSubview(animeFavoriteView)
        self.view.addSubview(animeGradeView)
        self.view.addSubview(favoriteImageView)
        self.view.addSubview(fiveStarsCosmosView)
        self.view.addSubview(sinopsysTextView)
    }
    
    func buildConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        animeImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
            make.width.equalToSuperview().multipliedBy(0.40)
            make.height.equalTo(animeImageView.snp.width).multipliedBy(1.8)
        }
        
        animeTypeView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.greaterThanOrEqualTo(animeImageView.snp.trailing).offset(10)
            make.width.equalTo(self.view.snp.width).multipliedBy(0.25)
        }
        
        animeSourceView.snp.makeConstraints { make in
            make.top.equalTo(animeTypeView.snp.bottom).offset(5)
            make.leading.greaterThanOrEqualTo(animeImageView.snp.trailing).offset(10)
            make.width.equalTo(self.animeTypeView.snp.width)
        }
        
        animeEpisodesView.snp.makeConstraints { make in
            make.top.equalTo(animeSourceView.snp.bottom).offset(5)
            make.leading.greaterThanOrEqualTo(animeImageView.snp.trailing).offset(10)
            make.width.equalTo(self.animeTypeView.snp.width)
        }
        
        animeRankView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalTo(animeTypeView.snp.trailing).offset(5)
            make.trailing.equalToSuperview().inset(10)
            make.width.equalTo(self.animeTypeView.snp.width)
        }
        
        animeScoreView.snp.makeConstraints { make in
            make.top.equalTo(animeRankView.snp.bottom).offset(5)
            make.leading.equalTo(animeSourceView.snp.trailing).offset(5)
            make.trailing.equalToSuperview().inset(10)
            make.width.equalTo(self.animeTypeView.snp.width)
        }
        
        animeStatusView.snp.makeConstraints { make in
            make.top.equalTo(animeScoreView.snp.bottom).offset(5)
            make.leading.equalTo(animeEpisodesView.snp.trailing).offset(5)
            make.trailing.equalToSuperview().inset(10)
            make.width.equalTo(self.animeTypeView.snp.width)
        }
        
        trailerButton.snp.makeConstraints { make in
            make.leading.equalTo(animeImageView.snp.trailing).offset(5)
            make.trailing.equalToSuperview().inset(10)
            make.height.equalTo(25)
        }
        
        episodesTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(trailerButton.snp.bottom).offset(15)
            make.leading.equalTo(animeImageView.snp.trailing).offset(10)
            make.trailing.equalTo(animeStatusView.snp.trailing)
        }
        
        episodesStepper.snp.makeConstraints { make in
            make.top.equalTo(episodesTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(episodesTitleLabel.snp.centerX).offset(-15)
            make.trailing.greaterThanOrEqualToSuperview().inset(10)
            make.bottom.equalTo(animeImageView.snp.bottom)
        }
        
        episodesDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(episodesTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(episodesTitleLabel.snp.leading)
            make.trailing.equalTo(episodesStepper.snp.leading).offset(-20)
            make.bottom.equalTo(animeImageView.snp.bottom)
        }
        
        animeFavoriteView.snp.makeConstraints { make in
            make.top.equalTo(animeImageView.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalTo(self.view.snp.centerX)
        }
        
        animeGradeView.snp.makeConstraints { make in
            make.top.equalTo(episodesStepper.snp.bottom).offset(25)
            make.leading.equalTo(self.view.snp.centerX)
            make.trailing.equalToSuperview().inset(10)
        }
        
        favoriteImageView.snp.makeConstraints { make in
            make.top.equalTo(animeFavoriteView.snp.bottom).offset(5)
            make.centerX.equalTo(animeFavoriteView.snp.centerX)
            make.size.equalTo(35)
        }
        
        fiveStarsCosmosView.snp.makeConstraints { make in
            make.top.equalTo(animeGradeView.snp.bottom).offset(15)
            make.centerX.equalTo(animeGradeView.snp.centerX)
        }
        
        sinopsysTextView.snp.makeConstraints { make in
            make.top.equalTo(animeImageView.snp.bottom).offset(110)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }
    
    func setupCustomConfiguration() {
        titleLabel.text = viewModel?.anime.title
        viewModel?.anime.getImageCache(uiImageView: animeImageView)
        animeTypeView.descriptionText = viewModel?.anime.type ?? "-"
        animeScoreView.descriptionText = String(format: "%.2f", viewModel?.anime.score ?? 0.0)
        animeStatusView.descriptionText = viewModel?.anime.status
        animeEpisodesView.descriptionText = "\(viewModel?.anime.episodes ?? 0)"
        animeTrailer = viewModel?.anime.trailerUrl
        fiveStarsCosmosView.rating = Double(self.viewModel?.anime.userEvaluation ?? "0.0") ?? 0.0
        episodes = self.viewModel?.anime.userEpisodes
    }
}

// MARK: - View Model Delegates
extension AnimeDetailsViewController: AnimeDetailsViewModelDelegate {
    func didGetAnimeDetails(_ animeDetails: AnimeResponse) {
        self.trailerButton.isEnabled = animeDetails.trailer?.url != nil
        self.animeTrailer = animeDetails.trailer?.url
        self.sinopsysTextView.text = animeDetails.synopsis ?? "Sem Sinopse"
        self.animeRankView.descriptionText = "#\(animeDetails.rank ?? 0)"
        self.animeSourceView.descriptionText = animeDetails.source ?? "-"
        self.sinopsysTextView.layoutIfNeeded()
    }
    
    func didGetAnimeDetailsWithError(_ error: String) {
        DispatchQueue.main.async {
            let alertControler = UIAlertController(title: "Erro!!!", message: error, preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "Fechar", style: .default)
            alertControler.addAction(closeAction)
            self.present(alertControler, animated: true)
        }
    }
    
    func didShowLoading(_ isShown: Bool) {
        self.loadingView.showAnimation(isShown)
    }
}
