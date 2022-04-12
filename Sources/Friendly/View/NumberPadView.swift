//
//  NumberPadView.swift
//  
//
//  Created by 朱浩宇 on 2022/4/9.
//

import SwiftUI

struct NumberPadView: View {
    let max: Int
    let onCommit: (String) -> ()

    @State var texts = [String]()

    var body: some View {
        VStack {
            Spacer()

            HStack {
                ForEach(0..<max, id: \.self) { id in
                    VStack {
                        Text(getText(id))
                        RoundedRectangle(cornerRadius: 2)
                            .frame(width: 20, height: 2)
                    }
                    .padding()
                }
            }
            .padding()

            HStack {
                FriendlyButton("NumberPadView - 1") {
                    add("1")
                } label: {
                    Text("1")
                        .bold()
                        .font(.title3)
                        .padding(5)
                }
                .hideExclusion(true)
                .padding(.horizontal)

                FriendlyButton("NumberPadView - 2") {
                    add("2")
                } label: {
                    Text("2")
                        .bold()
                        .font(.title3)
                        .padding(5)
                }
                .hideExclusion(true)
                .padding(.horizontal)

                FriendlyButton("NumberPadView - 3") {
                    add("3")
                } label: {
                    Text("3")
                        .bold()
                        .font(.title3)
                        .padding(5)
                }
                .hideExclusion(true)
                .padding(.horizontal)
            }

            HStack {
                FriendlyButton("NumberPadView - 4") {
                    add("4")
                } label: {
                    Text("4")
                        .bold()
                        .font(.title3)
                        .padding(5)
                }
                .hideExclusion(true)
                .padding(.horizontal)

                FriendlyButton("NumberPadView - 5") {
                    add("5")
                } label: {
                    Text("5")
                        .bold()
                        .font(.title3)
                        .padding(5)
                }
                .hideExclusion(true)
                .padding(.horizontal)

                FriendlyButton("NumberPadView - 6") {
                    add("6")
                } label: {
                    Text("6")
                        .bold()
                        .font(.title3)
                        .padding(5)
                }
                .hideExclusion(true)
                .padding(.horizontal)
            }

            HStack {
                FriendlyButton("NumberPadView - 7") {
                    add("7")
                } label: {
                    Text("7")
                        .bold()
                        .font(.title3)
                        .padding(5)
                }
                .hideExclusion(true)
                .padding(.horizontal)

                FriendlyButton("NumberPadView - 8") {
                    add("8")
                } label: {
                    Text("8")
                        .bold()
                        .font(.title3)
                        .padding(5)
                }
                .hideExclusion(true)
                .padding(.horizontal)

                FriendlyButton("NumberPadView - 9") {
                    add("9")
                } label: {
                    Text("9")
                        .bold()
                        .font(.title3)
                        .padding(5)
                }
                .hideExclusion(true)
                .padding(.horizontal)
            }

            HStack {
                Text(" ")
                    .bold()
                    .font(.title3)
                    .padding(5)
                    .padding(.horizontal)

                FriendlyButton("NumberPadView - 0") {
                    add("0")
                } label: {
                    Text("0")
                        .bold()
                        .font(.title3)
                        .padding(5)
                }
                .hideExclusion(true)
                .padding(.horizontal)

                Text(" ")
                    .bold()
                    .font(.title3)
                    .overlay {
                        FriendlyButton("NumberPadView - delete") {
                            delete()
                        } label: {
                            Image(systemName: "delete.left.fill")
                                .font(.title3.bold())
                                .foregroundColor(.red)
                                .padding(5)
                        }
                        .hideExclusion(true)
                    }
                    .padding(5)
                    .padding(.horizontal)
            }

            Spacer()
        }
        .onChange(of: texts) {
            if $0.count == max {
                onCommit(texts.reduce("", +))
                SheetManager.shared.view.removeLast()
            }
        }
        .frame(width: 350, height: 400)
    }

    func getText(_ id: Int) -> String {
        if texts.count > id {
            return texts[id]
        } else {
            return " "
        }
    }

    func add(_ text: String) {
        if texts.count < max {
            texts.append(text)
        }
    }

    func delete() {
        if texts.last != nil {
            texts.removeLast()
        }
    }
}
