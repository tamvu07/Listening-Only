//
//  Reducers.swift
//  PlayFilemp3
//
//  Created by Vu Minh Tam on 8/28/20.
//  Copyright © 2020 Vu Minh Tam. All rights reserved.
//

import ReSwift

func counterReducerPageControl(action: Action, state: AppState?) -> AppState {

    var state = state ?? AppState()
    
    switch action {
    case let action as CounterActionPageControl:
        state.counterPageControl  = action.counterPageControl
    default:
        break
    }
    
    return state
}
