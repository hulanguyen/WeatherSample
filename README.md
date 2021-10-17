# WeatherSample

#1: Brief explanation for the software development principles, patterns & practices being applied
- Using swift 5, xcode 13 for development.
- Usded swift package for handle dependency.
- Applied VIPER pattern for the architecture of app. 


#2: Code folder structure and libraries and frameworks being used
##It have 3 main folder: 
- WeatherInfo: content source code
- WeatherInfoTests: Contains code for unit tests
- WeatherInfoUITests: Contains code for UI test

WeatherInfo: 
 Modules\WeatherForcast: 
 - Router
 - Presenter
 - Interactor
 - Entities
 - Views
 Utilites: 
 - Contains some helpler file for app
 Services: 
 - Contains Api service and cache services code.
 
##Third party: 
### RxSwift: ussed for binddata and passed data between boundary 
### SDWebimage: used for loading and cached image.
Applied URLCache for caching API request.

#3. All the required steps in order to get the application run on local computer:

- git clone git@github.com:
- open project and wait for it loading all package dependencies
- build and run the app with simulator.
- Deloyment target only support for iOS 13 and above

#4. Checklist of items:

Done 1. Programming language: Swift.
Done 2. Design app's architecture VIPER
Done 3. UI should be looks like in attachment.
Done 4. Write UnitTests
Done 5. Acceptance Tests
Done 6. Exception handling
Done 7. Caching handling
Done 8. Accessibility for Disability Supports:
a. VoiceOver: Use a screen reader.
b. Scaling Text: Display size and font size:
 
#5. What need to improved for app? 
1. UI need to more dynamic for adapt dynamic font size
2. Update code for fixing warning for 
