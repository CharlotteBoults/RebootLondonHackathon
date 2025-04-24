import SwiftData
import Foundation

@Model
class TopicModel: Identifiable {
  var id: UUID
  var name: String
  var subtopics: [SubTopic]
  
  init(id: UUID, name: String, subtopics: [SubTopic]) {
    self.id = id
    self.name = name
    self.subtopics = subtopics
  }
}
