import SwiftData
import Foundation

@Model
class SubTopic: Identifiable {
  var id: UUID
  var name: String
  var isSelected: Bool
  
  init(id: UUID, name: String, isSelected: Bool) {
    self.id = id
    self.name = name
    self.isSelected = isSelected
  }
}
