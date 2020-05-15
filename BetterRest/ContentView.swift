//
//  ContentView.swift
//  BetterRest
//
//  Created by Myat Thu Ko on 5/14/20.
//  Copyright © 2020 Myat Thu Ko. All rights reserved.
//

import SwiftUI

struct BedTimeText: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 23, design: .monospaced))
            .foregroundColor(.black)
            .fontWeight(.bold)
    }
}

struct ContentView: View {
    @State private var wakeUp = defaultWakeUpTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    var calculatedBedTime: String {
        var idealBedTime: String = ""
        let model = SleepCalculator()
        
        let components =
            Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            idealBedTime = formatter.string(from: sleepTime)
        } catch {
            idealBedTime = "Sorry, there was a problem calculating your bedtime."
        }
        
        return idealBedTime
    }
    
    var body: some View {
        NavigationView {
            Form {
                VStack(alignment: .leading, spacing: 0) {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                Picker("Select the cups of coffee", selection: $coffeeAmount) {
                    ForEach(1..<21) { amount in
                        if amount == 1 {
                            Text("\(amount) cup")
                        } else {
                            Text("\(amount) cups")
                        }
                    }
                }
                
                ZStack{
                    LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .top, endPoint: .bottom)
                    VStack(alignment: .center, spacing: 100) {
                        Section(header: BedTimeText(text: "Your ideal bed time...")){
                            BedTimeText(text: "\(calculatedBedTime)")
                            Spacer()
                        }
                    }
                }
            }
            .navigationBarTitle("BetterRest")
        }
    }
    
    static var defaultWakeUpTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
