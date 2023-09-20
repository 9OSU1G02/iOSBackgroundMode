

import SwiftUI
import AVFoundation

struct AudioView: View {
  @StateObject var model = Model()

  var body: some View {
    VStack(alignment: .center, spacing: 20) {
      Text("Audio Player")
        .font(.largeTitle)
        .fontWeight(.bold)
        .padding(EdgeInsets(top: 50, leading: 50, bottom: 0, trailing: 50))

      Spacer()

      Button(
        action: model.playPauseAudio) {
          VStack {
            Text(model.isPlaying ? "Pause" : "Play")
              .padding()
            Image(systemName: model.isPlaying ? "pause" : "play")
          }
      }
      .font(.title)
      .padding()

      Text("Now Playing: \(model.itemTitle)")
        .font(.title2)

      Text(Self.formatter.string(from: model.time) ?? "")
        .font(.title2)

      Spacer()
      Spacer()
    }
  }

  static let formatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .positional
    formatter.allowedUnits = [.minute, .second]
    formatter.zeroFormattingBehavior = .pad
    return formatter
  }()
}

struct AudioView_Previews: PreviewProvider {
  static var previews: some View {
    AudioView()
  }
}
