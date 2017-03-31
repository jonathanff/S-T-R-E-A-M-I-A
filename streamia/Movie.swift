//
//  Movie.swift
//  streamia
//
//  Created by Jonathan Fuentes Flores on 3/30/17.
//  Copyright © 2017 appollo. All rights reserved.
//

import Foundation

protocol Media {
    var title: String? { get set }
}

protocol Playable {
    var mediaURL: URL? { get set }
}

struct Movie : Media, Playable {
    internal var title: String? 
    internal var mediaURL: URL?
}
