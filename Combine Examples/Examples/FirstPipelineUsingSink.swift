//
//  FirstPipelineUsingSink.swift
//  Combine Examples
//
//  Created by Steve Plavetzky on 1/8/22.
//

import SwiftUI
import Combine

class FirstPipelineUsingSinkVM: ObservableObject{
    @Published var name: String = ""
    @Published var validation: String = ""
    var cancellable: AnyCancellable?
    
    init() {
        cancellable = $name
            .map {$0.isEmpty ? "❌" : "✅"}
            .sink{ [unowned self] value in
                self.validation = value
            }
        
    }
}



struct FirstPipelineUsingSink: View {
    @StateObject private var vm = FirstPipelineUsingSinkVM()
    
    var body: some View {
        VStack{
            DescView(desc: "The validation is now being assigned using the sink subscriber. This allows you to cancel the subscription any time you'd like. ")
            HStack {
                TextField("name", text: $vm.name)
                    .textFieldStyle(.roundedBorder)
                Text(vm.validation)
            }
            .padding()
            
            Button ("Cancel Subscription") {
                vm.validation = ""
                vm.cancellable?.cancel()
            }
        }
        .font(.title)
    }
}

struct FirstPipelineUsingSink_Previews: PreviewProvider {
    static var previews: some View {
        FirstPipelineUsingSink()
    }
}
