# CDBUUID

[![CI Status](http://img.shields.io/travis/yocaminobien/CDBUUID.svg?style=flat)](https://travis-ci.org/yocaminobien/CDBUUID)
[![Version](https://img.shields.io/cocoapods/v/CDBUUID.svg?style=flat)](http://cocoapods.org/pods/CDBUUID)
[![License](https://img.shields.io/cocoapods/l/CDBUUID.svg?style=flat)](http://cocoapods.org/pods/CDBUUID)
[![Platform](https://img.shields.io/cocoapods/p/CDBUUID.svg?style=flat)](http://cocoapods.org/pods/CDBUUID)

## Description 

The CDBUUID class provides methods for generating compact, unique ids.
It based on `Identify` class of https://github.com/weaver/Identify
but with removed ASIdentifierManager which has issue when submitting to the app store
Ids are encoded as urlsafe base64 (letters, numbers, underscores, dashes),
any `=` padding is stripped off, and they are given a single character
prefix.

## Example

call [CDBUUID UUIDString]

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

CDBUUID is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CDBUUID"
```

## Author

Kanstantsin Bucha aka
yocaminobien, yocaminobien@gmail.com

## License

CDBUUID is available under the MIT license. See the LICENSE file for more info.
