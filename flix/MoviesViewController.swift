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

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UICollectionViewDataSource {
    
    
    var movies:[NSDictionary] = []
    var listType : String!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.frame = self.view.frame
        var content = VHUDContent(.loop(3.0))
        content.loadingText = "loading....."
        VHUD.show(content)
        
        // Set up table
        tableView.dataSource = self
        tableView.delegate = self
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadData(_:searchString:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        
        
        
        // set up search bar
        
        definesPresentationContext = true
        
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        searchBar.delegate = self
        //self.navigationItem.titleView = self.searchBarTop;
        self.navigationItem.titleView  = searchBar
        searchBar.layer.masksToBounds = false;
        searchBar.layer.shadowRadius = 5;
        searchBar.layer.shadowOpacity = 0.5;
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        
        // view switcher
        let viewTypeSegmentedControl = UISegmentedControl(frame: CGRect(x: 0, y: 10, width: 75, height: 30))
        viewTypeSegmentedControl.insertSegment(with: #imageLiteral(resourceName: "list"), at: 0, animated: false)
        viewTypeSegmentedControl.insertSegment(with: #imageLiteral(resourceName: "grid"), at: 1, animated: false)
        viewTypeSegmentedControl.tintColor = UIColor.lightGray
        viewTypeSegmentedControl.selectedSegmentIndex = 0
        viewTypeSegmentedControl.addTarget(self, action: #selector(viewTypeChange(sender:)), for: .valueChanged)
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: viewTypeSegmentedControl)
        
        
        
        loadData(nil, searchString: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.benjones.movielistcell", for: indexPath as IndexPath) as! MovieListItemCell
        let movie = movies[indexPath.row]
        cell.titleLabel.text = (movie.value(forKey: "original_title") ?? "") as? String
        let imageFile = (movie.value(forKeyPath: "poster_path") as? String)
        if(imageFile != nil){
            cell.posterImage.af_setImage(withURL: URL(string: "https://image.tmdb.org/t/p/w185" + imageFile!)!)
        }else{
            cell.posterImage.image = #imageLiteral(resourceName: "popcorn")
        }
        
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
    
    func loadData(_ refreshControl:UIRefreshControl?, searchString : String?){
        // netwerk
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        var apiUrl = "https://api.themoviedb.org/3/movie/\(listType!)?api_key=\(apiKey)"
        if(searchString != nil && (searchString?.characters.count)! > 0){
            apiUrl = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=en-US&query=\(searchString!)"
            
            self.tabBarController?.tabBar.isHidden = true
        }else{
            self.tabBarController?.tabBar.isHidden = false
        }
        
        Alamofire.request(apiUrl).validate().responseJSON { response in
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadData(nil, searchString: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadData(nil, searchString: searchBar.text)
    }
    
    func viewTypeChange(sender: UISegmentedControl){
        print("pressed \(sender.selectedSegmentIndex)")
    }
    
    
   

}

