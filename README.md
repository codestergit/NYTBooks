# NYTBooks


## Environment

* Xcode 9.2

* Swift 4.0

## Overview

### Higher Level Architecture

Project is built with MVVM. MVVM is great as it helps to divide the responsibility of the view logic from the UIViewControllers and to keep UIViewControllers small and maintainable.

It also helped to avoid Massive ViewControllers. I have used Protocol oriented Programmig principles also in this project.

## [Networking](https://github.com/codestergit/NYTBooks/tree/master/NYTBooks/Networking)

Networking Layer is based on the Protocol oriented Programmig. I have used the observables to return asynchronous responses which helps to clean the code and provide seprate clean interface to get data .

I have used enums instead of struct or classes to implement NetworkService. It helps to maintain different request and provide clean interface to implemet different request logic. It also helped to reduce the number of bugs due to strict type chekcing at compile time. Please refer [NYTBookService](https://github.com/codestergit/NYTBooks/blob/a27585f9bd89e727c6e8e38aa2ce1b02e9ed6dad/NYTBooks/Networking/NYTBookService.swift#L13)


#### [NetworkService](https://github.com/codestergit/NYTBooks/blob/master/NYTBooks/Networking/Generic/NetworkService.swift)

NetworkService is base protocol which provides the functionality to make requests. With the Default extensions it provides the basic functionality
to make the requests and handling some common case.

NetworkService protocol also provides the abstaction. In future if we want different network manager to handle requests instead of URLSession we can easily
replace in our code.

It have [```fetchData```](https://github.com/codestergit/NYTBooks/blob/master/NYTBooks/Networking/Generic/NetworkService.swift#L24-L51) function which handles the simple URLSessionDataTask request and provide response. I have used ```Observer``` to return the response
instead of completionHandlers. It provides nice interface for callbaks to get response satus and handle data and avoids bracket hell.

Currently it supports the ```Decodable``` models. If models have implemented the ```Decodable``` protocol it can parse and give model.

We can further extend ```NetworkService``` to make it more robust and provide different functionalites.

#### [NYTBookService](https://github.com/codestergit/NYTBooks/blob/a27585f9bd89e727c6e8e38aa2ce1b02e9ed6dad/NYTBooks/Networking/NYTBookService.swift)

NYTBookService is enum which implemetns ```NetworkService```. It helps to maintain different request and provide clean interface to implemet different request logic. It also helped to reduce the number of bugs due to strict type chekcing at compile time. Please refer [NYTBookService](https://github.com/codestergit/NYTBooks/blob/a27585f9bd89e727c6e8e38aa2ce1b02e9ed6dad/NYTBooks/Networking/NYTBookService.swift#L13)


#### [Observer](https://github.com/codestergit/NYTBooks/blob/master/NYTBooks/Observer/Observer.swift)

This class helps to bind different types of data.

#### [ResponseStatus](https://github.com/codestergit/NYTBooks/blob/a27585f9bd89e727c6e8e38aa2ce1b02e9ed6dad/NYTBooks/Networking/Generic/NetworkService.swift#L85-L89)

It's a simple generic enum (Result type) which provides different states for asynchornous data handling.

## [Searching](https://github.com/codestergit/NYTBooks/blob/master/NYTBooks/ViewModels/BookViewModel.swift#L91-L119)

We can search the books on three levels. If keyword matches in Title, Publisher, Description than we show the books.

There is no overlapping of books in search. It means if a book have keyword in title than if same keyword appears in Description we do not show it in "Found in Description" section in  table view.

I have used [forward search](https://github.com/codestergit/NYTBooks/blob/master/NYTBooks/ViewModels/BookViewModel.swift#L92-L96) for filter books searching. I have optimised the search for filter books. For e.g.: If we search for "Tw" than all books filtered by this keyword. However if we search "Twi" than already filtered books needs searching. We do not need to search all books again.

### Other classes

#### [BookViewController](https://github.com/codestergit/NYTBooks/blob/master/NYTBooks/ViewControllers/BookViewController.swift) 

BookViewController provides the basic UI functionality. It handles the ui rendering and action handing of view.

#### [BookViewModel](https://github.com/codestergit/NYTBooks/blob/master/NYTBooks/ViewModels/BookViewModel.swift)

BookViewModel provides the tableview rendering logic and search logic. It notifies BookViewController with the help of ```UIState``` enum. 
```UIState``` is enum which have different states to handle the BookViewController view renderings.

#### [BookViewModelable](https://github.com/codestergit/NYTBooks/blob/master/NYTBooks/ViewModels/BookViewModelable.swift)

`BookViewModelable` is protocol which provides inteface to intreact with `BookViewController`.








