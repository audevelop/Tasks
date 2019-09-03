# Tasks

## Description
A test project with list of tasks. v.0.2.  

## Functionality
As a User I can make a task with description, start date, end date.  
I can edit or delete tasks as well.   
New task can be saved only with title (if not - alert).

# Architecture/Frameworks
Some sort of MVP (VIPER in Rambler's interpretation without of Interactor, since anyway we need  
some kind of Router in the project)  
Interaction between modules (moduleInput, moduleOutput) with: [Rambler's ViperMcFlurry](https://github.com/rambler-digital-solutions/ViperMcFlurry) 
Configuration module with Swinject Assembly.  
Network layer with Network Repository + Requests.  

v.0.8 includes RxSwift, ReactiveLists, Realm, EasyDi with MVVM+Router and can be provided by request.  

[Generamba+swifty_viper](https://github.com/rambler-digital-solutions/Generamba)   

[SwiftGen](https://github.com/SwiftGen/SwiftGen) for localization.  

[PromiseKit](https://github.com/mxcl/PromiseKit)  

[Alamofire](https://github.com/Alamofire/Alamofire)  

[SwinjectStoryboard](https://github.com/Swinject/SwinjectStoryboard)  

[Reusable](https://github.com/AliSoftware/Reusable)  

[SwiftFormat](https://github.com/nicklockwood/SwiftFormat)  

[GrowingTextView](https://github.com/KennethTsang/GrowingTextView)  

[IQKeyboardManager](https://github.com/hackiftekhar/IQKeyboardManager)  


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

First launch of the App will generate some files, so need to start once more after.


