# README File for all default extensions

## FLMake
---

Turns FurLib's loader from asynchronous to synchronous.

|Method Name|Returns|Details|
|-|-|-|
|FLMake:Compile(``array`` LibrariesToLoad)|``Map`` A dictionary of all loaded libraries|Loads all modules in the ``LibrariesToLoad`` array, this starts from the top and continues until the end. Priority matters|
