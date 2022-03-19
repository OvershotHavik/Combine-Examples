//
//  Future.swift
//  Combine Examples
//
//  Created by Steve Plavetzky on 3/19/22.
//

import SwiftUI
import Combine


class FutureVM: ObservableObject{
    @Published var hello = ""
    @Published var goodbye = ""
    
    var goodbyeCancellable: AnyCancellable?
    
    /*
     
    promise is a function that looks like this:
    promise(Result<String, Never> -> Void)
     */
    
    func sayHello() {
        Future<String, Never> { promise in
            promise(Result.success("Hello, World"))
        }
        .assign(to: &$hello)
    }
    
    
    func sayGoodbye() {
        let futurePublisher = Future<String, Never> {promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                promise(.success("Goodbye, my friend 👋"))
            }
        }
        goodbyeCancellable = futurePublisher
            .sink{ [unowned self] message in
                goodbye = message
                
            }
    }
}


struct FutureView: View {
    @StateObject private var vm = FutureVM()
    
    var body: some View {
        VStack{
            DescView(desc: "The future publisher will publish one value, either immediately or at some future time, from the closure provided to you.")
            Button ("Say Hello"){
                vm.sayHello()
            }
            Text(vm.hello)
                .padding(.bottom)
                .foregroundColor(.primary)
            
            Button("Say Goodbye"){
                vm.sayGoodbye()
            }
            Text(vm.goodbye)
            Spacer()
        }
        .font(.title)
    }
}

struct Future_Previews: PreviewProvider {
    static var previews: some View {
        FutureView()
    }
}
