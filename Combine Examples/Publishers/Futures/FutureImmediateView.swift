//
//  FutureImmediateView.swift
//  Combine Examples
//
//  Created by Steve Plavetzky on 3/19/22.
//

import SwiftUI
import Combine

class FutureImmediateVM: ObservableObject{
    @Published var data = ""
    
    func fetch() {
        _ = Future<String, Never> { [unowned self] promise in
            data = "Hello, my friend 👋"
            //Since this has no subscriber, so it will publish immediately
            
        }
    }
    
}



struct FutureImmediateView: View {
    @StateObject var vm = FutureImmediateVM()
    
    var body: some View {
        VStack{
            DescView(desc: "Future publishers execute immediately, whether they have a subscriber or not. THis is different from al other publishers")
            Text(vm.data)
        }
        .onAppear{
            vm.fetch()
            //Not really recommended, but just for demonstration purposes 
        }
    }
}

struct FutureImmediateView_Previews: PreviewProvider {
    static var previews: some View {
        FutureImmediateView()
    }
}
