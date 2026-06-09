import Foundation

enum ActivityRating: String {
    case ok = " 🥳 Good time"
    case maybe = "🤷‍♀️ Maybe"
    case bad = "🙅 Bad time"
}

struct ActivityResult {
    let rating: ActivityRating
    let message: String
}

struct Activity: Identifiable {
    let id = UUID()
    let name: String
    let evaluate: (WeatherData) -> ActivityResult
}

struct ActivityModel {
    let activities: [Activity] = ActivityModel.defaultActivities
    var selectedOption = "Choose an activity"
    
    var options: [String] {
        activities.map(\.name)
    }
}

extension ActivityModel {
    static let defaultActivities: [Activity] = [
        Activity(
            name: "Have a picnic outside",
            evaluate: { weather in
                let temp = weather.current.temperature2m
                let code = Int(weather.current.weatherCode)
                let time = weather.current.time
                let hour = Calendar.current.component(.hour, from: time)
                let isBetween7AMAnd8PM = hour >= 7 && hour < 20
                let isOuside7AMAnd8PM = !isBetween7AMAnd8PM
                
                if !isBetween7AMAnd8PM {
                    return ActivityResult(
                        rating: .bad,
                        message: "It may be too dark for outdoor activities. Consider postponing until morning as all parks are probably already closed."
                        )
                }

                if WeatherCondition.isRainy(code) {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time for a picnic. It is raining, so it would be better to choose an indoor activity."
                    )
                }

                if WeatherCondition.isSnowy(code) {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time for a picnic. It is snowing."
                    )
                }

                if temp < 18 {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time for a picnic. It is too cold outside."
                    )
                }

