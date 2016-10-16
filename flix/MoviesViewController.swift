//
//  ViewController.swift
//  flix
//
//  Created by Ben Jones on 10/15/16.
//  Copyright © 2016 Ben Jones. All rights reserved.
//

import UIKit
import Alamofire
import VHUD

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var movies:[NSDictionary] = []
    var listType : String!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var content = VHUDContent(.loop(3.0))
        content.loadingText = "loading....."
        VHUD.show(content)
        
        // Set up table
        tableView.dataSource = self
        tableView.delegate = self
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadData(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        
        
        
        loadData(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.benjones.movielistcell", for: indexPath as IndexPath) as! MovieListItemCell
        let movie = movies[indexPath.row]
        cell.titleLabel.text = (movie.value(forKey: "original_title") ?? "") as? String
        let imageFile = (movie.value(forKeyPath: "poster_path") as? String) ?? ""
        let imgPath = URL(string: "https://image.tmdb.org/t/p/w185" + imageFile)!
        cell.posterImage.af_setImage(withURL: imgPath)
        cell.movieID = ((movie.value(forKey: "id")  as? NSNumber) ?? 0).stringValue
        cell.descriptionLabel.text = ((movie.value(forKey: "overview")  as? String) ?? "")
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        // do something here
        
    }
    
    func loadData(_ refreshControl:UIRefreshControl?){
        // netwerk
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        
        
        Alamofire.request("https://api.themoviedb.org/3/movie/\(listType!)?api_key=\(apiKey)").validate().responseJSON { response in
            switch response.result {
            case .success:
                print("Validation Successful")
                let data = response.result.value as! NSDictionary
                self.movies = data.value(forKeyPath: "results") as! [NSDictionary]
                self.tableView.reloadData()
                
                if let refreshControlNotNil = refreshControl{
                    refreshControlNotNil.endRefreshing()
                }
            case .failure(let error):
                print(error)
            }
            VHUD.dismiss(0.1)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! MovieListItemCell
        //        let indexPath = tableView.indexPath(for: cell)
        //        let post = posts[indexPath?.row]
        let detailViewController = segue.destination as! MovieDetailViewController
        detailViewController.movieID = cell.movieID
        //detailViewController.photoUrl = cell.imageUrl
        
    }
   

}

