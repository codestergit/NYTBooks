# NYTBooks


## Environment

Xcode 9.2
Swift 4.0

## Overview

### Higher Level Architecture

Project is built with MVVM.  MVVM is great and it helped to make some of  UIViewControllers reusable (MVVM assume UIViewcontroller as part of view, so we can use same viewcontroller or any view with differnt viewmodels). 
It also helped to avoid Massive view controllers. I have used Protocol oriented Programmig principles also in this project.

## Networking

Networking Layer is based on the Protocol oriented Programmig. I have used the observables to return asynchronous responses which helps to clean the code and provide seprate clean interface to get data .


#### NetworkService 

NetworkService is base protocol which provides the functionality to make requests. With the Default extensions it provides the basic functionality
to make the requests and handling some common case.

NetworkService protocol also provides the abstaction. In future if we want different network manager to handle requests instead of URLSession we can easily
replace in our code.

It have ```fetchData``` function which handles the simple URLSessionDataTask request and provide response. I have used ```Observer``` to return the response
instead of completionHandlers. It provides nice interface for callbaks to get response satus and handle data and avoids bracket hell.

Currently it supports the ```Decodable``` models. If models have implemented the ```Decodable``` protocol it can parse and give model.

We can further extend ```NetworkService``` to make it more robust and provide different functionalites.

#### Observer

This class helps to bind different types of data.

#### ResponseStatus 

It's a simple generic enum (Result type) which provides different states for asynchornous data handling.


### Other classes

#### BookViewController 

BookViewController provides the basic UI functionality. It handles the ui rendering and action handing of view.

#### BookViewModel

BookViewModel provides the tableview rendering logic and search logic. It notifies BookViewController with the help of ```UIState``` enum. 
```UIState``` is enum which have different states to handle the BookViewController view renderings.

#### BookViewModelable

BookViewModelable is provide the view logic which keeps cutom logic of rendering the view seprate.








