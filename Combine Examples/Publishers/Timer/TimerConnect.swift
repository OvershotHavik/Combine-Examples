//
//  TimerConnect.swift
//  Combine Examples
//
//  Created by Steve Plavetzky on 3/19/22.
//

import SwiftUI
import Combine


class TimerConnectVM: ObservableObject{
    @Published var data: [String] = []
    private var timerPublisher = Timer.publish(every: 0.2, on: .main, in: .common)
    private var timerCancellable: Cancellable?
    private var cancellables: Set<AnyCancellable> = []
    
    let timeFormatter = DateFormatter()
    
    init() {
        timeFormatter.dateFormat = "HH:mm:ss"
        timerPublisher
            .sink{[unowned self] datum in
                data.append(timeFormatter.string(from: datum))
            }
            .store(in: &cancellables)
        
    }
    
    func start(){
        timerCancellable = timerPublisher.connect()
    }
    
    
    func stop(){
        timerCancellable?.cancel()
        data.removeAll()
    }
}

struct TimerConnect: View {
    @StateObject var vm = TimerConnectVM()
    
    var body: some View {
        VStack{
            DescView(desc: "Instead of using autoconnect, you can call a connect function on the Timer publisher which is like turning on the flow of water.")
            HStack{
                Button("connect"){vm.start()}
                    .frame(maxWidth: .infinity)
                Button("Stop"){vm.stop()}
                    .frame(maxWidth: .infinity)
            }
            List(vm.data, id: \.self){ datum in
                Text(datum)
            }
        }
    }
}

struct TimerConnect_Previews: PreviewProvider {
    static var previews: some View {
        TimerConnect()
    }
}
