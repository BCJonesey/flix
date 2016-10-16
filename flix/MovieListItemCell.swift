//
//  MovieListItemCell.swift
//  flix
//
//  Created by Ben Jones on 10/15/16.
//  Copyright © 2016 Ben Jones. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieListItemCell: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var movieID : String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
