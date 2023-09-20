

import Combine
import SwiftUI

extension CompleteTaskView {
  class Model: ObservableObject {
    @Published var isTaskExecuting = false
    @Published var resultsMessage = initialMessage

    static let initialMessage = "Fibonacci Computations"
    static let maxValue = NSDecimalNumber(mantissa: 1, exponent: 40, isNegative: false)
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    var previous = NSDecimalNumber.one
    var current = NSDecimalNumber.one
    var position: UInt = 1
    var updateTimer: Timer?

    func beginPauseTask() {
      isTaskExecuting.toggle()
      if isTaskExecuting {
        resetCalculation()
        updateTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
          self?.calculateNextNumber()
        }
      } else {
        updateTimer?.invalidate()
        updateTimer = nil
        endBackgroundTaskIfActive()
        resultsMessage = Self.initialMessage
      }
    }

    func registerBackgroundTask() {
      backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: { [weak self] in
        print("iOS has signaled time has expired")
        self?.endBackgroundTaskIfActive()
      })
    }

    func endBackgroundTaskIfActive() {
      let isBackgroundTaskActive = backgroundTask != .invalid
      if isBackgroundTaskActive {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
      }
    }

    func resetCalculation() {
      previous = .one
      current = .one
      position = 1
    }

    func calculateNextNumber() {
      let result = current.adding(previous)

      if result.compare(Self.maxValue) == .orderedAscending {
        previous = current
        current = result
        position += 1
      } else {
        // This is just too much.... Start over.
        resetCalculation()
      }

      resultsMessage = "Position \(position) = \(current)"
      switch UIApplication.shared.applicationState {
      case .background:
        let timeRemaining = UIApplication.shared.backgroundTimeRemaining
        if timeRemaining < Double.greatestFiniteMagnitude {
          let secondsRemaining = String(format: "%.1f seconds remaining", timeRemaining)
          print("App is backgrounded - \(resultsMessage) - \(secondsRemaining)")
        }
      default:
        break
      }
    }

    func onChangeOfScenePhase(_ newPhase: ScenePhase) {
      switch newPhase {
      case .background:
        let isTimerRunning = updateTimer != nil
        let isTaskUnregistered = backgroundTask == .invalid
        if isTimerRunning && isTaskUnregistered {
          registerBackgroundTask()
        }
      case .active:
        endBackgroundTaskIfActive()
      default:
        break
      }
    }
  }
}
