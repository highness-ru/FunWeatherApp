import Foundation

struct WeatherData {
    let current: Current
    let hourly: Hourly
    let daily: Daily

    struct Current {
        let time: Date
        let temperature2m: Float
        let weatherCode: Float
    }

    struct Hourly {
        let time: [Date]
        let temperature2m: [Float]
        let precipitation: [Float]
    }

    struct Daily {
        let time: [Date]
        let temperature2mMax: [Float]
        let temperature2mMin: [Float]
    }
}
