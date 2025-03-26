//
//  MeasurementFormItemView.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/25/25.
//
import SwiftUI

struct MeasurementFormItemView: View {
    
    let title: String
    let value: Binding<Double?>
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            TextField("", value: value, format: .number)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
        }
    }
    
    
}
