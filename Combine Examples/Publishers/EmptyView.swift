//
//  Empty.swift
//  Combine Examples
//
//  Created by Steve Plavetzky on 1/8/22.
//

import SwiftUI
import Combine

struct BombDetectedError: Error, Identifiable {
    let id = UUID()
}

class EmptyVM: ObservableObject{
    @Published var dataToView: [String] = []
    
    func fetch() {
        let dataIn = ["Value 1", "Value 2", "Value 3", "🧨", "Value 5", "Value 6"]
        
        _ = dataIn.publisher
            .tryMap{ item in
                if item == "🧨" {
                    throw BombDetectedError()
                }
                return item
            }
            .catch { (error) in
                Empty(completeImmediately: true)
            }
            .sink { [unowned self] (item) in
                dataToView.append(item)
            }
    }
}

struct EmptyView: View {
    @StateObject private var vm = EmptyVM()
    //could be used for error handling in the catch operator for example
    var body: some View {
        VStack(spacing: 20) {
            DescView(desc: "The Empty publisher will send nothing down the pipeline. ")
            List(vm.dataToView, id: \.self) { item in
                Text(item)
            }
            
            DescView(desc: "The item after Value 3 causes an error. The Empty publisher was then used and the pipeline finished immediately.")
        }
        .font(.title)
        .onAppear{
            vm.fetch()
        }
    }
}

struct Empty_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}




