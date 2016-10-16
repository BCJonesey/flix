//
//  MovieDetailViewController.swift
//  flix
//
//  Created by Ben Jones on 10/15/16.
//  Copyright © 2016 Ben Jones. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class MovieDetailViewController: UIViewController {
    
    var movieID : String = ""
    var movie : Movie?

    
    @IBOutlet weak var crownImageView: UIImageView!
    @IBOutlet weak var clockImageView: UIImageView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        
        
        loadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func loadData(){
        // netwerk
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        
        
        Alamofire.request("https://api.themoviedb.org/3/movie/\(self.movieID)?api_key=\(apiKey)&append_to_response=videos").validate().responseJSON { response in
            switch response.result {
            case .success:
                self.movie = Movie(response.result.value as! NSDictionary)
                self.loadUI()
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func loadUI() {
        if let movie = self.movie{
            
            // load values
            posterImageView.frame = self.view.frame
            posterImageView.af_setImage(withURL: movie.posterImageUrl(size: "w500"))
            titleLabel.text = movie.title
            overviewLabel.text = movie.overview
            popularityLabel.text = "\(movie.popularity.intValue)%"
            
            let format = DateFormatter()
            format.dateFormat = "MMMM d, yyyy"
            releaseLabel.text = format.string(from: movie.releaseDate)
            
            runtimeLabel.text = "\(movie.runtimeMinutes / 60)hr \(movie.runtimeMinutes % 60)mins"
            
            
            
            // resize items && containers
            let detailsMargin = CGFloat(20)
            let contentTopMargin = CGFloat(15)
            let contentSideMargin = CGFloat(6)
            let iconMargin = CGFloat(3)
            
            
            let detailsWidth = self.view.frame.width - (detailsMargin * 2)
            let contentWidth = detailsWidth - (contentSideMargin * 2)
            let fullWidthMaxSize = CGSize(width: contentWidth, height: CGFloat.greatestFiniteMagnitude)
            var currentY = contentTopMargin
            
            
            // title
            titleLabel.frame = CGRect(x: contentSideMargin, y: currentY, width: contentWidth, height: titleLabel.sizeThatFits(fullWidthMaxSize).height)
            currentY += titleLabel.frame.height + 15
            
            // release date
            releaseLabel.frame = CGRect(x: contentSideMargin, y: currentY, width: contentWidth, height: releaseLabel.sizeThatFits(fullWidthMaxSize).height)
            currentY += releaseLabel.frame.height + 2
            
            
            // pop
            let popHeight = popularityLabel.sizeThatFits(fullWidthMaxSize).height
            crownImageView.frame = CGRect(x: contentSideMargin, y: currentY + 3, width: popHeight-6, height:popHeight-6)
            popularityLabel.frame = CGRect(x: iconMargin + crownImageView.frame.maxX, y: currentY, width: (contentWidth/2)-crownImageView.frame.width-iconMargin, height: popHeight)
            
            
            
            // runtime
            let runHeight = runtimeLabel.sizeThatFits(fullWidthMaxSize).height
            clockImageView.frame = CGRect(x: popularityLabel.frame.maxX, y: currentY+3, width: runHeight-6, height: runHeight-6)
            runtimeLabel.frame = CGRect(x: clockImageView.frame.maxX + iconMargin, y: currentY, width: (contentWidth/2) - iconMargin - clockImageView.frame.width, height: runHeight)
            
            
            
            
            currentY += max(popularityLabel.frame.height, runtimeLabel.frame.height) + 2
            
            // overview
            let test = overviewLabel.sizeThatFits(fullWidthMaxSize)
            overviewLabel.frame = CGRect(x: contentSideMargin, y: currentY, width: contentWidth, height: test.height)
            currentY += overviewLabel.frame.height
            currentY += contentTopMargin
            
            
            
            
            
            
            detailsView.frame = CGRect(x: detailsMargin, y: self.view.frame.height - CGFloat(100), width: detailsWidth, height: currentY)
            
            
            scrollView.contentSize.height = scrollView.bounds.height + (detailsView.frame.height - 80)
            scrollView.contentSize.width = scrollView.bounds.width
            
          
            
            
            
        }else{
            
        }
    }

}
