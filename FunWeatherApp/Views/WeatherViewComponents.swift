import SwiftUI

extension WeatherView {
    func weatherContent(_ weather: WeatherData, locationName: String) -> some View {
        VStack(spacing: 20) {
            Text(locationName)
                .font(.title2)
                .bold()

            Text(formatTemperature(weather.current.temperature2m))
                .font(.title2)
            
            Text(weatherDescription(for: weather.current.weatherCode))
                .font(.title3)
            
            Divider()
            
            Text("\(Date.now, format: .dateTime.hour().minute().day().month())")
                .font(.headline)
            
            if let min = weather.daily.temperature2mMin.first,
               let max = weather.daily.temperature2mMax.first {
                Text("Low \(formatTemperature(min)) · High \(formatTemperature(max))")
            }
            
            Divider()
            
            Text("Next few hours")
                .font(.headline)
            
            let hoursFromNow = 6
            let now = Date()
            let endDate = Calendar.current.date(byAdding: .hour, value: hoursFromNow, to: now)!
            
            let upcomingHours = weather.hourly.time.enumerated().filter { _, date in
                date >= now && date <= endDate
            }
            
            List(Array(upcomingHours), id: \.offset) { index, date in
                HStack {
                    Text(formatHour(date))
                    Spacer()
                    Text(formatTemperature(weather.hourly.temperature2m[index]))
                    Text("\(weather.hourly.precipitation[index], specifier: "%.1f") mm")
                        .foregroundStyle(.secondary)
                }
            }
           .frame(height: 400)
           .cornerRadius(20)
           .overlay(
               RoundedRectangle(cornerRadius: 20)
                .stroke(.clear, lineWidth: 5)
           )
        }
    }
    
    private func formatHour(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    private func formatTemperature(_ celsius: Float) -> String {
        let measurement = Measurement(
            value: Double(celsius),
            unit: UnitTemperature.celsius
        )

        return measurement.formatted(
            .measurement(
                width: .abbreviated,
                usage: .weather,
                numberFormatStyle: .number.precision(.fractionLength(1))
            )
        )
    }
    
    private func weatherDescription(for code: Float) -> String {
        switch Int(code) {
        case 0:
            return "Clear sky"
        case 1, 2, 3:
            return "Partly cloudy"
        case 45, 48:
            return "Foggy"
        case 51, 53, 55:
            return "Drizzle"
        case 61, 63, 65:
            return "Rain"
        case 71, 73, 75:
            return "Snow"
        case 80, 81, 82:
            return "Rain showers"
        case 85, 86:
            return "Snow showers"
        case 95:
            return "Thunderstorm"
        default:
            return "Unknown weather"
        }
    }
}
