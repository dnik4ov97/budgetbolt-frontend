//
//  YearMonthPicker.swift
//  BudgetBoltFrontEnd
//
//  Created by David Nikiforov on 4/28/23.
//

import SwiftUI

struct YearMonthPicker: View {
    
    @Binding var month: Months
    @Binding var year: Years
    @State var showIt = false
    var mystyle = MyDisclosureStyle()
    
    var body: some View {
            DisclosureGroup("\(month.rawValue), \(year.rawValue)") {
                DateWheel(month: $month, year: $year)
            }
            .disclosureGroupStyle(mystyle)

    }
}

struct MyDisclosureStyle: DisclosureGroupStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            Button {
                withAnimation {
                    configuration.isExpanded.toggle()
                }
            } label: {
                HStack {
                    configuration.label
                    Label("arrow", systemImage: "arrowtriangle.forward")
                        .labelStyle(.iconOnly)
                        .rotationEffect(.degrees(configuration.isExpanded ? 90 : 0))
                }

            }
            if configuration.isExpanded {
                configuration.content
                    .background(Color("DatePicker"))
            }
        }
        .padding(2)
        .background(Color("DatePicker"))
        .foregroundColor(.white)
        .cornerRadius(10)
        .buttonStyle(.bordered)
    }
}

enum Months: String, CaseIterable, Identifiable {
    case Jan
    case Feb
    case Mar
    case Apr
    case May
    case Jun
    case Jul
    case Aug
    case Sep
    case Oct
    case Nov
    case Dec
    var id: Self { self }
}


enum Years: String, CaseIterable, Identifiable {
    case twenty20 = "2020"
    case twenty21 = "2021"
    case twenty22 = "2022"
    case twenty23 = "2023"
    case twenty24 = "2024"
    case twenty25 = "2025"
    case twenty26 = "2026"
    case twenty27 = "2027"
    case twenty28 = "2028"
    var id: Self { self }
}


struct DateWheel : View {
    
    @Binding var month: Months
    @Binding var year: Years
    var body: some View {
        VStack {
            GeometryReader { geometry in
                HStack {
                    Picker("Month",  selection: $month) {
                        ForEach(Months.allCases) { month in
                            Text(month.rawValue)
                                .foregroundColor(.white)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: geometry.size.width * 0.5)
                    
                    Picker("Year", selection: $year) {
                        ForEach(Years.allCases) { year in
                            Text(year.rawValue)
                                .foregroundColor(.white)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: geometry.size.width * 0.5)
                }
            }
        }
        .frame(height: 100)
    }
}


func dateForm (date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.setLocalizedDateFormatFromTemplate("MMMYYYY")
    return dateFormatter.string(from: date)
}


struct YearMonthPicker_Previews: PreviewProvider {
    static var previews: some View {
        YearMonthPicker(month: .constant(Months.Feb), year: .constant(Years.twenty23))
    }
}
