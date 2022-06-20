# GS-TechChallenge

## Notes to support my solution

I am using Xcode 13.4 during development, so it might have some new API from SDKs for iOS 15.5 which not supported from earlier version Xcode. If time permits, I definitely will test the project using earlier version of Xcode.

### Assumptions:

Due to the fact this is a taking home test, I didn’t ask enough questions before working on the tasks, simply to speed up the process. However, at work, I often ask many questions as possible to eliminate the ambiguities lying between the requirements.

#### Example of question I would ask
After clicking the filter then click the same filter again, do we need to reset the list?

e.g. After initial list loaded, click on food filter button, then only displays items under food category, then click on the food filter button again, do we need to show all the items?

### How do I organise the code base:

I following MVVM design pattern when building the SwiftUI Views, thus all the logic is extracted to ViewModel class. And we could unit test many logic as possible, the view is just dummy view (containing less logic/no logic as possible).

e.g. Moved the `func ratio(for categoryIndex: Int)`, and `func offset(for categoryIndex: Int)` from RingView into InsightsViewModel.

Taking consideration of modularising the code base, I created the extra layer of ViewData.

`*ViewData` is used for partial view
And each screen has one ViewModel, but multiple `*ViewData` 
E.g. `RingViewData` viewData for building `RingView`

This approach helps us to reuse the view much easier as it is coupled with some shared data type. And we could move the view to different framework.
