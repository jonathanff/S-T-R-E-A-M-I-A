//
//  HomeViewController.swift
//  streamia
//
//  Created by Jonathan Fuentes Flores on 4/16/17.
//  Copyright © 2017 appollo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var tableView: UITableView!
    var movies = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Stremia"

        guard let path = Bundle.main.path(forResource: "movies", ofType: "plist"),
        let moviesJSON = NSDictionary(contentsOfFile: path) as? [String : [[String : Any ]]] else { return }

        if let movies = moviesJSON["movies"] {
            for movieJSON in movies {
                var movie = Movie()
                movie.title = movieJSON["title"] as? String
                movie.posterImageName169 = movieJSON["poster_16_9"] as? String
                movie.posterImageName43 = movieJSON["poster_4_3"] as? String
                self.movies.append(movie)
            }
        }
        
        
        
        tableView.register(UINib.init(nibName:  String(describing: RailTableViewCell.self), bundle: nil), forCellReuseIdentifier:  String(describing: RailTableViewCell.self))
        tableView.register(UINib.init(nibName:  String(describing: HeaderTableViewCell.self), bundle: nil), forCellReuseIdentifier:  String(describing: HeaderTableViewCell.self))
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let headerCell = tableView.dequeueReusableCell(withIdentifier:  String(describing: HeaderTableViewCell.self)) as? HeaderTableViewCell else { return UITableViewCell() }
            headerCell.collectionView.dataSource = self
            headerCell.collectionView.delegate = self
            
            headerCell.collectionView.tag = indexPath.row
            return headerCell
        }
        
        guard let railCell = tableView.dequeueReusableCell(withIdentifier:  String(describing: RailTableViewCell.self)) as? RailTableViewCell else { return UITableViewCell() }
        railCell.collectionView.tag = indexPath.row
        railCell.collectionView.dataSource = self
        railCell.collectionView.delegate = self
        
        return railCell
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = movies[indexPath.row]

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
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            return CGSize(width: view.frame.size.width, height: view.frame.size.width / 16 * 9)
        }
        
        return CGSize(width: 93, height: 124)
    }
    
}
