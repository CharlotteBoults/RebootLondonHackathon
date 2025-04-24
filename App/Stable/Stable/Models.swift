import SwiftUI


struct ContentCard: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String = ""
    let rating: Int // Rating out of 10
    let backgroundColor: Color = Color(white: 0.95)
  let nextTopic: String
}
