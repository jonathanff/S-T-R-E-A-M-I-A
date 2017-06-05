//
//  HomeViewController.swift
//  streamia
//
//  Created by Jonathan Fuentes Flores on 4/16/17.
//  Copyright © 2017 appollo. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class HomeViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var tableView: UITableView!
    var movies = [Movie]()
    var collections = [Collection]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Stremia"

        guard let path = Bundle.main.path(forResource: "movies", ofType: "plist"),
        let collectionsJSON = NSDictionary(contentsOfFile: path) as? [String : [[String : Any ]]] else { return }
        
        if let collectionsJSON = collectionsJSON["collections"] {
            for collectionJSON in collectionsJSON {
                guard let title = collectionJSON["title"] as? String else { break }
                if let itemsJSON = collectionJSON["items"] as? [[String : Any ]] {
                    var collectionItems = [Movie]()
                    for itemJSON in itemsJSON {
                        var movie = Movie()
                        movie.title = itemJSON["title"] as? String
                        movie.year = itemJSON["year"] as? String
                        movie.length = itemJSON["length"] as? Int
                        movie.playhead = itemJSON["playhead"] as? Int
                        movie.synopsis = itemJSON["synopsis"] as? String
                        movie.classification = itemJSON["classification"] as? String
                        movie.posterImageName169 = itemJSON["poster_16_9"] as? String
                        movie.posterImageName43 = itemJSON["poster_4_3"] as? String
                        if let mediURLString = itemJSON["mediaURL"] as? String,
                            let mediaURL = URL(string: mediURLString) {
                            movie.mediaURL = mediaURL
                        }
                        
                        collectionItems.append(movie)
                    }
                    
                    let collection = Collection(title: title, collectionItems: collectionItems)
                    self.collections.append(collection)
                }
            }
        }
        
        tableView.register(UINib.init(nibName:  String(describing: RailTableViewCell.self), bundle: nil), forCellReuseIdentifier:  String(describing: RailTableViewCell.self))
        tableView.register(UINib.init(nibName:  String(describing: HeaderTableViewCell.self), bundle: nil), forCellReuseIdentifier:  String(describing: HeaderTableViewCell.self))
    }
    
    func play<T: Playable>(media: T) {
        
        let player = AVPlayer(url: media.mediaURL!)
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        present(playerViewController, animated: true) {
            playerViewController.player?.play()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            return CGSize(width: view.frame.size.width, height: view.frame.size.width / 16 * 9)
        }
        
        return CGSize(width: 93, height: 124)
    }
    
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let collection = collections[indexPath.row]
        if indexPath.row == 0 {
            guard let headerCell = tableView.dequeueReusableCell(withIdentifier: String(describing: HeaderTableViewCell.self)) as? HeaderTableViewCell else { return UITableViewCell() }
            headerCell.collectionView.dataSource = self
            headerCell.collectionView.delegate = self
            headerCell.collectionView.tag = indexPath.row
            let headerCollection = collection
                headerCell.pageControl.numberOfPages = headerCollection.collectionItems.count
            
            
            return headerCell
        }
        
        guard let railCell = tableView.dequeueReusableCell(withIdentifier:  String(describing: RailTableViewCell.self)) as? RailTableViewCell else { return UITableViewCell() }
        railCell.collectionView.tag = indexPath.row
        railCell.collectionView.dataSource = self
        railCell.collectionView.delegate = self
        
        railCell.title.text = collection.title
        
        return railCell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let collection = collections[collectionView.tag]
        if let movie = collection.collectionItems[indexPath.row] as? Movie {
            let selectedMovieViewController = MovieViewController.newWithMovie(movie: movie)
            self.navigationController?.pushViewController(selectedMovieViewController, animated: true)
//            play(media: movie)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width))
        if let headerCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? HeaderTableViewCell, scrollView == headerCell.collectionView {
            headerCell.pageControl.currentPage = Int(currentPage)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let collection = collections[collectionView.tag]
        return collection.collectionItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collection = collections[collectionView.tag]
        let movie = collection.collectionItems[indexPath.row]
        
        if collectionView.tag == 0 {
            guard let headerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HeaderCollectionViewCell.self), for: indexPath) as? HeaderCollectionViewCell else { return UICollectionViewCell() }
            
            if let poster169ImageName = movie.posterImageName169 {
                headerCollectionViewCell.imageView.image = UIImage(named: poster169ImageName)
            }
            
            return headerCollectionViewCell
        }
        
        guard let posterCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PosterCollectionViewCell.self), for: indexPath) as? PosterCollectionViewCell else { return UICollectionViewCell() }
        
        if let poster43ImageName = movie.posterImageName43 {
            posterCell.imageView.image = UIImage(named: poster43ImageName)
        }
        
        return posterCell
    }
}
