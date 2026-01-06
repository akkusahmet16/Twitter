import SwiftUI

public struct HomeTimelineView: View {
    @Binding var refreshTrigger: Bool

    public init(refreshTrigger: Binding<Bool>) {
        self._refreshTrigger = refreshTrigger
    }

    public var body: some View {
        VStack(spacing: 12) {
            Text("Home Timeline")
                .font(.title2)
                .bold()
            Text("Pull-to-refresh via tab reselect: \(refreshTrigger.description)")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .onChange(of: refreshTrigger) { _, newValue in
            print("HomeTimelineView: refreshTrigger toggled -> \(newValue)")
        }
    }
}

#Preview {
    HomeTimelineView(refreshTrigger: .constant(false))
}
