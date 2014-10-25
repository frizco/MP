//
//  globalFunctions.swift
//  MusicPlayer
//
//  Created by Ulysses Castillo on 10/23/14.
//  Copyright (c) 2014 UACA. All rights reserved.
//

import Foundation
import MediaPlayer

var playerMP = MPMusicPlayerController()


func playNow() {
    if MPMediaQuery.genresQuery().items.count != 0 {
        let songs = MPMediaQuery.songsQuery().items
        let mediaCollection = MPMediaItemCollection(items: songs)
        playerMP = MPMusicPlayerController.iPodMusicPlayer()
        playerMP.stop()
        playerMP.setQueueWithItemCollection(mediaCollection)
//        if currentSong != nil {
            playerMP.nowPlayingItem = currentSong as? MPMediaItem
//        }
        playerMP.play()
        
    }
}