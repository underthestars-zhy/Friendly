# Friendly

## Watch


[![IMAGE ALT TEXT](http://img.youtube.com/vi/JIhzsjET-Bk/0.jpg)](http://www.youtube.com/watch?v=JIhzsjET-Bk "Friendly")

## How To Use

1. Import `Friendly` 
2. Change SwiftUI View to Frienly View.

Original:

```swift
WindowGroup {
    ContentView()
}
```

Now:

```swift
WindowGroup {
    Friendly {
        ContentView()
    }
}
```

## What is Friendly View

Firendly View is `Friendly {}`
It contains your app view, cursor view, sheet view and command view.
So the root view of a friendly app must be Friendly View.

## Frienly Element

### BeFriend

All the frienly elements conform `BeFriend`. <br>
And `BeFriend` has a value, that is `eternalId`. We use `eternalId` to identifier your view. And we can know where the views are, and other informations. <br>
So every view has it's own `eternalId`.

### FriendlyWrappedView

`FriendlyWrappedView` can make all the SwiftUI views to BeFriend views. It requeires a eternal id for the view.

```swift
public init(_ id: String, ignore: Bool = false, @ViewBuilder content: () -> Content)
```

**`ignore` is abandoned**

### FriendlyStateButton

`FriendlyStateButton` is not a BeFriend view. It only gives you a sign of the state of the friendly system, including the connection state and so on.

### FriendlyButton

`FriendlyButton` is a BeFriend view.

```swift
public init(_ id: String, ignore: Bool = false, action: @escaping (() -> Void), label: @escaping (() -> Content))
```

**`ignore` is abandoned**

`FriendlyButton` just like SwiftUI button. And when the cursor is above it, the cursor will change to a rect.

### FriendlyTextField

`FriendlyTextField` is a BeFriend view.

```swift
public init(_ id: String, _ title: String, text: Binding<String>, focused: FocusState<Bool>, shouldSpeech: Binding<Bool>)
```

You need give `FriendlyTextField` a `shouldSpeech` value.<br>
`FriendlyTextField` use speech, and only supports `En-US`

Once the speec finished, you can get text like this:

```swift
.onChange(of: speechManager.mainText) { value in
    if speechManager.onRecord == "{your FriendlyTextField eternal ID}" {
        task.text = value
    }
}
```

### FriendlyDatePicker

`FriendlyDatePicker` is a BeFriend view.

```swift
public init(_ id: String, date: Binding<Date>, ex: Bool = false, hideEx: Binding<Bool>)
```

`FriendlyDatePicker` will become a swiftui `DatePicker` when the app is not in the Friendly Mode.<br>
Because `FriendlyDatePicker` has some buttons in it. So you need give a `ex` value to tell it when the button is `hideExclusion`.

### FriendlyPreferenceView

`FriendlyPreferenceView` is a SwiftUI view.

Users can change the value of cursor in this view.

### FriendlyList

`FriendlyList` is a BeFriend view.

```swift
public init(_ id: String, items: Int, visibleRows: Binding<Set<Int>>, ex: Bool = false, @ViewBuilder _ content: () -> Content)
```

It is quite difficult to use. And it provides two buttons for users to control the list.
<br><br>
Example:
```swift
    @State var listVisible = Set<Int>()
        FriendlyList("EventList", items: eventData.events.count + 1, visibleRows: $listVisible) {
            Section {
                HStack {
                    Label {
                        switch deviceState.state {
                        case .connect:
                            Text("Your AirPods is connected")
                        case .disconnect:
                            Text("Your AirPods is disconnected")
                        case .ignore:
                            Text("We ignore your motion")
                        case .notSupport:
                            Text("Your iPad or AirPods isn't support our App. Please use iPad with faceid and AirPods Pro or 3")
                        }
                    } icon: {
                        FriendlyStateButton()
                    }

                    Spacer()

                    if deviceState.state == .connect {
                        FriendlyButton("FriendlyPreferenceView - Button") {
                            FriendlySheet {
                                FriendlyPreferenceView()
                            }.present("FriendlyPreferenceView - sheet")
                        } label: {
                            Image(systemName: "gear")
                        }
                    }
                }
                .id(0)
                .onAppear { listVisible.insert(0) }
                .onDisappear { listVisible.remove(0) }
            }
            
            ...
```

You need add `id` to the `listVisible` when the view appear, and delete it when the view disappear.
`items` is all the items in the list.

### FriendlySheet

You can use `FriendlySheet` to present a sheet view.

```swift
FriendlySheet {
    // your view
}.present("{eternalId}")
```

Dismiss View:

```swift
FriendlyDismiss().dismiss()
```

### CommandView

CommandView is the menu view.<br>
It has a defualt command: **Reset Cursor**.

```swift
Friendly {

}
            .commandView {
                CommandGroup {
                    CommandItem(name: "Toggle SideBar", image: Image(systemName: "sidebar.left")) {
                        if isShowSiderBar {
                            splitViewController?.hide(.primary)
                        } else {
                            splitViewController?.show(.primary)

                            refresh = UUID()
                        }
                    }

                    CommandItem(name: "Refresh Cursor", image: Image(systemName: "circle")) {
                        refresh = UUID()
                        FriendlyManager.shared.refreshCursorData()
                    }
                }
            }
```

## Gesture

### onRight

```swift
public extension BeFriend where Self: View {
    func onRight(_ action: @escaping () -> ()) -> some View {
```

### onLeft

```swift
public extension BeFriend where Self: View {
    func onLeft(_ action: @escaping () -> ()) -> some View {
```

## Conflict

Always, there is a BeFriend view on another befriend view and Friendly don't know cursor is on the which view.

### hideExclusion

Sometimes, in the sheet view, frienly view automatically hide some view. So if you want some view is responsable, you need this.

```swift
func hideExclusion(_ when: Bool) -> FriendlyWrappedView<Self.Body>
```

### other

There are some other solution, but still WIP.

## Design Guide

### 1

![guide - 1](./Github/Design - 1)

### 2

![guide - 2](./Github/Design - 2)

### 3

![guide - 3](./Github/Design - 3)
