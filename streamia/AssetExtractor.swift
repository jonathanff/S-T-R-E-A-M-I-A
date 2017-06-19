//
//  AssetExtractor.swift
//
//Created by tadija in an stack overflow answer
//https://stackoverflow.com/questions/21769092/can-i-get-a-nsurl-from-an-xcassets-bundle/39748919#39748919
//

import Foundation
import UIKit

class AssetExtractor {
    
    static func createLocalUrl(forImageNamed name: String) -> URL? {
        
        let fileManager = FileManager.default
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let url = cacheDirectory.appendingPathComponent("\(name).png")
        let path = url.path
        
        guard fileManager.fileExists(atPath: path) else {
            guard let image = UIImage(named: name),
                let data = UIImagePNGRepresentation(image) else { return nil }
            
            fileManager.createFile(atPath: path, contents: data, attributes: nil)
            return url
        }
        
        return url
    }
}
