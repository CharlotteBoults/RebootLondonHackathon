import SwiftUI
import SwiftData

struct SubTopicsView: View {
    @State private var showHome = false
    @Environment(\.modelContext) private var modelContext
  private var topics: [TopicModel] = [.finance]
    @State private var currentTopicIndex = 0
    
    var body: some View {
        ZStack {
            Color.stablePrimary.ignoresSafeArea()
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    if currentTopicIndex < topics.count {
                        Text("Select your interests in\n\(topics[currentTopicIndex].name)")
                            .font(.stableTitle())
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        Text("Choose the areas you'd like to focus on")
                            .font(.stableSubtitle())
                            .foregroundColor(.stableTextSecondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.top, 40)

                if currentTopicIndex < topics.count {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(topics[currentTopicIndex].subtopics) { subtopic in
                                SubTopicRowView(subtopic: subtopic)
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                Spacer()

                NavigationLink(destination: HomeView(), isActive: $showHome) {
                    Button(action: {
                        if currentTopicIndex < topics.count - 1 {
                            currentTopicIndex += 1
                        } else {
                            showHome = true
                        }
                    }) {
                    Text(currentTopicIndex < topics.count - 1 ? "Next" : "Start Learning")
                        .font(.stableBody())
                        .foregroundColor(.stablePrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 40)
            }
        }
    }
}

extension TopicModel {
  static var finance: TopicModel = TopicModel(
    id: UUID(uuidString: "976274d2-851b-4863-b585-eacf4b1696a3")!,
    name: "Finance",
    subtopics: [
      SubTopic(id: UUID(uuidString: "19a6ab1d-e698-4534-8b65-357c6e2a06b3")!, name: "Budgeting", isSelected: false),
      SubTopic(id: UUID(uuidString: "41f3a9cf-4e3d-485d-ae78-fb5a39934d12")!, name: "Investing", isSelected: false),
      SubTopic(id: UUID(uuidString: "af65064a-fbf2-4212-9387-c80d63ec97f7")!, name: "Retirement Planning", isSelected: false),
      SubTopic(id: UUID(uuidString: "ae3e5fd2-8bc1-416b-b178-100d8c7b54a2")!, name: "Tax Management", isSelected: false)
    ]
  )
  static var career: TopicModel = TopicModel(
    id: UUID(uuidString: "373bcc2e-7ab0-437c-b833-73a19123622f")!,
    name: "Career",
    subtopics: [
      SubTopic(id: UUID(uuidString: "22cbd0d3-8ec8-4fd3-b2ae-9daa27f5ffc1")!, name: "Resume Building", isSelected: false),
      SubTopic(id: UUID(uuidString: "f19b561c-a1dd-4a93-8ce5-e662a0b48665")!, name: "Interview Skills", isSelected: false),
      SubTopic(id: UUID(uuidString: "c22e9ed2-01ca-4a21-88ff-dd7d400777ea")!, name: "Networking", isSelected: false),
      SubTopic(id: UUID(uuidString: "5c8855e2-a277-4cda-b084-af7f89c7dc84")!, name: "Leadership", isSelected: false)
    ]
  )
  static var health: TopicModel = TopicModel(
    id: UUID(uuidString: "3a9d84a9-cb48-428e-abda-4c6352799b0e")!,
    name: "Health",
    subtopics: [
      SubTopic(id: UUID(uuidString: "d25fc991-4b85-4dd9-afde-e4870cf80147")!, name: "Mental Wellness", isSelected: false),
      SubTopic(id: UUID(uuidString: "be2f3be6-8cea-4eef-b60a-745308e82856")!, name: "Physical Fitness", isSelected: false),
      SubTopic(id: UUID(uuidString: "9573e893-aa27-43c0-9fd7-ce2487b4330d")!, name: "Nutrition", isSelected: false),
      SubTopic(id: UUID(uuidString: "b81f0181-f091-45d5-b877-0f6030ab34df")!, name: "Sleep Optimization", isSelected: false)
    ]
  )
}
