import Foundation

struct Topic: Identifiable {
    let id = UUID()
    let name: String
    var expertise: Double // 0 to 1, representing the drag progress
}
