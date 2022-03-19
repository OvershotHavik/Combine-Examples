//
//  FutureOnlyRunONce.swift
//  Combine Examples
//
//  Created by Steve Plavetzky on 3/19/22.
//

import SwiftUI
import Combine

class FutureOnlyRunOnceVM: ObservableObject{
    @Published var firstResult = ""
    @Published var secondResult = ""
    
    let futurePublisher = Future<String, Never> { promise in
        promise(.success("Future Publisher has run! 🙌"))
        print("Future Publisher has run! 🙌")
    }
    
    
    func fetch() {
        futurePublisher
            .assign(to: &$firstResult)
    }
    
    
    func runAgain(){
        futurePublisher
            .assign(to: &$secondResult)
    }
    
}

struct FutureOnlyRunOnce: View {
    @StateObject var vm = FutureOnlyRunOnceVM()
    
    var body: some View {
        VStack{
            DescView(desc: "Another thing that sets the Future publisher apart is that it only runs one time. It will store its value after being run and then never run again.")
            Text(vm.firstResult)
            Button("Run again"){
                vm.runAgain()
            }
            Text(vm.secondResult)
        }
        .onAppear{
            vm.fetch()
        }
    }
}

struct FutureOnlyRunOnce_Previews: PreviewProvider {
    static var previews: some View {
        FutureOnlyRunOnce()
    }
}
