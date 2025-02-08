//
//  Typealias.swift
//  GlobalNetworking
//
//  Created by Can Kurtur on 8.02.2025.
//

public typealias Closure<T> = ( (Int) -> Void )
public typealias ErrorStatusCodeHandler = Closure<Int>
public typealias NetworkHandler<T> = (Result<T, APIClientError>) -> Void where T: Decodable
