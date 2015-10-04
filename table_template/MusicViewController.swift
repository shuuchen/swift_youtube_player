//
//  MusicViewController.swift
//  table_template
//
//  Created by Shuchen Du on 2015/09/29.
//  Copyright (c) 2015年 Shuchen Du. All rights reserved.
//

import UIKit

class MusicViewController: UIViewController {

    @IBOutlet weak var player: YTPlayerView!
    @IBOutlet weak var mLab: UILabel!
    var videoID: String!
    let playParam = [
        // not full screen
        "playsinline": 1
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mLab.text = "video id: \(videoID)"
        
        self.player.loadWithVideoId(videoID, playerVars: playParam)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        println("MusicViewController memory waining...")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
