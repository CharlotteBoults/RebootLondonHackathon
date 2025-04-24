import SwiftUI

struct TopicRowView: View {
    let topic: Topic
    let backgroundColor: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                
                // Progress overlay
                RoundedRectangle(cornerRadius: 12)
                .fill(Color.stableTopicBackground)
                    .frame(width: geometry.size.width * topic.expertise)
                
                HStack {
                    Text(topic.name)
                        .font(.stableBody())
                        .foregroundColor(.stablePrimary)
                        .padding(.leading)
                    Spacer()
                  if topic.expertise >= 0.2 {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.black)
                            .padding()
                    }
                }
            }
        }
        .frame(height: 56)
        .padding(.horizontal)
    }
}
