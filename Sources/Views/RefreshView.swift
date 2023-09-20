

import SwiftUI
import BackgroundTasks

struct RefreshView: View {
  @AppStorage(UserDefaultsKeys.lastRefreshDateKey) var lastRefresh = "Never"
  @Environment(\.scenePhase) var scenePhase

  var body: some View {
    VStack(alignment: .center, spacing: 20) {
      Text("Background Refresh")
        .font(.largeTitle)
        .fontWeight(.bold)
        .padding(EdgeInsets(top: 50, leading: 50, bottom: 0, trailing: 50))

      Spacer()

      Text("Refresh last performed:")
        .multilineTextAlignment(.center)
        .font(.title)
        .onChange(of: scenePhase) { scenePhase in
          if scenePhase == .background {
            print("moved to background")
          }
        }
        .padding()

      Text(lastRefresh)
        .font(.title2)

      Spacer()
      Spacer()
    }
  }
}

struct FetchView_Previews: PreviewProvider {
  static var previews: some View {
    RefreshView()
  }
}
