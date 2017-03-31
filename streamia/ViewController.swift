//
//  ViewController.swift
//  streamia
//
//  Created by Jonathan Fuentes Flores on 3/30/17.
//  Copyright © 2017 appollo. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let trailer = URL(string: "http://movietrailers.apple.com/movies/paramount/ghost-in-the-shell/ghost-in-the-shell-trailer-1_480p.mov") {
            let movie = Movie(title: "Ghost in the shell", mediaURL: trailer)
            play(media: movie)
        }
    }

    func play<T: Playable>(media: T) {
        
        let player = AVPlayer(url: media.mediaURL!)

        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        present(playerViewController, animated: true) {
            playerViewController.player?.play()
        }
    }
}
