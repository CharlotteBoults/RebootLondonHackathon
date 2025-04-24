import SwiftUI

struct OnboardingView: View {
    @State private var showSubTopics = false
    @State private var topics = [
        Topic(name: "Finance", expertise: 0),
        Topic(name: "Career", expertise: 0),
        Topic(name: "Health", expertise: 0)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
            Color.stablePrimary
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("What topics did you want\nto learn about?")
                        .font(.stableTitle())
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Swipe each section to let us know\nyour expertise level")
                        .font(.stableSubtitle())
                        .foregroundColor(.stableTextSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)
                
                VStack(spacing: 16) {
                    ForEach(topics.indices, id: \.self) { index in
                      TopicRowView(topic: topics[index], backgroundColor: .stablePrimary)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        let width = UIScreen.main.bounds.width - 32 // Accounting for padding
                                        let progress = min(max(value.location.x / width, 0), 1)
                                        topics[index].expertise = progress
                                    }
                            )
                    }
                }
                .padding(.top, 32)
                
                Spacer()
                
                NavigationLink(destination: SubTopicsView(), isActive: $showSubTopics) {
                    Button(action: { showSubTopics = true }) {
                    Text("Select Sub-Topics")
                        .font(.stableBody())
                        .foregroundColor(.stablePrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(.white)
                    }
                }
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding(.bottom, 40)
            }
        }
    }
}


#Preview {
    OnboardingView()
}
