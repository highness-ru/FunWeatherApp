import Foundation
import MapKit
import CoreLocation
internal import Combine

@MainActor
final class WeatherViewModel: NSObject, ObservableObject {
    
    @Published var weather: WeatherData?
    @Published var locationName = "New York, USA"
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let weatherService = WeatherAPI()
    private let locationManager = CLLocationManager()
    
    private let defaultCoordinate = CLLocationCoordinate2D(
        latitude: 40.7128,
        longitude: -73.935242
    )
    
    private var currentCoordinate: CLLocationCoordinate2D?
    private var hasLoadedInitialWeather = false
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func loadInitialWeatherIfNeeded() async {
        guard hasLoadedInitialWeather == false else { return }
        
        hasLoadedInitialWeather = true
        
        let coordinate = currentCoordinate ?? defaultCoordinate
        
        await loadWeather(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
    }
    
    func loadDefaultWeather() async {
        currentCoordinate = defaultCoordinate
        
        await loadWeather(
            latitude: defaultCoordinate.latitude,
            longitude: defaultCoordinate.longitude
        )
    }
    
    func requestUserLocation() {
        errorMessage = nil
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
            
        case .denied, .restricted:
            Task {
                await loadInitialWeatherIfNeeded()
            }
            
        @unknown default:
            Task {
                await loadInitialWeatherIfNeeded()
            }
        }
    }
    
    func loadWeatherForCity(_ city: String) async {
        let trimmedCity = city.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard trimmedCity.isEmpty == false else {
            await loadInitialWeatherIfNeeded()
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            guard let request = MKGeocodingRequest(addressString: trimmedCity) else {
                throw URLError(.cannotFindHost)
            }
            
            let mapItems = try await request.mapItems
            
            guard let coordinate = mapItems.first?.location.coordinate else {
                throw URLError(.cannotFindHost)
            }
            
            currentCoordinate = coordinate
            
            await loadWeather(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
        } catch {
            errorMessage = "Could not find that location."
            isLoading = false
        }
    }
    
    func loadWeather(latitude: Double, longitude: Double) async {
        isLoading = true
        errorMessage = nil
        
        let coordinate = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        
        currentCoordinate = coordinate
        
        do {
            async let weatherData = weatherService.fetchWeather(
                latitude: latitude,
                longitude: longitude
            )
            
            async let placeName = reverseGeocode(
                latitude: latitude,
                longitude: longitude
            )
            
            weather = try await weatherData
            locationName = try await placeName
        } catch {
            errorMessage = "Could not load weather: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    private func reverseGeocode(latitude: Double, longitude: Double) async throws -> String {
        let location = CLLocation(
            latitude: latitude,
            longitude: longitude
        )
        
        guard let request = MKReverseGeocodingRequest(location: location) else {
            return "Unknown location"
        }
        
        let mapItems = try await request.mapItems
        
        guard let mapItem = mapItems.first else {
            return "Unknown location"
        }
        
        if let cityWithContext = mapItem.addressRepresentations?.cityWithContext,
           cityWithContext.isEmpty == false {
            return cityWithContext
        }
        
        return "Unknown location"
    }
}

extension WeatherViewModel: CLLocationManagerDelegate {
    
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                manager.requestLocation()
                
            case .denied, .restricted:
                await self.loadInitialWeatherIfNeeded()
                
            case .notDetermined:
                break
                
            @unknown default:
                await self.loadInitialWeatherIfNeeded()
            }
        }
    }
    
    nonisolated func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.first else { return }
        
        Task { @MainActor in
            await self.loadWeather(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
        }
    }
    
    nonisolated func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        Task { @MainActor in
            self.errorMessage = nil
            await self.loadInitialWeatherIfNeeded()
        }
    }
}
