import SwiftUI

extension UserActivityView {
    func userActivityContent(_ weather: WeatherData, locationName: String) -> some View {
        let selectedActivity = activityModel.activities.first {
            $0.name == activityModel.selectedOption
        }
        
        return VStack(alignment: .leading, spacing: 16) {
            Text(locationName)
                .font(.title2)
                .bold()
            
            Text("\(Date.now, format: .dateTime.hour().minute().day().month())")
                .font(.headline)
            
            DisclosureGroup(activityModel.selectedOption, isExpanded: $isExpanded) {
                VStack(alignment: .leading) {
                    ForEach(activityModel.activities) { activity in
                        Text(activity.name)
                            .padding(.vertical, 6)
                            .onTapGesture {
                                activityModel.selectedOption = activity.name
                                isExpanded = false
                            }
                    }
                }
            }
            .modifier(AboutTextStyle())
            .padding(10)
            .background(Color.black.opacity(0.72))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            if let selectedActivity {
                let result = selectedActivity.evaluate(weather)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(result.rating.rawValue)
                        .font(.headline)
                    
                    Text(result.message)
                }
                .modifier(AboutTextStyle())
                .padding(10)
                .background(Color.black.opacity(0.72))
                .clipShape(RoundedRectangle(cornerRadius: 15))
            } else {
                Text("Choose an activity to get a recommendation.")
                    .foregroundStyle(.secondary)
                    .modifier(AboutTextStyle())
                    .padding(10)
                    .background(Color.black.opacity(0.72))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
        }
    }
}
