//
//  FriendlyDatePicker.swift
//  
//
//  Created by 朱浩宇 on 2022/4/9.
//

import SwiftUI

public struct FriendlyDatePicker: View, BeFriend {
    public let eternalId: String
    let ex: Bool
    @Binding var hideEx: Bool
    @Binding var date: Date

    public init(_ id: String, date: Binding<Date>, ex: Bool = false, hideEx: Binding<Bool>) {
        self._date = date
        self.eternalId = id
        self.ex = ex
        self._hideEx = hideEx
    }

    public var body: some View {
        if DeviceState.shared.state == .connect {
            HStack {
                FriendlyButton("FriendlyDataPicker-Year-\(eternalId)") {
                    print("do")
                    FriendlySheet {
                        NumberPadView(max: 4) { year in
                            if let year = Int(year), year > 1970 {
                                let calendar = Calendar.current
                                var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                                dateComponents.year = year
                                let date = calendar.date(from: dateComponents)
                                self.date = date ?? self.date
                            }
                        }
                        .onAppear {
                            hideEx = false
                        }
                        .onDisappear {
                            hideEx = true
                        }
                    }.present("FriendlyDataPicker-Year-Sheet-\(eternalId)")
                } label: {
                    Text(getDate("yyyy"))
                }
                .hideExclusion(ex)

                Text("/")

                FriendlyButton("FriendlyDataPicker-Month-\(eternalId)") {
                    print("d1")
                    FriendlySheet {
                        NumberPadView(max: 2) { month in
                            if let month = Int(month), month > 0, month < 13 {
                                let calendar = Calendar.current
                                var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                                dateComponents.month = month
                                let date = calendar.date(from: dateComponents)
                                self.date = date ?? self.date
                            }
                        }
                        .onAppear {
                            hideEx = false
                        }
                        .onDisappear {
                            hideEx = true
                        }
                    }.present("FriendlyDataPicker-Month-Sheet-\(eternalId)")
                } label: {
                    Text(getDate("MM"))
                }
                .hideExclusion(ex)

                Text("/")

                FriendlyButton("FriendlyDataPicker-Day-\(eternalId)") {
                    FriendlySheet {
                        NumberPadView(max: 2) { day in
                            if let day = Int(day), day > 0, day < 32 {
                                let calendar = Calendar.current
                                var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                                dateComponents.day = day
                                let date = calendar.date(from: dateComponents)
                                self.date = date ?? self.date
                            }
                        }
                        .onAppear {
                            hideEx = false
                        }
                        .onDisappear {
                            hideEx = true
                        }
                    }.present("FriendlyDataPicker-Day-Sheet-\(eternalId)")
                } label: {
                    Text(getDate("dd"))
                }
                .hideExclusion(ex)

                Text("-----")

                FriendlyButton("FriendlyDataPicker-Hour-\(eternalId)") {
                    FriendlySheet {
                        NumberPadView(max: 2) { hour in
                            if let hour = Int(hour), hour > 0, hour < 25 {
                                let calendar = Calendar.current
                                var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                                dateComponents.hour = hour
                                let date = calendar.date(from: dateComponents)
                                self.date = date ?? self.date
                            }
                        }
                        .onAppear {
                            hideEx = false
                        }
                        .onDisappear {
                            hideEx = true
                        }
                    }.present("FriendlyDataPicker-Hour-Sheet-\(eternalId)")
                } label: {
                    Text(getDate("HH"))
                }
                .hideExclusion(ex)

                Text("/")

                FriendlyButton("FriendlyDataPicker-Min-\(eternalId)") {
                    FriendlySheet {
                        NumberPadView(max: 2) { minute in
                            if let minute = Int(minute), minute > 0, minute < 61 {
                                let calendar = Calendar.current
                                var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                                dateComponents.minute = minute
                                let date = calendar.date(from: dateComponents)
                                self.date = date ?? self.date
                            }
                        }
                        .onAppear {
                            hideEx = false
                        }
                        .onDisappear {
                            hideEx = true
                        }
                    }.present("FriendlyDataPicker-Min-Sheet-\(eternalId)")
                } label: {
                    Text(getDate("mm"))
                }
                .hideExclusion(ex)
            }
        } else {
            DatePicker("Date", selection: $date)
                .labelsHidden()
        }
    }

    func getDate(_ formate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        dateFormatter.timeZone = TimeZone.current
        let yearString = dateFormatter.string(from: date)
        return yearString
    }
}
