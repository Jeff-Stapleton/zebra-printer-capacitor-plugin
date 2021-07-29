# zebra-printer-capacitor-plugin

Capacitor plugin for the Zebra printer SDK. This plugin was developed with the help of mainly two online tutorials:

[Creating Capacitor Plugins](https://capacitorjs.com/docs/v3/plugins/creating-plugins)

[Using a C Library inside a Swift framework](https://medium.com/swift-and-ios-writing/using-a-c-library-inside-a-swift-framework-d041d7b701d9)

## Setup

As of now, this plugin only supports iOS. Before we can begin development we must run the following commands

```bash
npm run build
cd ios/
pod install
```

## Testing

To locally test the plugin you can link it to your application by running the following command:

```bash
npm install ../zebra-printer-capacitor-plugin
```

Note that the path to the plugin, is the path to the directory that contains the plugin's `package.json`

Finally to make your application aware of plugin run the following command:

```bash
npx cap sync 
```

The plugin can also be easily unlinked by simply running:

```bash
npm uninstall zebra-printer-capacitor-plugin
```

## iOS Development

to begin development simply open `ios/Plugin.xcworkspace` in Xcode

To add new functionality to the plugin in you will have to first define your methods signature in the `src/definitions.ts`

```ts
export interface PrinterPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
  print(options: { value: string }): Promise<{ value: string }>;
}
```

Regardless that this plugin is only for iOS you will have to implement the new method in the `src/web.ts`

```ts
async print(options: { value: string }): Promise<{ value: string }> {
    throw new Error('Method not implemented.' + options);
}
```

There is one more place where we need to declare the new method's signature, in the `ios/Plugin/PrinterPlugin.m`

```m
CAP_PLUGIN(PrinterPlugin, "Printer",
           CAP_PLUGIN_METHOD(echo, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(print, CAPPluginReturnPromise);
)
```

With that done, you can finally implement the method's functionality in the `ios/Plugin/PrinterPlugin.swift`

## libZSDK_API.a

This plugin is mainly a wrapper for the ZebraPrinter SDK. The SDK was implemented in objective-c so getting it to play nice with swift was not easy. Below I will include a quick summary as to how the static library is implemented and packaged.

Since the Zebra SDK was written in objective-c we can't import it's headers into our swift framework and bridging headers are not supported in swift frameworks so we were left with one option, that is to create a module. This module can be found `ios/Plugin/ZebraSDK`

All th functionality of the SDK is contained within the `ios/Plugin/ZebraSDK/libZSDK_API.a` static library. We will need to configure the Plugin to be aware of this library. In Xcode open the Plugin.xcodeproj and go the "Build Phases" tab. Under the "Link Binary With Library" section add the reference to to `ios/Plugin/ZebraSDK/libZSDK_API.a`. Note this will also add the reference to "Frameworks, Libraries, and Embedded Content" under the "General" tab.

Next we will need to create a `.modulemap` to define the module and so it can be imported for use in the plugin. 

```modulemap
module ZebraSDK [system][extern_c] {
    header "../include/ZebraSDK.h"
    link "z"
    export *
}
```

Here we are importing the header for the main header `ios/Plugin/ZebraSDK/include/ZebraSDK.h` within this header is the imports of all the other headers we are using the the plugin. It's also import to note that we must also export this so that the consuming plugin can be aware of all the header files.

With that done there is just one final step before we can import our module for use in the plugin. In Xcode open the Plugin.xcodeproj and go the "Build Settings" tab. under the "Swift Compiler - Search Paths" find the setting "Import Paths" set that value to `${SRCROOT}/Plugin/ZebraSDK`. Now when Xcode is trying to resolve module imports in swift it will also check this location and find our module.

Thats it you are now ready to import the moduel in our `.swift` file and call functions from the SDK to

```swift
import ZebraSDK

@objc(PrinterPlugin)
public class PrinterPlugin: CAPPlugin {

    // ...

    @objc func print(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        let connection = TcpPrinterConnection.init(address: "10.200.004.060", andWithPort:6101);
         
        // ...

        call.resolve([
            "success": true
        ])
    }
```