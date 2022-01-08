//
//  PublishedIntro.swift
//  Combine Examples
//
//  Created by Steve Plavetzky on 1/8/22.
//

import SwiftUI
import Combine

class PublishedIntroVM: ObservableObject{
    var characterLimit = 30
    @Published var data = ""
    @Published var characterCount = 0
    @Published var countColor = Color.gray
    
    init(){
        $data
            .map {data -> Int in
                return data.count
            }
            .assign(to: &$characterCount)
        
        $characterCount
            .map { [unowned self] count -> Color in
                let eightyPercent = Int(Double(characterLimit) * 0.8)
                if (eightyPercent...characterLimit).contains(count){
                    return Color.yellow
                } else if count > characterLimit{
                    return Color.red
                }
                return Color.gray
            }
            .assign(to: &$countColor)
    }
}


struct PublishedIntro: View {
    @StateObject private var vm = PublishedIntroVM()
    
    var body: some View {
        VStack(spacing: 20) {
            DescView(desc: "The @Published property wrapper has a built in publisher that you can access with the dollar sign ($).")
            TextEditor(text: $vm.data)
                .border(.gray, width: 1)
                .frame(height: 200)
                .padding()
            Text("\(vm.characterCount)/\(vm.characterLimit)")
                .foregroundColor(vm.countColor)
        }
        .font(.title)
    }
}

struct PublishedIntro_Previews: PreviewProvider {
    static var previews: some View {
        PublishedIntro()
    }
}
