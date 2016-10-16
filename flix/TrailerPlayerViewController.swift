//
//  TrailerPlayerViewController.swift
//  flix
//
//  Created by Ben Jones on 10/16/16.
//  Copyright © 2016 Ben Jones. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import VHUD

class TrailerPlayerViewController: UIViewController, YTPlayerViewDelegate  {

    
    @IBOutlet weak var youTubePlayerView: YTPlayerView!
    @IBOutlet weak var closeButton: UIButton!
    
    var trailerKey : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var content = VHUDContent(.loop(3.0))
        content.loadingText = "loading....."
        VHUD.show(content)
        youTubePlayerView.frame = self.view.frame
        closeButton.frame = CGRect(x: self.view.frame.width - closeButton.frame.width, y: CGFloat(0), width: closeButton.frame.width, height: closeButton.frame.height)
        youTubePlayerView.isOpaque = false
        youTubePlayerView.backgroundColor = UIColor.black
        
        
        let playerVars = [
            "playsinline" : 1,
            "autoplay" : 1,
            "showinfo" : 0,
            "rel" : 0,
            "modestbranding" : 1,
        ]
        
        youTubePlayerView.delegate = self
        
        youTubePlayerView.load(withVideoId: trailerKey, playerVars: playerVars)
    }

    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        VHUD.dismiss(0.1)
        playerView.playVideo()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
