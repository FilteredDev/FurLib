FurLib is a framework that centralises all libraries registered under it, making it easy to prevent redundant code.

## Motivation

When working with libraries, I end up running into lots of problems with control flow, when a child module also requires the same module the script is using, eventually resulting in unmaintainable spaghetti code.

The point of FurLib is to try and make every library easily access each other with a simple object, instead of needing to constantly require the same module across scripts, and creating redundant and possibly spaghetti code.

FurLib also contains a shared variable table for the sake of abstraction.

## Introduction to FurLib Libraries

All of FurLib libraries should follow the basic syntax when creating libraries
```lua
local function SayHi(self)
  print("Hello World!")
end

local Library = {}
Library.ID = "NewLibrary" --this has to be unique across all libraries

function Library:start(furLibContainer) --furLibContainer is the FurLib object created from the outside source code
  --declare functions into self here
  self.SayHi = SayHi
end

return Library
```

When you register the module in FurLib, FurLib itself runs an asynchronous call to the start function, returning a new library object that can be extended (under ``self``), and the container the module was registered under.

All libraries require an ``ID`` string variable, which must be unique across all libraries in the container, and a ``start`` function that is used when the library is registered

To then load this library into FurLib, assuming FurLib, and the library are a child of the script itself.

```lua
local FurLib = require(script.FurLib) --require FurLib
local NewContainer = FurLib.new() --make a new FurLib container

NewContainer:Register(script.Library) --loads the new library into the container
local SayHiLib = NewContainer:WaitForLibrary("SayHi") --wait for the container to load, since FurLib loads libraries asynchronously

SayHiLib:SayHi() --> Hello World!
```

## API

## FurLib Module

### Functions
|Method|Returns|Description|
|-|-|-|
|FurLib.new()|``FurLibContainer``|Returns a new container that can be used for registering libraries

## FurLibContainer

### Functions
|Method|Returns|Description|
|-|-|-|
|Container:GetExtensions(``string`` ExtensionName)|``Library``|Returns an extension registed in the container.|
|Container:GetLibrary(``string`` LibraryName|``Library``|Returns a library registered  in the container|
|Container:GetVariable(``string`` VariableName)|``Variant``|Returns a stored variable or nil based on the VariableName|
|Container:RegisterLibrary(``ModuleScript`` Library)|``void``|Registers a library, this method is asynchronous, use the ``WaitForLibrary`` method to know and fetch the library when it's finished loading|
|Container:SetVariable(``string`` VariableName, ``Variant`` Value)|``void``|Stores ``Value`` under ``VariableName`` in the container|
|Container:WaitForExtension(``string`` ExtensionName)|``Library``|Either fetches an extension if it's already loaded, otherwise waits for the ``ExtensionLoaded`` event to fire with the matching ``ExtensionName``. This method can yield indefinitely.
|Container:WaitForLibrary(``string`` LibraryName)|``Library``|Either fetches a library if it's already loaded, otherwise waits for the ``LibraryLoaded`` event to fire with the matching ``LibraryName``. This method can yield indefinitely.

### Events
|Event Name|Parsed Arguments|Details|
|-|-|-
|Container.ExtensionFailedToLoad|``string`` ExtensionID, ``string`` Error|Fired when an extension fails to load|
|Container.ExtensionLoaded|``string`` ExtensionID|Fired when an extension successfully loads|
|Container.LibraryFailedToLoad|``string`` LibraryID, ``string`` Error|Fired when a library fails to load|
|Container.LibraryLoaded|``string`` LibraryID|Fired when a library successfully loads|
|Container.VariableChanged|``string`` VariableName, ``Variant`` ValueChangedTo|Fired when a shared variable in the container is changed|

## Library
Libraries and Extensions both use this construct, this part of the documentation exists to enforce what's required by the loader.

### Properties
|Property|Type|Details|
|-|-|-|
|Library.ID|``string``|The unique identifier for this library, extensions and libraries both have their own unique storage array.
|Library.State|``string``|The current state of the library, this can be one of three values: ``NotStartedYet``, ``Running`` or ``Failed``|

### Methods
|Method|Returns|Details|
|-|-|-
|Library:start(``FurLibContainer`` container)|``void``|The function that is called when a library is required, this is mandatory for a library to load successfully|

## Issues
Feel free to report any issues.

