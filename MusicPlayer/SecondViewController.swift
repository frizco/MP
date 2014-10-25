//
//  SecondViewController.swift
//  MusicPlayer
//
//  Created by Ulysses Castillo on 10/21/14.
//  Copyright (c) 2014 UACA. All rights reserved.
//

import UIKit
import MediaPlayer



var playorpause = Bool()
var songPlaying = playerMP.nowPlayingItem

class SecondViewController: UIViewController {

    
//    playerMP.MPVolumeView
    
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func playButtonPressed(sender: AnyObject) {
        checkPlayOrPause()
        updateNowPlayingInfo()
        
    }

    @IBAction func nextButtonPressed(sender: AnyObject) {
        playerMP.skipToNextItem()
        updateNowPlayingInfo()
        
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        playerMP.skipToPreviousItem()
        updateNowPlayingInfo()
    }
    
    
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var artistAndAlbumLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateNowPlayingInfo()
        checkPlayOrPause()
        
    
    
        
    }
    
    func updateNowPlayingInfo () {
        
        songPlaying = playerMP.nowPlayingItem
        artworkImageView.image = songPlaying.valueForProperty(MPMediaItemPropertyArtwork).imageWithSize(CGSizeMake(110, 110))
        var artistString = songPlaying.valueForProperty(MPMediaItemPropertyArtist) as? String
        var albumString = songPlaying.valueForProperty(MPMediaItemPropertyAlbumTitle) as? String
        artistAndAlbumLabel.text = artistString! + " - " + albumString!
        songTitleLabel.text = songPlaying.valueForProperty(MPMediaItemPropertyTitle) as? String
        
    }
    
    func checkPlayOrPause () {
        if playorpause == true {
            playerMP.play()
            playButton.alpha = 0
            pauseButton.alpha = 1
            playorpause = false
        } else {
            playerMP.pause()
            pauseButton.alpha = 0
            playButton.alpha = 1
            playorpause = true
        }
    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

