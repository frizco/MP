//
//  SecondViewController.swift
//  MusicPlayer
//
//  Created by Ulysses Castillo on 10/21/14.
//  Copyright (c) 2014 UACA. All rights reserved.
//

import UIKit
import MediaPlayer




class SecondViewController: UIViewController {
    

var playorpause = true
    
//    playerMP.MPVolumeView
    
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func playButtonPressed(sender: AnyObject) {
        
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

    @IBAction func nextButtonPressed(sender: AnyObject) {
        playerMP.skipToNextItem()
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        playerMP.skipToPreviousItem()
    }
    
    
    @IBOutlet weak var artworkImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playorpause = true
        pauseButton.alpha = 0
        
        
        var songPlaying = playerMP.nowPlayingItem
        println(songPlaying.valueForProperty(MPMediaItemPropertyTitle))
        println(songPlaying.valueForProperty(MPMediaItemPropertyArtist))
        println(songPlaying.valueForProperty(MPMediaItemPropertyArtwork))
        println(songPlaying.valueForProperty(MPMediaItemPropertyAlbumTitle))
        
    }
   
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

