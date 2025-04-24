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
                    Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.black)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(subtopic.isSelected ? Color.stableTopicBackground : .white)
            .cornerRadius(12)
        }
    }
}
