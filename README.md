# Tasks

## Description
A test project with list of tasks (version: 0.5)

## Functionality
As a User I can make a task with description, start date, end date.  
I can edit or delete tasks as well.   
New task can be saved only with title (if not - localized alert).

# Architecture/Frameworks
MVVM + RxSwift.
Configuration module with EasyDi.
Network layer.
Persistence: Realm.

[SwiftGen](https://github.com/SwiftGen/SwiftGen) for localization.

[Alamofire](https://github.com/Alamofire/Alamofire)  

[SwiftFormat](https://github.com/nicklockwood/SwiftFormat)

[Reusable](https://github.com/AliSoftware/Reusable)

[GrowingTextView](https://github.com/KennethTsang/GrowingTextView)

[IQKeyboardManager](https://github.com/hackiftekhar/IQKeyboardManager)

[EasyDi](https://github.com/AndreyZarembo/EasyDi)

[RealmSwift]https://github.com/realm/realm-cocoa)

[RxSwift](https://github.com/ReactiveX/RxSwift)

[RxCoca](https://github.com/ReactiveX/RxSwift/tree/master/RxCocoa)


# Server launch
[JSON-Server](https://github.com/typicode/json-server)  
*Install JSON Server*
brew install node (if there is no node.js)  
npm install -g json-server  

#### Create a db.json file with some data
```
{
  "tasks": [
    {
      "description": "this temp description",
      "endDate": "8/29/18",
      "id": 1,
      "startDate": "8/29/17",
      "title": "DO IT"
    },
    {
      "description": "any description you like",
      "endDate": "8/30/18",
      "id": 2,
      "startDate": "8/29/12",
      "title": "Get new info"
    }
  ]
}
```
#### Start JSON Server  

json-server --watch db.json  

Now you can launch application  

http://localhost:3000/tasks


