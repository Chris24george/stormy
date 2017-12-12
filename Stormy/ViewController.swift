//
//  ViewController.swift
//  Stormy
//
//  Created by Chris George on 4/25/15.
//  Copyright (c) 2015 chrisgeorge. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var iconView: UIImageView!
    @IBOutlet var currentTimeLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var precipLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    
    
    private let apiKey = "97903e26136386f7491351e16c5d3dd1"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // we create a general base url so we don't have to tediously rewrite the boiler plate stuff for different locations
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        
        let forecastURL = NSURL(string: "37.288224,-121.949678", relativeToURL: baseURL)
        
        // we make a NSURLSession object so that it can manage our download task
        let sharedSession = NSURLSession.sharedSession()
        
        // here we make our download task. What it does is retrieves data from our forecastURL and writes the contents to a temporary file on disk.
        // upon completion the download task will return a NSURL?, NSURLResponse?, and NSError?. we use these as parameters to do some stuff in our completion handler
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forecastURL!, completionHandler: {
            (location, response, error) -> Void in
            
            if (error == nil) {
                // we make a NSData object from whatever is in that temporary file on disk called "location" in our case
                let dataObject = NSData(contentsOfURL: location)
                
                // we make a JSON object from our NSData object so that it is formatted nicely then we turn it into an NSDictionary so we can do useful things with it
                let weatherDictionary = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as! NSDictionary
                
                // we make a currentWeather object that is initialized with the dictionary "weatherDictionary"
                let currentWeather = Current(weatherDictionary: weatherDictionary)
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    
                    self.iconView.image = currentWeather.icon!
                    self.currentTimeLabel.text = "At \(currentWeather.currentTime!) it is"
                    self.temperatureLabel.text = String(currentWeather.temperature)
                    self.precipLabel.text = "\(currentWeather.precipProbability)"
                    self.summaryLabel.text = currentWeather.summary
                    self.humidityLabel.text = "\(currentWeather.humidity)"
                }
            }
            
        })
        
        downloadTask.resume()
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

