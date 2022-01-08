//
//  FirstPipeline.swift
//  Combine Examples
//
//  Created by Steve Plavetzky on 1/8/22.
//

import SwiftUI

class FirstPipelineVM: ObservableObject{
    @Published var name: String = ""
    @Published var validation: String = ""
    init() {
        //create pipeline here
        $name
            .map {
                print("name property is now: \(self.name)")
                print("Value received is: \($0)")
                return $0.isEmpty ? "❌" : "✅"
            }
//            .map {$0.isEmpty ? "❌" : "✅"}
            .assign(to: &$validation)
    }
}


struct FirstPipeline: View {
    @StateObject private var vm = FirstPipelineVM()
    
    var body: some View {
        VStack{
                DescView(desc: "This is a simple pipeline you can create in combine to validate a text field.")
            HStack {
                TextField("name", text: $vm.name)
                    .textFieldStyle(.roundedBorder)
                Text(vm.validation)
            }
            .padding()
        }
        .font(.title)
        
    }
}

struct FirstPipeline_Previews: PreviewProvider {
    static var previews: some View {
        FirstPipeline()
    }
}
