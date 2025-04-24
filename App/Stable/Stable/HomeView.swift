import SwiftUI

// MARK: - ViewModel
class HomeViewModel: ObservableObject {
  @Published var userName: String = "Charlotte"
  @Published var sleepHours: Int = 80
  @Published var activityHours: Int = 12
  @Published var contentCards: [ContentCard] = []
  @Published var showingStoryView: Bool = false
  @Published var selectedSubTopicItem: StorySubTopicItem?
  
  init() {
    setupContentCards()
  }
  
  private func setupContentCards() {
    contentCards = [
      ContentCard(
        icon: "💰",
        title: "Finance",
        rating: 7,
        nextTopic: "What is investing?"
      ),
      ContentCard(
        icon: "❤️",
        title: "Health",
        rating: 8,
        nextTopic: "What are vitamins?"
      ),
      ContentCard(
        icon: "💼",
        title: "Career",
        rating: 5,
        nextTopic: "How to prepare for an interview?"
      )
    ]
  }
  
  func presentStoryView(with subTopicItem: StorySubTopicItem) {
    selectedSubTopicItem = subTopicItem
    showingStoryView = true
  }
}

// MARK: - View
struct HomeView: View {
  @StateObject private var viewModel = HomeViewModel()
  
  var body: some View {
    ZStack {
      Color.stablePrimary
        .ignoresSafeArea()
      
      VStack(spacing: 8) {
        ScrollView {
          headerView
          VStack(spacing: 24) {
            statsCardsView
            understandingSectionView
          }
          .padding(.horizontal)
          .padding(.bottom, 20)
        }
      }
      .sheet(isPresented: $viewModel.showingStoryView) {
        if let subTopicItem = viewModel.selectedSubTopicItem {
          StoryView(subTopic: subTopicItem)
        }
      }
    }
    .navigationBarBackButtonHidden()
  }
  
  // MARK: - Header View
  private var headerView: some View {
    HStack {
      VStack(alignment: .leading, spacing: 8) {
        Text("Hi, \(viewModel.userName) 👋")
          .font(.system(size: 24, weight: .bold))
          .foregroundStyle(.white)
        Text("Your health metrics seem in check from last night. It looks like you're ready to tackle more. See todays topics below 👇.")
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
      Text("Today's topics")
        .font(.system(size: 18, weight: .semibold))
        .foregroundStyle(Color.stableTextSecondary)
      
      VStack(alignment: .leading, spacing: 12) {
        ForEach(viewModel.contentCards) { card in
          understandingCardView(card: card)
        }
      }
    }
    .padding(.top, 8)
  }
  
  private func understandingCardView(card: ContentCard) -> some View {
    Button(action: {
      viewModel.presentStoryView(with: StorySubTopicItem.investingSubTopic)
    }) {
      VStack(spacing: 0) {
        // Card Content
        HStack(alignment: .top, spacing: 16) {
          // Icon
          Text(card.icon)
            .font(.system(size: 40))
          
          // Title and Rating
          HStack(alignment: .top, spacing: 4) {
            VStack(alignment: .leading, spacing: 12) {
              Text(card.title)
                .font(.system(size: 24, weight: .medium))
              VStack(alignment: .leading, spacing: 6) {
                Text("Next Up")
                  .foregroundStyle(.secondary)
                  .font(.system(size: 16, weight: .medium))
                Text(card.nextTopic)
                  .font(.system(size: 20, weight: .semibold))
                  .foregroundStyle(Color.stablePrimary)
                  .opacity(0.8)
              }
            }
            Spacer()
            HStack(spacing: 4) {
              Text("\(card.rating * 10)%")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(ratingColor(for: card.rating))
            }
          }
          
          
          Image(systemName: "chevron.right")
            .foregroundColor(.gray)
        }
        .padding()
        // Rating Bar
        ZStack(alignment: .leading) {
          // Background track
          Rectangle()
            .frame(height: 4)
            .foregroundColor(Color(white: 0.9))
          
          // Filled portion
          GeometryReader { geometry in
            Rectangle()
              .frame(width: geometry.size.width * CGFloat(card.rating) / 10.0, height: 12)
              .cornerRadius(12)
              .foregroundColor(ratingColor(for: card.rating))
            
          }
        }
        .padding()
        
      }
      .background(Color.white)
      .cornerRadius(12)
    }
    .buttonStyle(PlainButtonStyle())
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
}

#Preview {
  HomeView()
}
