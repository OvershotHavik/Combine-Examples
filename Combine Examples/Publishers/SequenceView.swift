//
//  SequenceView.swift
//  Combine Examples
//
//  Created by Steve Plavetzky on 3/19/22.
//

import SwiftUI
import Combine
class SequenceVM: ObservableObject{
    @Published var dataToView: [String] = []
    var cancellables: Set<AnyCancellable> = []
    
    func fetch() {
        var dataIn  = ["Paul", "Lem", "Scott", "Chris", "Kaya", "Mark", "Adam", "Jared"]
        //Process Values
        dataIn.publisher
            .sink(receiveCompletion: {(completion) in
                print(completion)
            }, receiveValue: {[unowned self] datum in
                self.dataToView.append(datum)
                print(datum)
            })
            .store(in: &cancellables)
        //These values will NOT go through the pipeline.
        //The pipeline finishes after publishing the initial set.
        
        dataIn.append(contentsOf: ["Rod", "Sean", "Karin"])
    }
    
    func fetchString(){
        let dataIn = "Hello World!"
        dataIn.publisher
            .sink{[unowned self] datum in
                self.dataToView.append(String(datum))
                print(datum)
            }
            .store(in: &cancellables)
    }
}

struct SequenceView: View {
    @StateObject var vm = SequenceVM()
    
    var body: some View {
        VStack{
            DescView(desc: "Arrays have a built-in sequence publisher property. This means a pipeline can be consructed right ont he array.")
            List(vm.dataToView, id: \.self) {datum in
                Text(datum)
            }
        }
        .font(.title)
        .onAppear{
//            vm.fetch()
            vm.fetchString()
        }
    }
}

struct SequenceView_Previews: PreviewProvider {
    static var previews: some View {
        SequenceView()
    }
}
