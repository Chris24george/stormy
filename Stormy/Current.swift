//
//  Current.swift
//  Stormy
//
//  Created by Chris George on 5/17/15.
//  Copyright (c) 2015 chrisgeorge. All rights reserved.
//

import Foundation
import UIKit

struct Current {
    
    var currentTime: String?
    var temperature: Int
    var humidity: Double
    var precipProbability: Double
    var summary: String
    var icon: UIImage?
    
    
    init(weatherDictionary: NSDictionary) {
        
        let currentWeather: NSDictionary = weatherDictionary["currently"] as! NSDictionary
        self.temperature = currentWeather["temperature"] as! Int
        self.humidity = currentWeather["humidity"] as! Double
        self.precipProbability = currentWeather["precipProbability"] as! Double
        self.summary = currentWeather["summary"] as! String
        
        let iconString = currentWeather["icon"] as! String
        self.icon = weatherIconFromString(iconString)
        let currentTimeIntValue = currentWeather["time"] as! Int
        self.currentTime = dateStringFromUnixTime(currentTimeIntValue)
    }
    
    
    func dateStringFromUnixTime(unixTime: Int) -> String {
        let timeInSeconds = NSTimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        
        return dateFormatter.stringFromDate(weatherDate)
    }
    
    
    func weatherIconFromString(stringIcon: String) -> UIImage {
        var imageName: String
        
        switch stringIcon {
            case "clear-day":
                imageName = "clear-day"
            case "clear-night":
                imageName = "clear-night"
            case "rain":
                imageName = "rain"
            case "snow":
                imageName = "snow"
            case "sleet":
                imageName = "sleet"
            case "wind":
                imageName = "wind"
            case "fog":
                imageName = "fog"
            case "cloudy":
                imageName = "cloudy"
            case "partly-cloudy-day":
                imageName = "partly-cloudy"
            case "partly-cloudy-night":
                imageName = "cloudy-night"
            default:
                imageName = "default"
        }
        var iconImage = UIImage(named: imageName)
        
        return iconImage!
    }
    
    
}