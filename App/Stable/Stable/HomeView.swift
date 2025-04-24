import SwiftUI

struct ContentCard: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String = ""
    let rating: Int // Rating out of 10
    let backgroundColor: Color = Color(white: 0.95)
}

// MARK: - ViewModel
class HomeViewModel: ObservableObject {
    @Published var userName: String = "Charlotte"
    @Published var sleepHours: Int = 80
    @Published var activityHours: Int = 12
    @Published var contentCards: [ContentCard] = []
    
    init() {
        setupContentCards()
    }
    
    private func setupContentCards() {
        contentCards = [
            ContentCard(
                icon: "💰",
                title: "Financial Foundations",
                rating: 7
            ),
            ContentCard(
                icon: "❤️",
                title: "My Health",
                rating: 8
            ),
            ContentCard(
                icon: "💼",
                title: "My Career",
                rating: 5
            )
        ]
    }
}

// MARK: - View
struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            Color.stablePrimary
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 24) {
                        statsCardsView
                        understandingSectionView
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hi, \(viewModel.userName) 👋")
                    .font(.system(size: 24, weight: .bold))
              Text("Your learning topics for today")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color.stableTextSecondary)
            }
            .padding(.leading)
            
            Spacer()
            
            // Use a system image as fallback since the profilePic may not exist
//            Image(systemName: "person.circle.fill")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: 40, height: 40)
//                .foregroundColor(.gray)
//                .clipShape(Circle())
//                .padding(.trailing)
        }
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
    
    // MARK: - Stats Cards
    private var statsCardsView: some View {
        HStack(spacing: 16) {
//            statsCard(
//                title: "Sleep",
//                value: "\(viewModel.sleepHours)",
//                unit: "hours",
//                icon: "moon.fill",
//                color: Color.blue
//            )
            
            statsCard(
                title: "Streak",
                value: "\(viewModel.activityHours)",
                unit: "days",
                icon: "bolt.fill",
                color: Color.green
            )
        }
    }
    
    private func statsCard(title: String, value: String, unit: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: icon)
                    .foregroundColor(.white)
            }
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white) +
            Text(" \(unit)")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .background(color)
        .cornerRadius(16)
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Understanding Section
    private var understandingSectionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("My current topics")
                .font(.system(size: 18, weight: .semibold))
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(viewModel.contentCards) { card in
                    understandingCardView(card: card)
                }
            }
        }
        .padding(.top, 8)
    }
    
    private func understandingCardView(card: ContentCard) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                Text(card.icon)
                    .font(.system(size: 24))

                VStack(alignment: .leading, spacing: 4) {
                    Text(card.title)
                        .font(.system(size: 16, weight: .medium))
                    
//                    HStack(spacing: 4) {
//                        Text("Your rating:")
//                            .font(.system(size: 12))
//                            .foregroundColor(.gray)
//                        
//                        Text("\(card.rating)/10")
//                            .font(.system(size: 12, weight: .semibold))
//                            .foregroundColor(ratingColor(for: card.rating))
//                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            
            // Rating bar
            ZStack(alignment: .leading) {
                // Background track
                Rectangle()
                    .frame(height: 4)
                    .foregroundColor(Color(white: 0.9))
                
                // Filled portion
                Rectangle()
                    .frame(width: CGFloat(card.rating) / 10.0 * (UIScreen.main.bounds.width - 48), height: 4)
                    .foregroundColor(ratingColor(for: card.rating))
            }
        }
        .background(Color.white)
        .cornerRadius(12)
    }
    
    // Helper function to determine color based on rating
    private func ratingColor(for rating: Int) -> Color {
        switch rating {
        case 0..<4:
            return .red
        case 4..<7:
            return .orange
        case 7..<9:
            return .blue
        default:
            return .green
        }
    }
    
    private func tabButton(icon: String, isSelected: Bool = false) -> some View {
        Button(action: {}) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(isSelected ? .black : .gray)
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    HomeView()
}
