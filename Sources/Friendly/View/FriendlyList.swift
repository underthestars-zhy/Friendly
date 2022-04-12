//
//  FriendlyList.swift
//  
//
//  Created by 朱浩宇 on 2022/4/10.
//

import SwiftUI

public struct FriendlyList<Content>: View, BeFriend where Content: View {
    let items: Int
    let content: Content
    let ex: Bool

    @Binding var visibleRows: Set<Int>
    public let eternalId: String

    public init(_ id: String, items: Int, visibleRows: Binding<Set<Int>>, ex: Bool = false, @ViewBuilder _ content: () -> Content) {
        self.content = content()
        self.items = items
        self._visibleRows = visibleRows
        self.eternalId = id
        self.ex = ex
    }

    public var body: some View {
        ScrollViewReader { proxy in
            VStack {
                List {
                    content
                }

                HStack {
                    FriendlyButton("FriendlyList-Up-\(eternalId)") {
                        if let first = getFirst(){
                            if first >= 0 {
                                proxy.scrollTo((first - 2) < 0 ? 0 : first - 2)
                            }
                        }
                    } label: {
                        Text("Up")
                            .padding(5)
                    }
                    .hideExclusion(ex)
                    .padding()

                    FriendlyButton("FriendlyList-Down-\(eternalId)") {
                        if let last = getLast() {
                            if last + 1 <= items - 1 {
                                proxy.scrollTo(last + 1)
                            } else {
                                proxy.scrollTo(items - 1)
                            }
                        }
                    } label: {
                        Text("Down")
                            .padding(5)
                    }
                    .hideExclusion(ex)
                    .padding()
                }
            }
        }
    }

    func getFirst() -> Int? {
        visibleRows.sorted().first
    }

    func getLast() -> Int? {
        visibleRows.sorted().last
    }
}
