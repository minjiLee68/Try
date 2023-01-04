//
//  OrderingViews .swift
//  JointGoal_SwiftUI
//
//  Created by 이민지 on 2022/09/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if ShareVar.isMember {
            MainView()
        } else {
            LoginView()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
