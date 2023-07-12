import Foundation
import RxSwift
import Alamofire

class AppServerClient {
    static let baseUrl = "https://api.opendota.com"
    
    private let disposeBag = DisposeBag()
    
    enum GetHerousFailureReason: Int, Error {
        case anAuthorized = 401
        case notFound = 402
        case resourcesNotFound = 0
    }
    
    
    enum RequestType {
        case heroStats
        case popularItems(heroId: Int)
        
        var url: String {
            switch self {
            case .heroStats:
                return "/api/heroStats"
                
            case .popularItems(let heroId):
                return "/api/heroes/\(heroId)/itemPopularity"
            }
        }
    }
    
    func getHerous() -> Observable<[Hero]> {
        return request(with: .heroStats)
    }
    
    func getPopularItems(for heroId: Int) -> Observable<SortedHeroItems> {
        return Observable.create({ [weak self] observer -> Disposable in
            guard let self else { return Disposables.create() }
            
            Observable.zip(self.getItemsCategories(heroId: heroId), self.geItems())
                .subscribe(
                    onNext: { categories, items in
                        let heroItems = categories.getHeroItems(with: items)
                        observer.onNext(heroItems)
                    },
                    onError: { error in
                        observer.onError(error)
                    }
                )
                .disposed(by: disposeBag)
            
            return Disposables.create()
        })
    }
}

private extension AppServerClient {
    func request<T: Decodable>(with type: RequestType) -> Observable<T> {
        return Observable.create { observer -> Disposable in
            AF.request("\(AppServerClient.baseUrl)\(type.url)")
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success:
                        guard let value = response.value else {
                            return observer.onError(response.error ?? GetHerousFailureReason.notFound)
                        }
                        
                        observer.onNext(value)
                        
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    
    func getItemsCategories(heroId: Int) -> Observable<HeroPopularityItems> {
        return request(with: .popularItems(heroId: heroId))
    }
    
    func geItems() -> Observable<[Item]> {
        return parse(resourceName: "Items")
    }
}

private extension AppServerClient {
    func parse<T: Decodable>(resourceName: String) -> Observable<T> {
        return Observable.create { observer -> Disposable in
            do {
                let jsonData = try self.readLocalJSONFile(resourceName: resourceName)
                let decodedData = try JSONDecoder().decode(T.self, from: jsonData)
                
                observer.onNext(decodedData)
                
            } catch(let error) {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    func readLocalJSONFile(resourceName: String) throws -> Data {
        guard let filePath = Bundle.main.url(forResource: resourceName, withExtension: "json") else { throw GetHerousFailureReason.resourcesNotFound }

        do {
            let data = try Data(contentsOf: filePath, options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)

            guard
                let jsonResult = jsonResult as? [String: AnyObject],
                let data = jsonResult["data"]
            else { throw GetHerousFailureReason.resourcesNotFound }

            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            return jsonData
        } catch {
            print("error: \(error)")
        }
        
        throw GetHerousFailureReason.resourcesNotFound
    }
}

fileprivate extension AppServerClient.GetHerousFailureReason {
    func getErrorMessage() -> String {
        switch self {
        case .anAuthorized:
            return "Please authorize"
            
        case .notFound:
            return "not found"
            
        case .resourcesNotFound:
            return "Resource not fond"
        }
    }
}
