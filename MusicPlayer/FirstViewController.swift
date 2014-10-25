//
//  FirstViewController.swift
//  MusicPlayer
//
//  Created by Ulysses Castillo & Francisco Ramirez on 10/21/14.
//  Copyright (c) 2014 IMI_Apps. All rights reserved.
//

import UIKit
import MediaPlayer

var numberOfSongs = 10
var songsArray = [AnyObject]()
var artworkArray = [MPMediaItemArtwork?]()
var artistArray = [AnyObject?]()
var currentSong: AnyObject? = AnyObject?()
var itemsArray = [AnyObject]()
var skip = false



class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if MPMediaQuery.artistsQuery().items.count != 0 {
//            let songs = MPMediaQuery.songsQuery().items
            numberOfSongs = 0
            for song in MPMediaQuery.songsQuery().items {
                var songTitle: AnyObject! = song.valueForProperty(MPMediaItemPropertyTitle)
                    // works fine
                var artwork = song.valueForProperty(MPMediaItemPropertyArtwork) as MPMediaItemArtwork
                    // returns some image information
                var artist: AnyObject! = song.valueForProperty(MPMediaItemPropertyArtist)
                
                numberOfSongs++
                songsArray.append(songTitle)
                artworkArray.append(artwork)
                artistArray.append(artist)
                itemsArray.append(song)
                
//            }

//            MPMediaItemArtwork *artWork = [mItem valueForProperty:MPMediaItemPropertyArtwork];
//            
//            cell.imageView.image = [artWork imageWithSize:CGSizeMake(30, 30)];
            
            
            
//            self.currentSongname = currentItem.valueForProperty.MPMediaItemPropertyTitle
//            let MPMediaItemPropertyBeatsPerMinute: NSString!
            
            
//            NSLog(@"Logging items from a generic query...");
//            NSArray *itemsFromGenericQuery = [everything items];
//            for (MPMediaItem *song in itemsFromGenericQuery) {
//                NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
//                NSLog (@"%@", songTitle);}

        }
      
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return numberOfSongs
    
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell?")
        if songsArray.count != 0 {
            var strSongs = songsArray[indexPath.row] as? String
            var strArtists = artistArray[indexPath.row] as? String
            cell.textLabel.text = strSongs! + " | " + strArtists!
            //UIImagePickerControllerMediaMetadata | might be useful for album cover
            cell.imageView.image = artworkArray[indexPath.row]!.imageWithSize(CGSizeMake(30, 30))
        } else {
            cell.textLabel.text = "Hello Universe"
        }
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        self.performSegueWithIdentifier("nowPlayingSegue", sender: indexPath)
        
    }

    func tableView(tableView: UITableView!,willSelectRowAtIndexPath indexPath: NSIndexPath!) -> NSIndexPath! {
        currentSong = itemsArray[indexPath.row]
        playNow()
        playorpause = true
        return indexPath
        
    }

    
    

    
    
//    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 3
//    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        playerMP.skipToNextItem()
    }


}