//
//  MovieViewController.swift
//  streamia
//
//  Created by Jonathan Fuentes Flores on 6/3/17.
//  Copyright © 2017 appollo. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import CoreMedia

class MovieViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var movie: Movie? = nil
    
    class func newWithMovie(movie: Movie) -> MovieViewController {
        let movieStoryBoard = UIStoryboard(name: "Movie", bundle: nil)
        guard let movieViewController = movieStoryBoard.instantiateInitialViewController() as? MovieViewController else { return MovieViewController() }
        movieViewController.movie = movie
        
        return movieViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib.init(nibName: "MovieHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieHeaderTableViewCell")
        tableView.register(UINib.init(nibName: "MovieMetadataTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieMetadataTableViewCell")
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = movie?.title
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func play<T: Playable>(media: T, fromTheBeginning:Bool) {
        
        let player = AVPlayer(url: media.mediaURL!)
        if fromTheBeginning == false {
            if let playHead = media.playhead {
                let doublePlayHead = Double(playHead)
                let resumeTime = CMTime(seconds: doublePlayHead, preferredTimescale: 1)
                player.seek(to: resumeTime)
            }
        }
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        present(playerViewController, animated: true) {
            playerViewController.player?.play()
        }
    }
}

extension MovieViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieHeaderTableViewCell", for: indexPath) as? MovieHeaderTableViewCell else { return UITableViewCell() }
            
            if let poster169ImageName = movie?.posterImageName169 {
                cell.movieImage?.image = UIImage(named: poster169ImageName)
            }
            
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieMetadataTableViewCell", for: indexPath) as? MovieMetadataTableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = movie?.title
        cell.yearLabel.text = movie?.year
        cell.classificationLabel.text = movie?.classification
        
        if let movieLength = movie?.length {
            let hours: Int = movieLength / 3600
            let minutes: Int = (movieLength / 60) % 60
            
            cell.lengthLabel.text = String(format: "%02dh %02dm", hours, minutes)
        }
        
        cell.synopsisLabel.text = movie?.synopsis
        return cell
    }
}

extension MovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return tableView.frame.size.width / 16 * 9
        }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movie = movie else { return }
        if let playhead = movie.playhead, playhead > 0 {
            let alertController = UIAlertController(title: "Continue Playing", message: "", preferredStyle: .alert)
            let resumePlayback = UIAlertAction(title: "Start from beginning", style: .default, handler: { (action) in
                self.play(media: movie, fromTheBeginning: true)
            })
            alertController.addAction(resumePlayback)
            
            let fromTheBeginning = UIAlertAction(title: "Resume", style: .default, handler: { (action) in
                self.play(media: movie, fromTheBeginning: false)
            })
            alertController.addAction(fromTheBeginning)
            
            present(alertController, animated: true, completion: nil)
        } else {
            play(media: movie, fromTheBeginning: true)
        }
    }
}
