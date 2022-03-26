import SwiftUI
import SwiftUIX

public struct Friendly<Content: View>: View {
    @StateObject var devicesState: DeviceState
    @StateObject var motionManager = MotionManager.shared

    @State var breath = false
    @State var prepare = false

    let content: Content

    public init(_ content: (() -> Content)) {
        _devicesState = StateObject(wrappedValue: DeviceState.shared)
        self.content = content()
    }

    public var body: some View {
        switch devicesState.state {
        case .connect:
            ZStack {
                CursorView()
                    .position(x: motionManager.center.x * Screen.main.width, y: motionManager.center.y * Screen.main.height)
                    .onAppear {
                        prepare = false
                    }
            }
        case .disconnect, .prepare:
            VStack {
                Text("Please connect AirPods Pro")
                    .font(.largeTitle.bold())
                    .padding()
                    .padding(.top)
                    .opacity(prepare ? 0 : 1)

                ZStack {
                    Circle()
                        .foregroundColor(prepare ? .green : Color.gray.opacity(0.8))
                        .frame(width: 120)
                        .scaleEffect(breath ? 2 : 1)

                    Image(systemName: "airpodspro")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70)
                        .foregroundColor(.white)
                }
                .onChange(of: devicesState.state) {
                    if $0 == .disconnect {
                        withAnimation(.easeInOut(duration: 1).repeatForever()) {
                            breath.toggle()
                        }
                    } else if $0 == .prepare {
                        withAnimation(.easeInOut(duration: 1)) {
                            breath = false
                            prepare = true
                        }
                    }
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 1).repeatForever()) {
                        breath.toggle()
                    }
                }
            }
        case .notSupport:
            Text("Change to AirPods Pro")
                .font(.largeTitle.bold())
                .padding()
                .padding(.top)

            ZStack {
                Circle()
                    .foregroundColor(.red)
                    .frame(width: 120)

                Image(systemName: "airpodspro")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70)
                    .foregroundColor(.white)
            }
        case .ignore:
            EmptyView()
        }
    }
}
