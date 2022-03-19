//
//  FutureRunMultiple.swift
//  Combine Examples
//
//  Created by Steve Plavetzky on 3/19/22.
//

import SwiftUI
import Combine

class FutureRunMultipleVM: ObservableObject{
    @Published var firstResult = ""
    @Published var secondResult = ""
    
    //Deferred publisher is only used for future since future is the only publisher that can execute immediately. All other publishers will nto published without a subscriber
    
    //Turn existing API calls into Publishers
    //using Deferred { Future{...}} pattern is a great way to wrap APIs that are not converted to use Combine publishers. THis mean you can wrap your data store calls with this patter and then be able to attach operators and sinks to them. You can also use it for many of Apples Kits where yo need to get information from the device/user permission
    
    //newAPIPublisher = Deferred { Future...{promise(.success(<Some Type>)) or {promise(.failure(<Some Error>)
    
    let futurePublisher = Deferred{
        Future<String, Never> { promise in
            promise(.success("Future Publisher has run! 🙌"))
            print("Future Publisher has run! 🙌")
        }
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

struct FutureRunMultiple: View {
    @StateObject var vm = FutureRunMultipleVM()
    var body: some View {
        VStack{
            DescView(desc: "Future publishers execute one time and execute immediately. To change this behavior, you can use the deferred publisher which will wait until a subscriber is attached before letting the Future execute and publish")
            
            Text(vm.firstResult)
            Button("Run Again"){
                vm.runAgain()
            }
            Text(vm.secondResult)
        }
        .onAppear{
            vm.fetch()
        }
    }
        
}

struct FutureRunMultiple_Previews: PreviewProvider {
    static var previews: some View {
        FutureRunMultiple()
    }
}
