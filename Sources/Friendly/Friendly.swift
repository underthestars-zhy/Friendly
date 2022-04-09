import SwiftUI
import SwiftUIX

public struct Friendly<Content: View>: View {
    @StateObject var devicesState: DeviceState
    @StateObject var motionManager = MotionManager.shared
    @StateObject var cursorState: CursorState
    @StateObject var eyeTraceStorage = EyeTraceStorage.shared
    @StateObject var friendlyManager = FriendlyManager.shared

    let content: Content

    public init(@ViewBuilder _ content: (() -> Content)) {
        _devicesState = StateObject(wrappedValue: DeviceState.shared)
        _cursorState = StateObject(wrappedValue: CursorState.shared)
        self.content = content()
    }

    public var body: some View {
        ZStack {
            EyeTraceView()
                .zIndex(-1)
                .overlay {
                    Color(UIColor.systemBackground)
                }

            content

//            if friendlyManager.showPopText {
//                FriendlyScope {
//                    friendlyManager.showPopText = false
//                    print(friendlyManager.showPopText)
//                }
//
//                FriendlyTextPopView(content: "hi")
//            }

            if eyeTraceStorage.showCommand {
                FriendlyScope(eternalId: "Show Command") {
                    eyeTraceStorage.showCommand = false
                }
                .exclusion()

                CommandView()
            }

            if devicesState.state == .connect {
                switch cursorState.state {
                case .circle:
                    CursorView()
                        .position(x: motionManager.center.x * Screen.main.width, y: motionManager.center.y * Screen.main.height)

                case .react(cgRect: let rect):
                    RectCursorView(rect: rect)
                }
            }
        }
        .onDisappear {
            EyeTraceManager.shared.stop()
        }
        .onChange(of: devicesState.state) { state in
            switch state {
            case .connect:
                EyeTraceManager.shared.start()
                motionManager.reset()
            case .disconnect:
                EyeTraceManager.shared.stop()
            case .ignore:
                EyeTraceManager.shared.stop()
            case .notSupport:
                EyeTraceManager.shared.stop()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
