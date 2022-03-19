//
//  JustView.swift
//  Combine Examples
//
//  Created by Steve Plavetzky on 3/19/22.
//

import SwiftUI
import Combine


class JustVM: ObservableObject{
    @Published var data = ""
    @Published var dataToView: [String] = []
    
    func fetch() {
        let dataIn = ["Julian", "Meredith", "luan", "Daniel", "Marina"]
        _ = dataIn.publisher
            .sink{ [unowned self] (item) in
                dataToView.append(item)
            }
        
        if dataIn.count > 0{
            Just(dataIn[0])
                .map{item in
                    item.uppercased()
                }
                .assign(to: &$data)
        }
    }
    
}

struct JustView: View {
    @StateObject var vm = JustVM()
    var body: some View {
        VStack{
            DescView(desc: "The Just publisher can turn any object into a publisher if it doesn't already have one built-in. THis means you can attach pipelines to any property or value.")
                .layoutPriority(1)
            
            Text("This week's winner: ")
            Text(vm.data)
                .bold()
            Form{
                Section(header: Text("Contest Participants").padding()){
                    List(vm.dataToView, id: \.self) {item in
                        Text(item)
                    }
                }
            }
            .font(.title)
            .onAppear{
                vm.fetch()
            }
        }
    }
}

struct JustView_Previews: PreviewProvider {
    static var previews: some View {
        JustView()
    }
}
