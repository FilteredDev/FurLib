# README File for all default extensions

## Jump To
* [NoAsync](https://github.com/FilteredDev/FurLib/tree/main/extensions#noasync) - FurLib Synchronous Loader
* [Component]() - Create Components with ease with a fully custom MCS. Coming soon

## NoAsync

Turns FurLib's loader from asynchronous to synchronous.

### Functions
|Method Name|Returns|Details|
|-|-|-|
|FLMake:Compile(``array`` LibrariesToLoad)|``Map``|Loads all modules in the ``LibrariesToLoad`` array, this starts from the top and continues until the end. Priority matters|
|FLMake:GetAllExtensions()|``Map<Libary>``|Fetches every extension, or waits for then to finish loading|

### Code Example
```lua
local FurLibContainer = require(script.FurLib).new()
local NoAsync = FurLibContainer:WaitForExtension("NoAsync")
local extensions = NoAsync:GetAllExtensions()
local libraries = NoAsync:Compile{
  library1, library2
}

libraries.library1.SayHi() --> hello world
```
