import SwiftUI

struct SubTopicRowView: View {
    @Bindable var subtopic: SubTopic
    
    var body: some View {
        Button(action: { subtopic.isSelected.toggle() }) {
            HStack {
                Text(subtopic.name)
                    .font(.stableBody())
                    .foregroundColor(.black)
                Spacer()
                if subtopic.isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.stablePrimary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.stableTopicBackground)
            .cornerRadius(12)
        }
    }
}
