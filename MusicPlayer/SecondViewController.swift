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
        songPlaying = playerMP.nowPlayingItem
        var lastItem = itemsArray[itemsArray.count - 1] as? NSObject
        var firstItem = itemsArray[0] as? NSObject
        if  songPlaying != lastItem && songPlaying != firstItem {
            checkPlayOrPause()
            updateNowPlayingInfo()
        } else {
            currentSong = itemsArray[itemsArray.count / 2] as MPMediaItem
            playNow()
            updateNowPlayingInfo()
        }
        
    }

    @IBAction func nextButtonPressed(sender: AnyObject) {
        songPlaying = playerMP.nowPlayingItem
        if  songPlaying != itemsArray[itemsArray.count - 1] as? NSObject {
            playerMP.skipToNextItem()
            updateNowPlayingInfo()
            
            println("BPM: \(songPlaying.valueForProperty(MPMediaItemPropertyBeatsPerMinute))")
            
        } else {
            playorpause = false
            checkPlayOrPause()
            currentSong = itemsArray[itemsArray.count / 2] as MPMediaItem
            playNow()
            updateNowPlayingInfo()
            playerMP.stop()
        }
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        songPlaying = playerMP.nowPlayingItem
        if  songPlaying != itemsArray[0] as? NSObject {
            
            playerMP.skipToPreviousItem()
            updateNowPlayingInfo()
        } else {
            playorpause = false
            checkPlayOrPause()
            currentSong = itemsArray[itemsArray.count / 2] as MPMediaItem
            playNow()
            updateNowPlayingInfo()
            playerMP.stop()
        }
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
        } else if playorpause == false{
            playerMP.pause()
            pauseButton.alpha = 0
            playButton.alpha = 1
            playorpause = true
        } else {
            println("error")
        }
        
    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

