
import BackgroundTasks
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
  static var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .long
    return formatter
  }()

  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    BGTaskScheduler.shared.register(forTaskWithIdentifier: AppConstants.backgroundTaskIdentifier, using: nil) { [weak self] task in
      self?.refresh()
      task.setTaskCompleted(success: true)
      self?.scheduleAppRefresh()
    }
    scheduleAppRefresh()
    return true
  }

  func refresh() {
    let formattedDate = Self.dateFormatter.string(from: Date())
    UserDefaults.standard.set(
      formattedDate,
      forKey: UserDefaultsKeys.lastRefreshDateKey)
    print("refresh occurred")
  }

  func scheduleAppRefresh() {
    let request = BGAppRefreshTaskRequest(identifier: AppConstants.backgroundTaskIdentifier)
    request.earliestBeginDate = Date(timeIntervalSinceNow: 60)
    do {
      try BGTaskScheduler.shared.submit(request)
      print("background refresh scheduled")
    } catch {
      print("Couldn't schedule app refresh \(error.localizedDescription)")
    }
  }
}
