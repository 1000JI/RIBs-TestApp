//
//  SetupURLProtocol.swift
//  MiniSuperApp
//
//  Created by 천지운 on 11/13/23.
//

import Foundation

func setupURLProtocol() {
    let topupResponse: [String: Any] = [
        "status": "success"
    ]
    
    let topupResponseData = try! JSONSerialization.data(
        withJSONObject: topupResponse,
        options: []
    )
    
    SuperAppURLProtocol.successMock = [
        "/api/v1/topup": (200, topupResponseData)
    ]
}
