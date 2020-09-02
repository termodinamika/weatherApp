//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class WeatherListViewModel {
    
    private let coordinator: Coordinator
    private let dataRepository: DataRepository
    private let disposeBag = DisposeBag()
    let currentWeatherList: BehaviorRelay<[CurrentWeather]> = BehaviorRelay(value: [])
    
    init(coordinator: Coordinator, dataRepository: DataRepository) {
        self.coordinator = coordinator
        self.dataRepository = dataRepository
        
        getCurrentWeather()
    }
    
    func getCurrentWeather() {
        dataRepository.getCurrentWeatherData().subscribe(
            onNext: { [weak self] (currentForecastEntity) in
                guard let self = self else { return }
                
                let curentWeatherList = currentForecastEntity.currentWeather.map { CurrentWeather(from: $0 as! CurrentWeatherEntity )}
                self.currentWeatherList.accept(curentWeatherList)
        }).disposed(by: disposeBag)
    }
    
    func pushToDetailView(at index: Int) {
        guard let selectedCity = currentWeatherList.value[safeIndex: index] else { return }
        
        coordinator.pushDetailViewController(with: selectedCity)
    }
    
}
