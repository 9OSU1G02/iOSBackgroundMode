

import SwiftUI

struct ContentView: View {
  var body: some View {
    TabView {
      AudioView()
        .tabItem {
          VStack {
            Image(systemName: "music.note")
            Text("Audio")
          }
        }
        .tag(0)

      LocationView()
        .tabItem {
          VStack {
            Image(systemName: "mappin")
            Text("Location")
          }
        }
        .tag(1)

      CompleteTaskView()
        .tabItem {
          VStack {
            Image(systemName: "platter.filled.bottom.and.arrow.down.iphone")
            Text("Completion")
          }
        }
        .tag(2)

      RefreshView()
        .tabItem {
          VStack {
            Image(systemName: "arrow.clockwise.circle")
            Text("Refresh")
          }
        }
        .tag(3)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
