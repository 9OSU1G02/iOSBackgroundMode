

import SwiftUI
import AVFoundation
import Combine

extension AudioView {
  class Model: ObservableObject {
    @Published var time: TimeInterval = 0
    @Published var item: AVPlayerItem?
    @Published var isPlaying = false

    var itemTitle: String {
      if let asset = item?.asset as? AVURLAsset {
        return asset.url.lastPathComponent
      } else {
        return "-"
      }
    }

    private var itemObserver: AnyCancellable?
    private var timeObserver: Any?
    private let player: AVQueuePlayer

    init() {
      do {
        try AVAudioSession
          .sharedInstance()
          .setCategory(.playback, mode: .default)
      } catch {
        print("Failed to set audio session category. Error: \(error)")
      }

      self.player = AVQueuePlayer(items: Self.songs)
      player.actionAtItemEnd = .advance

      itemObserver = player.publisher(for: \.currentItem).sink { [weak self] newItem in
        self?.item = newItem
      }

      timeObserver = player.addPeriodicTimeObserver(
        forInterval: CMTime(seconds: 0.5, preferredTimescale: 600),
        queue: nil) { [weak self] time in
          self?.time = time.seconds
      }
    }

    func playPauseAudio() {
      isPlaying.toggle()
      if isPlaying {
        player.play()
      } else {
        player.pause()
      }
    }

    static var songs: [AVPlayerItem] = {
      // find the mp3 song files in the bundle and return player item for each
      let songNames = ["FeelinGood", "IronBacon", "WhatYouWant"]
      return songNames.map {
        guard let url = Bundle.main.url(forResource: $0, withExtension: "mp3") else {
          return nil
        }
        return AVPlayerItem(url: url)
      }
      .compactMap { $0 }
    }()
  }
}
