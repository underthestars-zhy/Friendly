//
//  FriendlyDatePicker.swift
//  
//
//  Created by 朱浩宇 on 2022/4/9.
//

import SwiftUI

public struct FriendlyDatePicker: View, BeFriend {
    public let eternalId: String
    @Binding var date: Date

    public init(_ id: String, date: Binding<Date>) {
        self._date = date
        self.eternalId = id
    }

    public var body: some View {
        HStack {
            FriendlyButton("FriendlyDataPicker-Year-\(eternalId)") {
                FriendlySheet {
                    NumberPadView(max: 4) { year in
                        if let year = Int(year) {
                            let calendar = Calendar.current
                            var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                            dateComponents.year = year
                            let date = calendar.date(from: dateComponents)
                            self.date = date ?? self.date
                        }
                    }
                }.present("FriendlyDataPicker-Year-Sheet-\(eternalId)")
            } label: {
                Text(getDate("yyyy"))
            }

            Text("/")

            FriendlyButton("FriendlyDataPicker-Month-\(eternalId)") {
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
                }.present("FriendlyDataPicker-Month-Sheet-\(eternalId)")
            } label: {
                Text(getDate("MM"))
            }

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
                }.present("FriendlyDataPicker-Day-Sheet-\(eternalId)")
            } label: {
                Text(getDate("dd"))
            }
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
