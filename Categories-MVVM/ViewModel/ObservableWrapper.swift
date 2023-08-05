import Foundation

@propertyWrapper
final class Observable<Value> {
    
    private var onChange: ((Value) -> Void)? = nil
    
    var wrappedValue: Value {
        didSet { // вызываем функцию после изменения обёрнутого значения
            onChange?(wrappedValue)
        }
    }
    
    var projectedValue: Observable { // возвращает экземпляр самого property wrapper
        return self
    }
    
    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
    
    func bind(action: @escaping(Value) -> Void) { // функция для добавления функции, вызывающей изменения/
        self.onChange = action
    }
    
}
