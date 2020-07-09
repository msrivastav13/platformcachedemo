# Performance Analysis Using Platform Cache

The repo has a lightning web component `objectPicker` that uses apex controller `ObjectPickerController.cls`

The component controller `ObjectPickerController.cls` has better CPU time and Heap if the data from describe is cached using platform cache.

The below table shows comparison of using platform cache vs without any cache for describe calls

Apex Method | CPU Time(Avg) in ms | Heap Size(Avg)
--- | --- | ---
**fetchObjectNamesUsingGlobalDescribe** | 1307ms | 80000
**fetchObjectNamesUsingGlobalDescribeFromCache** | 20ms | 1300