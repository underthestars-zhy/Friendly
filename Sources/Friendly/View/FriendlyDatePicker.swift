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
        self.eternalId = id
        self._date = date
    }

    public var body: some View {
        HStack {
            FriendlyButton("FriendlyDataPicker-Year") {
                
            } label: {
                Text(getDate("yyyy"))
            }

            Text("/")

            FriendlyButton("FriendlyDataPicker-Month") {

            } label: {
                Text(getDate("MM"))
            }

            Text("/")

            FriendlyButton("FriendlyDataPicker-Day") {

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