                if temp > 30 {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time for a picnic. It is too hot outside."
                    )
                }

                if WeatherCondition.isCloudy(code) {
                    return ActivityResult(
                        rating: .maybe,
                        message: "You could have a picnic, but it is cloudy. Bring a jacket or blanket."
                    )
                }

                return ActivityResult(
                    rating: .ok,
                    message: "Enjoy your picnic! The weather is mild. Bring sunscreen if it is sunny."
                )
            }
        ),

        Activity(
            name: "Walk the dog",
            evaluate: { weather in
                let temp = weather.current.temperature2m
                let code = Int(weather.current.weatherCode)
                let time = weather.current.time
                let hour = Calendar.current.component(.hour, from: time)
                let isBetween7AMAnd8PM = hour >= 7 && hour < 20
                let isOuside7AMAnd8PM = !isBetween7AMAnd8PM
                
                if !isBetween7AMAnd8PM {
                    return ActivityResult(
                        rating: .bad,
                        message: "It may be too dark to walk the dog. Excercise extra caution and use flashlight to make sure the dog doesn't get hurt."
                        )
                }

                if WeatherCondition.isRainy(code) {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not the best time to walk the dog. It is raining, so use dog rain clothes or wait until later."
                    )
                }

                if WeatherCondition.isSnowy(code) {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not the best time to walk the dog. It is snowing, so use warm clothes for your dog."
                    )
                }

                if temp < 0 {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time to walk the dog. It is freezing outside."
                    )
                }

                if temp < 10 {
                    return ActivityResult(
                        rating: .maybe,
                        message: "You can walk the dog, but it is cold. Wear warm clothes and keep the walk shorter."
                    )
                }

                if temp > 30 {
                    return ActivityResult(
                        rating: .maybe,
                        message: "You can walk the dog, but it is hot. Take water for you and the dog and avoid a long walk. Try to walk in the shade to avoid heat stroke."
                    )
                }

                return ActivityResult(
                    rating: .ok,
                    message: "Have fun with the dog!"
                )
            }
        ),

        Activity(
            name: "Sunbathe",
            evaluate: { weather in
                let temp = weather.current.temperature2m
                let code = Int(weather.current.weatherCode)
                let time = weather.current.time
                let hour = Calendar.current.component(.hour, from: time)
                let isBetween7AMAnd8PM = hour >= 7 && hour < 20
                let isOuside7AMAnd8PM = !isBetween7AMAnd8PM
                
                if !isBetween7AMAnd8PM {
                    return ActivityResult(
                        rating: .bad,
                        message: "It may be too dark to sunbathe. Consider postponing until daytime."
                        )
                }

                if WeatherCondition.isRainy(code) {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time to sunbathe because it is raining."
                    )
                }
                
                if WeatherCondition.isSnowy(code) {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time to sunbathe because it is snowing."
                    )
                }

                if temp < 18 {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time to sunbathe. It is too cold."
                    )
                }

                if temp > 30 {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time to sunbathe. It is too hot, so avoid staying in direct sun."
                    )
                }

                if WeatherCondition.isCloudy(code) {
                    return ActivityResult(
                        rating: .maybe,
                        message: "You could sunbathe, but it is cloudy. Probably wouldn't get the result you were hoping for."
                    )
                }

                return ActivityResult(
                    rating: .ok,
                    message: "Good time to sunbathe. Use sunscreen and stay hydrated."
                )
            }
        ),

        Activity(
            name: "Hang out with friends in a pub",
            evaluate: { weather in
                let temp = weather.current.temperature2m
                let code = Int(weather.current.weatherCode)
                
                let time = weather.current.time
                let hour = Calendar.current.component(.hour, from: time)
                let isBetween12PMAnd11PM = hour >= 12 && hour < 23
                let isOuside12PMAnd11PM = !isBetween12PMAnd11PM
                
                if !isBetween12PMAnd11PM {
                    return ActivityResult(
                        rating: .bad,
                        message: "The pub might be closed now. Check the opening times and consider postponing if it's the case."
                        )
                }

                if temp < 0 {
                    return ActivityResult(
                        rating: .bad,
                        message: "Going out may be uncomfortable because it is very cold. If you decide to go out, sit indoors and avoid excessive alcohol consumption."
                    )
                }

                if temp > 30 {
                    return ActivityResult(
                        rating: .bad,
                        message: "Going out may be uncomfortable because it is very hot. Look for a place with air con and stay hydrated."
                    )
                }

                if WeatherCondition.isRainy(code) || WeatherCondition.isSnowy(code) {
                    return ActivityResult(
                        rating: .maybe,
                        message: "You can go to the pub, but take an umbrella or wear a raincoat. Sit inside if you can."
                    )
                }

                return ActivityResult(
                    rating: .ok,
                    message: "Double check the opening times but you should be good to go, mate."
                )
            }
        ),

        Activity(
            name: "Yoga in a park",
            evaluate: { weather in
                let temp = weather.current.temperature2m
                let code = Int(weather.current.weatherCode)
                let time = weather.current.time
                let hour = Calendar.current.component(.hour, from: time)
                let isBetween7AMAnd8PM = hour >= 7 && hour < 20
                let isOuside7AMAnd8PM = !isBetween7AMAnd8PM
                
                if !isBetween7AMAnd8PM {
                    return ActivityResult(
                        rating: .bad,
                        message: "It may be too dark for outdoor activities. Consider postponing until morning as all parks are probably already closed."
                        )
                }

                if WeatherCondition.isRainy(code) {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time for yoga in the park because it is raining."
                    )
                }
                
                if WeatherCondition.isSnowy(code) {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time for yoga in the park because it is snowing."
                    )
                }

                if temp < 18 {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time for yoga outside. It is too cold."
                    )
                }

                if temp > 30 {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time for yoga outside. It is too hot."
                    )
                }

                if WeatherCondition.isCloudy(code) {
                    return ActivityResult(
                        rating: .maybe,
                        message: "You can do yoga outside, but it may feel cool or less pleasant because it is cloudy."
                    )
                }

                return ActivityResult(
                    rating: .ok,
                    message: "Yoga in the park will feel nice."
                )
            }
        ),

        Activity(
            name: "Go for a run",
            evaluate: { weather in
                let temp = weather.current.temperature2m
                let code = Int(weather.current.weatherCode)
                let time = weather.current.time
                let hour = Calendar.current.component(.hour, from: time)
                let isBetween7AMAnd8PM = hour >= 7 && hour < 20
                let isOuside7AMAnd8PM = !isBetween7AMAnd8PM
                
                if !isBetween7AMAnd8PM {
                    return ActivityResult(
                        rating: .bad,
                        message: "It may be too dark for outdoor activities. Consider postponing until morning as all parks are probably already closed."
                        )
                }

                if WeatherCondition.isSnowy(code) {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time to run because it is snowing and may be slippery."
                    )
                }

                if temp < 0 {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time to run. It is below freezing."
                    )
                }

                if temp > 30 {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time to run. It is too hot."
                    )
                }

                if WeatherCondition.isRainy(code) {
                    return ActivityResult(
                        rating: .maybe,
                        message: "You can run, but it is raining. Wear suitable clothes and take extra care as roads can be slippery."
                    )
                }

                if temp < 18 {
                    return ActivityResult(
                        rating: .maybe,
                        message: "You can run, but it is a bit cold. Wear warmer running clothes."
                    )
                }

                return ActivityResult(
                    rating: .ok,
                    message: "Go for it! Good time for a run."
                )
            }
        ),
        
        Activity(
            name: "Cycling",
            evaluate: { weather in
                let temp = weather.current.temperature2m
                let code = Int(weather.current.weatherCode)
                let time = weather.current.time
                let hour = Calendar.current.component(.hour, from: time)
                let isBetween7AMAnd8PM = hour >= 7 && hour < 20
                let isOuside7AMAnd8PM = !isBetween7AMAnd8PM
                
                if !isBetween7AMAnd8PM {
                    return ActivityResult(
                        rating: .bad,
                        message: "It may be too dark for cycling. Consider postponing until daytime or use necessary equipment (such as flashights) to light the way."
                        )
                }

                if WeatherCondition.isSnowy(code) {
                    return ActivityResult(
                        rating: .bad,
                        message: "Might be a bad time to cycle because it is snowing. The roads can be slippery and it is dangerous."
                    )
                }

                if temp < 0 {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time to cycle. It is below freezing. The roads can be slippery and unless you have winter tyres, there is a possibility of damaging your bike or getting into an accident."
                    )
                }

                if temp > 30 {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time to cycle. It is too hot."
                    )
                }

                if WeatherCondition.isRainy(code) {
                    return ActivityResult(
                        rating: .maybe,
                        message: "You can cycle, but it is raining. Wear suitable clothes and take extra care as roads can be slippery."
                    )
                }

                if temp < 18 {
                    return ActivityResult(
                        rating: .maybe,
                        message: "You can cycle, but it is a bit cold. Wear warmer training clothes."
                    )
                }

                return ActivityResult(
                    rating: .ok,
                    message: "Good time to cycle. Go for it!"
                )
            }
        ),

        Activity(
            name: "Rock climbing",
            evaluate: { weather in
                let temp = weather.current.temperature2m
                let code = Int(weather.current.weatherCode)
                let time = weather.current.time
                let hour = Calendar.current.component(.hour, from: time)
                let isBetween7AMAnd8PM = hour >= 7 && hour < 20
                let isOuside7AMAnd8PM = !isBetween7AMAnd8PM
                
                if !isBetween7AMAnd8PM {
                    return ActivityResult(
                        rating: .bad,
                        message: "It may be too dark for outdoor climbing. Consider postponing until daytime or use indoor climbing facilities where available."
                        )
                }

                if WeatherCondition.isRainy(code) || WeatherCondition.isSnowy(code) {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time for rock climbing because it is raining and rocks can be slippery. Choose indoor climbing activities."
                    )
                }
                
                if WeatherCondition.isSnowy(code) {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time for rock climbing because the weather is snowy. Rocks can be slippery. Choose indoor climbing activities."
                    )
                }

                if temp < 0 {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time for rock climbing. It is too cold."
                    )
                }

                if temp > 30 {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time for rock climbing. It is too hot."
                    )
                }

                if temp < 18 || WeatherCondition.isCloudy(code) {
                    return ActivityResult(
                        rating: .maybe,
                        message: "You could go rock climbing, but conditions are not perfect."
                    )
                }

                return ActivityResult(
                    rating: .ok,
                    message: "Go for it! Rock climbing should feel good now."
                )
            }
        ),

        Activity(
            name: "Have barbecue in a garden",
            evaluate: { weather in
                let temp = weather.current.temperature2m
                let code = Int(weather.current.weatherCode)
                let time = weather.current.time
                let hour = Calendar.current.component(.hour, from: time)
                let isBetween8AMAnd10PM = hour >= 8 && hour < 22
                let isOuside8AMAnd10PM = !isBetween8AMAnd10PM
                
                if !isBetween8AMAnd10PM {
                    return ActivityResult(
                        rating: .bad,
                        message: "It may be too dark for outdoor barbecue. Depending on where you live it can also be a nusance to your neightbours. Consider postponing until daytime."
                        )
                }

                if WeatherCondition.isSnowy(code) {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time for a barbecue because it is snowing. If you can't reschedule, use an umbrella for your BBQ."
                    )
                }

                if temp < 10 {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time for a barbecue. It is too cold."
                    )
                }

                if WeatherCondition.isRainy(code) {
                    return ActivityResult(
                        rating: .maybe,
                        message: "You could have a barbecue, but it is raining. If you can't reschedule, use an umbrella for your BBQ."
                    )
                }

                if temp < 18 {
                    return ActivityResult(
                        rating: .maybe,
                        message: "You could have a barbecue, but it may feel cold outside."
                    )
                }

                return ActivityResult(
                    rating: .ok,
                    message: "Enjoy the barbecue!"
                )
            }
        ),

        Activity(
            name: "Paddle jump",
            evaluate: { weather in
                let temp = weather.current.temperature2m
                let time = weather.current.time
                let hour = Calendar.current.component(.hour, from: time)
                let isBetween7AMAnd8PM = hour >= 7 && hour < 20
                let isOuside7AMAnd8PM = !isBetween7AMAnd8PM
                
                if !isBetween7AMAnd8PM {
                    return ActivityResult(
                        rating: .bad,
                        message: "It may be too dark for paddle jumping, you can get hurt. Consider postponing until morning."
                        )
                }

                if temp < 0 {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time. It is too cold. The paddles are probably frozen."
                    )
                }

                if temp > 30 {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time. It is too hot, and there probably aren't any paddles."
                    )
                }

                if temp < 18 {
                    return ActivityResult(
                        rating: .maybe,
                        message: "You could do it, but it may feel cold. Wear warm clothes and avoid spending excessive time outdoors while wet."
                    )
                }

                return ActivityResult(
                    rating: .ok,
                    message: "Flip-flop. Prepare to dive in!"
                )
            }
        ),

        Activity(
            name: "Blow soap bubbles",
            evaluate: { weather in
                let temp = weather.current.temperature2m
                let code = Int(weather.current.weatherCode)
                let time = weather.current.time
                let hour = Calendar.current.component(.hour, from: time)
                let isBetween7AMAnd8PM = hour >= 7 && hour < 20
                let isOuside7AMAnd8PM = !isBetween7AMAnd8PM
                
                if !isBetween7AMAnd8PM {
                    return ActivityResult(
                        rating: .bad,
                        message: "It may be too dark for outdoor activities. You won't see the bubbles, consider postponing until daytime."
                        )
                }

                if WeatherCondition.isSnowy(code) {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time for soap bubbles because it is snowing. The bubbles may pop too soon."
                    )
                }
                
                if WeatherCondition.isRainy(code) {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time for soap bubbles because it is raining. The bubbles may pop too soon."
                    )
                }

                if temp < 10 {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time for soap bubbles. It is too cold."
                    )
                }

                if temp > 30 {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not a good time for soap bubbles. It is too hot."
                    )
                }

                if temp < 18 {
                    return ActivityResult(
                        rating: .maybe,
                        message: "You could blow soap bubbles, but it may feel a bit cold."
                    )
                }

                return ActivityResult(
                    rating: .ok,
                    message: "Enjoy your soap bubbles."
                )
            }
        ),

        Activity(
            name: "Seduce the door",
            evaluate: { weather in
                let temp = weather.current.temperature2m
                let code = Int(weather.current.weatherCode)
                let time = weather.current.time
                let hour = Calendar.current.component(.hour, from: time)
                let isBetween8AMAnd10PM = hour >= 8 && hour < 22
                let isOuside8AMAnd10PM = !isBetween8AMAnd10PM
                
                if !isBetween8AMAnd10PM {
                    return ActivityResult(
                        rating: .bad,
                        message: "It may be too dark for outdoor activities. Depending on where you live, your neighbours may consider your actions a nuisance. Double check the applicable law and choose indoor activities where possible."
                        )
                }

                if temp > 30 || temp < 10 {
                    return ActivityResult(
                        rating: .bad,
                        message: "Not the best time. The temperature is uncomfortable. Try seducing the door from inside."
                    )
                }

                if WeatherCondition.isRainy(code) || WeatherCondition.isSnowy(code) {
                    return ActivityResult(
                        rating: .maybe,
                        message: "Possible, but the weather is not ideal. Bring an umbrella or raincoat."
                    )
                }

                return ActivityResult(
                    rating: .ok,
                    message: "The weather is comfortable enough. Make sure your DM is happy for you to proceed and roll the D20!"
                )
            }
        )
    ]
}

enum WeatherCondition {
    static func isSunny(_ code: Int) -> Bool {
        code == 0 || code == 1
    }

    static func isCloudy(_ code: Int) -> Bool {
        [2, 3, 45, 48].contains(code)
    }

    static func isRainy(_ code: Int) -> Bool {
        [
            51, 53, 55,
            56, 57,
            61, 63, 65,
            66, 67,
            80, 81, 82,
            95, 96, 99
        ].contains(code)
    }

    static func isSnowy(_ code: Int) -> Bool {
        [
            71, 73, 75,
            77,
            85, 86
        ].contains(code)
    }
}
