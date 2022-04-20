import SwiftUI
import SwiftUIX

public struct Friendly<Content: View>: View {
    @StateObject var devicesState: DeviceState
    @StateObject var motionManager = MotionManager.shared
    @StateObject var cursorState: CursorState
    @StateObject var eyeTraceStorage = EyeTraceStorage.shared
    @StateObject var friendlyManager = FriendlyManager.shared
    @StateObject var sheetManager = SheetManager.shared

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
                    FriendlyWrappedView("Basement") {
                        Color(UIColor.systemBackground)
                    }
                    .priority(Int.min + 1)
                    .onRight {}
                }

            content

            if !sheetManager.view.isEmpty {
                FriendlyScope(eternalId: "Sheet Dismiss") {
                    if !sheetManager.view.isEmpty {
                        sheetManager.view.removeLast()
                    }
                }
                .priority(Int.min + 2)
                .hideExclusion(!sheetManager.view.isEmpty)
            }

            ZStack {
                ForEach(sheetManager.view) { item in
                    SheetView(item.name) {
                        item.view
                    }
                    .priority(Int.min + 3 + (sheetManager.view.firstIndex(where: {
                        $0.name == item.name
                    }) ?? 0))
                    .hideExclusion(!sheetManager.view.isEmpty)
                    .onRight { }
                }
            }

            if eyeTraceStorage.showCommand || friendlyManager.setCursor {
                FriendlyScope(eternalId: "Show Command") {
                    eyeTraceStorage.showCommand = false
                }
                .exclusion()
                .hideExclusion(!sheetManager.view.isEmpty)
                CommandView()
            }

            if friendlyManager.setCursor {
                _FriendlyWrappedView("Set Cursor") {
                    Color.systemBackground
                        .overlay {
                            Text("Align the center of your head with the cursor, then blink your left eye.")
                                .padding(.bottom)
                                .padding(.bottom)
                                .padding(.bottom)
                                .font(.title3.bold())
                        }
                        .onAppear {
                            PositionManager.shared.exclusion = []
                            PositionManager.shared.on = "Set Cursor"
                            CursorState.shared.state = .circle
                            PositionManager.shared.allIgnore = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                MotionManager.shared.stopUI = true
                                MotionManager.shared.resetCenter()
                            }
                        }
                        .onDisappear {
                            PositionManager.shared.allIgnore = false
                        }
                }
                .exclusion()
                .onRight {
                    PositionManager.shared.on = nil
                    MotionManager.shared.stopUI = false
                    friendlyManager.setCursor = false
                    motionManager.reset()
                }
            }


            if devicesState.state == .connect && !friendlyManager.stop {
                switch cursorState.state {
                case .circle:
                    CursorView()
                        .position(x: motionManager.center.x * Screen.main.width, y: motionManager.center.y * Screen.main.height)
                case .react(cgRect: let rect), .textfield(cgRect: let rect):
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
