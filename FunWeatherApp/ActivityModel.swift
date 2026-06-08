import Foundation
import SwiftUI
internal import Combine

class ActivityModel: ObservableObject {
    
    @Published var selectedOption: String = "What are you up to? I plan to: "
    
    let options = ["Have a picnic outside", "Walk the dog", "Sunbathe", "Hang out with friends in a pub", "Yoga in a park", "Go for a run", "Rock climbing", "Have barbecue in a garden", "Cycling", "Paddle jump", "Blow soap bubbles", "Seduce the door"]
}
