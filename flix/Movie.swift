//
//  Movie.swift
//  flix
//
//  Created by Ben Jones on 10/15/16.
//  Copyright © 2016 Ben Jones. All rights reserved.
//

import UIKit

class Movie: NSObject {
    
    let imageBase = "https://image.tmdb.org/t/p/"
    
    var title : String
    var posterFile : String
    var runtimeMinutes : NSInteger
    var overview : String
    var popularity : NSNumber
    var releaseDate : Date
    var trailerKey : String?
    
    
    init(_ dictionary: NSDictionary) {
        title = (dictionary.value(forKey: "original_title") as? String) ?? ""
        posterFile = (dictionary.value(forKeyPath: "poster_path") as? String) ?? ""
        //NSURL(string: imageBase + "w185" + posterFile)
        overview = (dictionary.value(forKeyPath: "overview") ?? "") as! String
        popularity = (dictionary.value(forKeyPath: "popularity") ?? 0) as! NSNumber
        runtimeMinutes = (dictionary.value(forKeyPath: "runtime") ?? 0) as! NSInteger
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        releaseDate = dateFormatter.date(from: (dictionary.value(forKeyPath: "release_date") as? String) ?? "") ?? Date.init()
        
        
        let videos = ((dictionary.value(forKeyPath: "videos.results") as? [NSDictionary]) ?? [])
        for vid in videos {
            if(vid.value(forKeyPath: "site") as? String == "YouTube"){
                trailerKey = vid.value(forKeyPath: "key") as? String
                break
            }
        }
        
        
        
    }
    
    func posterImageUrl(size:String) -> URL {
        return URL(string: imageBase + size + self.posterFile)!
    }

}
