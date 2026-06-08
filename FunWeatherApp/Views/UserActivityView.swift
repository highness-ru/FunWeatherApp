import SwiftUI

struct UserActivityView: View {
    @State private var location = ""
    @StateObject private var viewModel = WeatherViewModel()
    
    @State private var isExpanded: Bool = false
    @StateObject private var activityModel = ActivityModel()
    
    var body: some View {
        DisclosureGroup(activityModel.selectedOption, isExpanded: $isExpanded) {
            ScrollView {
                VStack {
                    ForEach(activityModel.options, id: \.self) { option in
                        Text(option)
                            .padding()
                            .onTapGesture {
                                activityModel.selectedOption = option
                                isExpanded = false
                            }
                    }
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        
        Spacer()
    }
}


#Preview {
    UserActivityView()
}
