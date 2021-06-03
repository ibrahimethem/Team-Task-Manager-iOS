# Team Task-Manager iOS (Work in Progress)

Team Task Manager is an IOS application for task management and group chatting. You can create your team and invite others to the team to communicate and manage and complete the tasks together.

**Deployement target:** The  deployment  target  for  the  Team  Task  Manager  app  is  iOS  12.0  andlater for the first product.<br>
**Tools & Technologies:** XCode 12.\*, Swift 5, and Firebase: Firestore, Auth, Analytics, and more.

## Development Pattern

![mvc-diagram](https://user-images.githubusercontent.com/24485041/120246103-eee7d680-c277-11eb-8492-b0f73b493721.png)

MVC is a software development pattern made up of three main objects: [*for more detail*](https://www.raywenderlich.com/1000705-model-view-controller-mvc-in-ios-a-modern-approach)

- The Model is where your data resides. Things like persistence, model objects, parsers, managers, and networking code live there.
- The View layer is the face of your app. Its classes are often reusable as they don’t contain any domain-specific logic. For example, a *ILabel* is view that presents text on the screen, and it’s reusable and extensible.
- he Controller mediates between the view and the model via the delegation pattern. A classic example is a way a UITableView*communicates with its data source via the *UITableViewDataSource* protocol.

In addition to those objects, the manager module is included in this project. The manager makes works of the other modules and simplifies them. Those works are parsing and networking with the backend, sending data to the controller, and notify it to make updates on the view with given data.

Manager can be shared by different views and controllers when needed and this helps to avoid duplication in code, and passing the data through the different controllers. Besides those, child view controllers can reach the parent views easily and updates iterate some functions they own. This makes the whole logistics of the application more fluid and understandable. It also can be used to save memory for some cases.
