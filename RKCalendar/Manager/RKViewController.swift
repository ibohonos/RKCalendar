//
//  RKViewController.swift
//  RKCalendar
//
//  Created by Raffi Kian on 7/14/19.
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import SwiftUI

public struct RKViewController: View {
    
    @Binding var isPresented: Bool
    
    @ObservedObject var rkManager: RKManager
    
    public init (isPresented: Binding<Bool>, rkManager: RKManager) {
        self._isPresented = isPresented
        self.rkManager = rkManager
    }
    
    public var body: some View {
        Group {
            RKWeekdayHeader(rkManager: self.rkManager)
            Divider()
            List {
                ForEach(0 ..< numberOfMonths()) { index in
                    RKMonth(isPresented: self.$isPresented, rkManager: self.rkManager, monthOffset: index)
                }
                Divider()
            }
            if rkManager.mode == 1 || rkManager.mode == 2 {
                HStack {
                    Spacer()
                    Button(action: {
                        if self.rkManager.mode == 2 {
                            self.rkManager.mode = 1
                        }

                        self.isPresented.toggle()
                    }) {
                        Text("Save")
                    }
                    .disabled(rkManager.startDate == nil || rkManager.endDate == nil)
                    .foregroundColor((rkManager.startDate == nil || rkManager.endDate == nil) ? rkManager.colors.disabledButtonColor : rkManager.colors.buttonColor)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 30)
                    .background((rkManager.startDate == nil || rkManager.endDate == nil) ? rkManager.colors.disabledButtonBackColor : rkManager.colors.buttonBackColor)
                }
                .padding()
            }
        }
    }
    
    func numberOfMonths() -> Int {
        return rkManager.calendar.dateComponents([.month], from: rkManager.minimumDate, to: RKMaximumDateMonthLastDay()).month! + 1
    }
    
    func RKMaximumDateMonthLastDay() -> Date {
        var components = rkManager.calendar.dateComponents([.year, .month, .day], from: rkManager.maximumDate)
        components.month! += 1
        components.day = 0
        
        return rkManager.calendar.date(from: components)!
    }
}

#if DEBUG
struct RKViewController_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            RKViewController(isPresented: .constant(false), rkManager: RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0))
            RKViewController(isPresented: .constant(false), rkManager: RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*32), mode: 0))
                .environment(\.colorScheme, .dark)
                .environment(\.layoutDirection, .rightToLeft)
            
            RKViewController(isPresented: .constant(false), rkManager: RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 1))
        }
    }
}
#endif

