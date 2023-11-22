//
//  Weather.swift
//  poso
//
//  Created by 박희경 on 2023/11/20.
//

// Model of the response body we get from calling the OpenWeather API
struct Weather: Decodable {
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var main: MainResponse
    var name: String
    var wind: WindResponse
    var rain: RainResponse?

    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }

    struct WeatherResponse: Decodable {
        var id: Double
        var main: String
        var description: String
        var icon: String
    }

    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
    }
    
    struct WindResponse: Decodable {
        var speed: Double
        var deg: Double
    }
    
    // MARK: - Rain
    struct RainResponse: Decodable {
        let the1H: Double

        enum CodingKeys: String, CodingKey {
            case the1H = "1h"
        }
    }

}

extension Weather.MainResponse {
    var feelsLike: Double { return feels_like }
    var tempMin: Double { return temp_min }
    var tempMax: Double { return temp_max }
}


