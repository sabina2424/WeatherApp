//
//  WeatherManager.swift
//  Clima
//
//  Created by Sabina on 12/26/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdatwWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}
struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=865c92346de9221122ea00c739b7a104"
    
    
    
    var delegate: WeatherManagerDelegate?
    
    
    func fetchWeather(cityName: String) {
        
        let urlString = "\(weatherURL)&q=\(cityName)"
        perfomRequest(with: urlString)
    }
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        perfomRequest(with: urlString)
    }
    
    func perfomRequest(with urlString: String) {
    //1.create URL
        
        if let url = URL(string: urlString) {
            
    //2.create a URL session
            let session = URLSession(configuration: .default)
            
    //3.Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdatwWeather(self, weather: weather)
                    }
                }
            }
            
    //4.Start the task
            task.resume()
                
}
    }
        func parseJSON(_ weatherData: Data) -> WeatherModel? {
          let decoder = JSONDecoder()
            do {
             let decodadedData = try decoder.decode(WeatherData.self, from: weatherData)
                let id = decodadedData.weather[0].id
                let temp = decodadedData.main.temp
                let name = decodadedData.name
                
                let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
                return weather
                
            } catch {
                delegate?.didFailWithError(error: error)
                return nil

            }
        }
            
    }

    
        


