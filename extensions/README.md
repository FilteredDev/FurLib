# README File for all default extensions

## Jump To
* [FLMake](https://github.com/FilteredDev/FurLib/tree/main/extensions#flmake) - Quickly load libraries in a synchronous manner
* [Component]() - Create Components with ease with a fully custom MCS. Coming soon
* [Furdux]() - A FurLib implementation of Rodux (coming soon)

## FLMake

Turns FurLib's loader from asynchronous to synchronous.

### Functions
|Method Name|Returns|Details|
|-|-|-|
|FLMake:Compile(``array`` LibrariesToLoad)|``Map``|Loads all modules in the ``LibrariesToLoad`` array, this starts from the top and continues until the end. Priority matters|
|FlMake:GetAllExtensions()|``Map<Libary>``|Fetches every extension, or waits for then to finish loading|

### Code Example
```lua
local FurLibContainer = require(script.FurLib).new()
local FLMake = FurLibContainer:WaitForExtension("FLMake")
local libraries = FLMake:Compile{
  library1, library2
}

libraries.library1.SayHi() --> hello world
```
