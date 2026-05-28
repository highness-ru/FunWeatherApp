import SwiftUI

struct WeatherView: View {
    @State private var location = ""
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    HStack {
                        TextField(
                            "City, Country",
                            text: $location,
                            prompt: Text("Enter your city")
                        )
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.search)
                        .onSubmit {
                            Task {
                                await viewModel.loadWeatherForCity(location)
                            }
                        }
                        
                        Button("Search") {
                            Task {
                                await viewModel.loadWeatherForCity(location)
                            }
                        }
                    }
                    
                    Button("Use my location") {
                        viewModel.requestUserLocation()
                    }
                    
                    if viewModel.isLoading {
                        ProgressView("Loading weather...")
                    } else if let weather = viewModel.weather {
                        weatherContent(
                            weather,
                            locationName: viewModel.locationName
                        )
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                    } else {
                        Text("No weather loaded yet.")
                    }
                }
                .padding()
            }
            .task {
                await viewModel.loadInitialWeatherIfNeeded()
            }
        }
    }
}

#Preview {
    WeatherView()
}
