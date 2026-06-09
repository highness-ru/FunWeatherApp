# FunWeatherApp

FunWeatherApp is a SwiftUI weather app that shows current weather and helps users decide whether it is a good time to do an outdoor activity.

The app uses live weather data, city search, user location, and activity-based recommendation logic. I built it to practise working with API data, async/await, CoreLocation, MapKit geocoding, SwiftUI state, loading/error states, and a more finished app UI.

## App showcase

https://github.com/user-attachments/assets/607e506a-0c35-49dc-84a0-7b002db5f268


## Features

* Search weather by city
* Use current location
* Show current temperature and weather description
* Show today’s low and high temperature
* Show hourly temperature and precipitation for the next few hours
* Choose an outdoor activity from a list
* Show whether now is a good or bad time for the selected activity
* Show a short explanation for the recommendation
* Tab-based navigation: Weather, Activity, About
* Loading and error states
* Credits and licence information for external data and assets

## Activity recommendations

The app lets the user choose an activity, such as walking the dog or having a picnic. It then checks the current weather and displays a simple recommendation, such as “Good time” or “Bad time”, with a short message explaining the result.

I added this feature to practise turning raw weather data into user-facing product logic.

## Tech used

* Swift
* SwiftUI
* async/await
* Open-Meteo API
* Open-Meteo Swift SDK
* CoreLocation
* MapKit geocoding
* MVVM-style view model structure
* API data handling
* State management with `@State`, `@StateObject`, and `@Published`

## What I worked on

I built the app to practise combining live weather data with simple decision logic. The main part of the project was not only showing weather, but using that data to help the user decide whether an activity is suitable right now.

The app handles different states such as loading, failed weather requests, failed location access, and searched locations. I also split parts of the UI into smaller SwiftUI components to keep the screens easier to work with.

## What I learned

* Fetching and displaying live weather data
* Handling loading and error states in SwiftUI
* Using async/await for API calls
* Searching for locations with MapKit geocoding
* Requesting and using the user’s current location
* Building recommendation logic from weather conditions
* Splitting UI into smaller views
* Thinking about edge cases, such as missing location permission or failed weather loading

## What I am still improving

* Adding local notifications for future good activity times
* Improving recommendation rules for more activities and weather conditions
* Adding unit tests for recommendation logic
* Improving accessibility and Dynamic Type support
* Adding more polished screenshots and a short demo video
