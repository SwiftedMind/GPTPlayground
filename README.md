# GPTPlayground

GPTPlayground is an app that I use as a playground to build AI stuff with OpenAI's API. 
It is using a Swift package I am building: [GPTSwift](https://github.com/SwiftedMind/GPTSwift).

Feel free to use this app as an inspiration.

> **Note**
> The app is built on an app architecture I am currently developing: [Puddles](https://github.com/SwiftedMind/Puddles).
> It is still a bit experimental. Let me know what you think!

## Content

- [Getting Started](#getting-started)
  - [Requirements](#requirements)
- [Usage](#usage)
- [License](#license)

## Getting Started

### Requirements

- iOS 16.3+
- macOS 13.3+

This project was built using the Xcode 14.3 Beta. You might need to use that as well.

## Usage

**You will need to provide your own API key from OpenAI to compile and run the app**

Add a `Keys.plist` file in the project and add a string `OpenAI_API_Key` with your key to the dictionary.
The app's `KeysReader` should find the file as long as it is in your Bundle.

## License

MIT License

Copyright (c) 2023 Dennis Müller and all collaborators

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
