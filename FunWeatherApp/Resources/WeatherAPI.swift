import Foundation
import OpenMeteoSdk

final class WeatherAPI {
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherData {
        let urlString = """
        https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m,weather_code&hourly=temperature_2m,precipitation&daily=temperature_2m_min,temperature_2m_max&timezone=auto&format=flatbuffers
        """
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let responses = try await WeatherApiResponse.fetch(url: url)
        
        guard let response = responses.first else {
            throw URLError(.badServerResponse)
        }
        
        let utcOffsetSeconds = response.utcOffsetSeconds
        
        guard let current = response.current,
              let hourly = response.hourly,
              let daily = response.daily else {
            throw URLError(.cannotParseResponse)
        }
        
        let data = WeatherData(
            current: .init(
                time: Date(timeIntervalSince1970: TimeInterval(current.time + Int64(utcOffsetSeconds))),
                temperature2m: current.variables(at: 0)!.value,
                weatherCode: current.variables(at: 1)!.value
            ),
            hourly: .init(
                time: hourly.getDateTime(offset: utcOffsetSeconds),
                temperature2m: hourly.variables(at: 0)!.values,
                precipitation: hourly.variables(at: 1)!.values
            ),
            daily: .init(
                time: daily.getDateTime(offset: utcOffsetSeconds),
                temperature2mMax: daily.variables(at: 1)!.values,
                temperature2mMin: daily.variables(at: 0)!.values
            )
        )
        
        return data
    }
}
