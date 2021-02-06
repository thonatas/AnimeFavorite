//  ViewController.swift
//  Created by Thonatas Borges on 20/01/21.

import UIKit
import Kingfisher
import RealmSwift

class AnimeListViewController: UIViewController {
    
    // MARK: - Attributes
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var animeNetwork = AnimeManager()
    var animes: [Anime] = []
    
    // MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        animeNetwork.delegate = self
        animeNetwork.fetchAnimeList(by: "members")
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.animeListCellNibName, bundle: nil), forCellReuseIdentifier: K.animeListReusableCell)
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
    }
    
    // MARK: - Actions
    @IBAction func reloadData(_ sender: UIBarButtonItem) {
        tableView.reloadData()
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
                
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            animeNetwork.fetchAnimeList(by: "members")
        case 1:
            animeNetwork.fetchAnimeList(by: "score")
        case 2:
            animeNetwork.fetchAnimeList(by: "type")
        default:
            break
        }

        tableView.reloadData()
    }
    
}

// MARK: - Table View Data Source
extension AnimeListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let anime = animes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.animeListReusableCell, for: indexPath) as! AnimeListTableViewCell

        anime.getImageCache(uiImageView: cell.imageAnime)
        
        cell.label.text = anime.title
        
        return cell
    }

}

// MARK: - Table View Delegate
extension AnimeListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.segueListToDetails, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AnimeDetailsViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.animeId = animes[indexPath.row].id
        }
    }
}


// MARK: - Search Bar Delegate
extension AnimeListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let animeSearch = searchBar.text!
        animeNetwork.fetchAnimeSearch(for: animeSearch)
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
        
        tableView.reloadData()

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            animeNetwork.fetchAnimeList(by: "members")
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

// MARK: - Anime Network Delegate
extension AnimeListViewController: AnimeManagerDelegate {
    func getInformtationAnime(_ animeNetwork: AnimeManager, animes: [Anime]) {
        DispatchQueue.main.async {
            self.animes = animes
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
}

