//
//  Show.swift
//  streamia
//
//  Created by Jonathan Fuentes Flores on 4/16/17.
//  Copyright © 2017 appollo. All rights reserved.
//

import Foundation

struct Show {
    let name: String
    var seasons = [Season]()
}

struct Season {
    var episodes = [Episode]()
    let number: Int
}

struct Episode: Playable {
    internal var mediaURL: URL?
}
