import SwiftUI

struct UserActivityView: View {
    @State private var location = ""
    @StateObject private var viewModel = WeatherViewModel()
    
    @State var isExpanded: Bool = false
    @State var activityModel = ActivityModel()
    
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
                        .modifier(AboutTextStyle())
                        .padding(10)
                        .background(Color.black.opacity(0.72))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    
                    Button("Use my location") {
                        viewModel.requestUserLocation()
                    }
                    .modifier(AboutTextStyle())
                    .padding(10)
                    .background(Color.black.opacity(0.72))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                    if viewModel.isLoading {
                        ProgressView("Loading weather...")
                    } else if let weather = viewModel.weather {
                        userActivityContent(
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
            .screenBackground("pexels-connorscottmcmanus-14319807")
            .task {
                await viewModel.loadInitialWeatherIfNeeded()
            }
        }
    }
}


#Preview {
    UserActivityView()
}
