//
//  TimerView.swift
//  Combine Examples
//
//  Created by Steve Plavetzky on 3/19/22.
//

import SwiftUI
import Combine
class TimerVM: ObservableObject{
    @Published var data: [String] = []
    @Published var interval: Double = 1
    private var timerCancellable: AnyCancellable?
    private var intervalCancellable: AnyCancellable?
    
    let timeFormatter = DateFormatter()
    
    init() {
        timeFormatter.dateFormat = "HH:mm:ss"
        
        intervalCancellable = $interval
            .dropFirst()
            .sink{[unowned self] interval in
                //restart the timer pipeline
                timerCancellable?.cancel()
                data.removeAll()
                start()
            }
    }
    func start() {
        timerCancellable = Timer
            .publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink{[unowned self] (datum) in
                data.append(timeFormatter.string(from: datum))
            }
    }
}


struct TimerView: View {
    @StateObject var vm = TimerVM()
    
    
    var body: some View {
        VStack{
            DescView(desc: "The timer continually publishes the updated data and time at an interval you specify.")
            Text("adjust Interval")
            Slider(value: $vm.interval, in: 0.1...1,
                   minimumValueLabel: Image(systemName: "hare"),
                   maximumValueLabel: Image(systemName: "tortoise"),
                   label:{Text("Interval)")})
            .padding(.horizontal)
            List(vm.data, id: \.self) {datum in
                Text(datum)
                    .font(.system(.title, design: .monospaced))
            }
        }
        .onAppear{
            vm.start()
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
