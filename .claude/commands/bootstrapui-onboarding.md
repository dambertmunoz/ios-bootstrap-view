# Generate BootstrapUI Onboarding

Generate a SwiftUI onboarding flow using BootstrapUI components for: $ARGUMENTS

## Instructions

Create an onboarding experience with pages, animations, and completion:

```swift
import SwiftUI
import BootstrapUI

struct OnboardingView: View {
    @State private var hasCompletedOnboarding = false

    var body: some View {
        if hasCompletedOnboarding {
            MainAppView()
        } else {
            BSOnboardingView(pages: [
                BSOnboardingPage(
                    icon: "star.fill",
                    iconColor: .yellow,
                    title: "Welcome",
                    description: "Discover amazing features that will help you get things done."
                ),
                BSOnboardingPage(
                    icon: "heart.fill",
                    iconColor: .pink,
                    title: "Personalized",
                    description: "Customize the experience to match your preferences."
                ),
                BSOnboardingPage(
                    icon: "bolt.fill",
                    iconColor: .orange,
                    title: "Fast & Reliable",
                    description: "Built for speed and reliability you can count on."
                )
            ]) {
                completeOnboarding()
            }
        }
    }

    private func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }
}
```

## Available Onboarding Components

### BSOnboardingView
```swift
BSOnboardingView(
    pages: pages,
    primaryButtonTitle: "Get Started",  // Default: "Get Started"
    skipButtonTitle: "Skip",            // Default: "Skip"
    showSkipButton: true,               // Default: true
    onComplete: { /* Called on finish */ }
)
```

### BSOnboardingPage
```swift
// With SF Symbol icon
BSOnboardingPage(
    icon: "star.fill",
    iconColor: .yellow,
    title: "Welcome",
    description: "Your journey begins here."
)

// With custom image
BSOnboardingPage(
    imageName: "onboarding1",  // From asset catalog
    title: "Welcome",
    description: "Your journey begins here."
)

// With Lottie animation placeholder
BSOnboardingPage(
    animationName: "welcome_animation",
    title: "Welcome",
    description: "Your journey begins here."
)
```

## Custom Onboarding Pattern

```swift
struct CustomOnboardingView: View {
    @State private var currentPage = 0
    let totalPages = 3

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<totalPages, id: \.self) { index in
                    onboardingPage(index)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            // Custom indicators
            HStack(spacing: 8) {
                ForEach(0..<totalPages, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? theme.primary : theme.border)
                        .frame(width: 8, height: 8)
                }
            }
            .padding()

            // Navigation buttons
            HStack {
                if currentPage > 0 {
                    BSButton("Back", style: .ghost) {
                        withAnimation { currentPage -= 1 }
                    }
                }

                Spacer()

                if currentPage < totalPages - 1 {
                    BSButton("Next", style: .primary) {
                        withAnimation { currentPage += 1 }
                    }
                } else {
                    BSButton("Get Started", style: .primary) {
                        completeOnboarding()
                    }
                }
            }
            .padding()
        }
    }
}
```

## Feature Showcase Variant

```swift
struct FeatureShowcaseView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: theme.xl) {
                ForEach(features) { feature in
                    HStack(spacing: theme.md) {
                        Image(systemName: feature.icon)
                            .font(.system(size: 32))
                            .foregroundColor(theme.primary)
                            .frame(width: 60)

                        VStack(alignment: .leading, spacing: theme.xs) {
                            BSText(feature.title, style: .headline)
                            BSText(feature.description, style: .body, color: .secondary)
                        }
                    }
                    .padding()
                    .background(theme.surface)
                    .cornerRadius(theme.radiusMd)
                }
            }
            .padding()
        }
    }
}
```

## Onboarding with Permissions

```swift
struct PermissionOnboardingView: View {
    var body: some View {
        BSOnboardingView(pages: [
            BSOnboardingPage(
                icon: "bell.fill",
                title: "Stay Updated",
                description: "Enable notifications to never miss important updates."
            ),
            BSOnboardingPage(
                icon: "location.fill",
                title: "Find Nearby",
                description: "Allow location access to discover places near you."
            ),
            BSOnboardingPage(
                icon: "camera.fill",
                title: "Share Moments",
                description: "Enable camera access to capture and share photos."
            )
        ]) {
            requestPermissions()
        }
    }
}
```

Generate the onboarding flow based on the user's requirements using these patterns.
