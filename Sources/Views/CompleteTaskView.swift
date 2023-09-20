

import SwiftUI

struct CompleteTaskView: View {
  @Environment(\.scenePhase) var scenePhase
  @StateObject var model = Model()

  var body: some View {
    VStack(alignment: .center, spacing: 20) {
      Text("Task Completion")
        .font(.largeTitle)
        .fontWeight(.bold)
        .padding(EdgeInsets(top: 50, leading: 50, bottom: 0, trailing: 50))

      Spacer()

      Button(
        action: { model.beginPauseTask() },
        label: {
          VStack {
            Text(model.isTaskExecuting ? "Stop Task" : "Begin Task")
              .padding()
            Image(systemName: model.isTaskExecuting ? "stop" : "play")
          }
        })
      .font(.title)
      .padding()

      Text(model.resultsMessage)
        .font(.title2)

      Spacer()
      Spacer()
    }
    .onChange(of: scenePhase) { newPhase in
      model.onChangeOfScenePhase(newPhase)
    }
  }
}

struct FinishTaskView_Previews: PreviewProvider {
  static var previews: some View {
    CompleteTaskView()
  }
}
