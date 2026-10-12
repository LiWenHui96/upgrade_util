import Flutter
import UIKit
import XCTest

// If your plugin has been explicitly set to "type: .dynamic" in the Package.swift,
// you will need to add your plugin as a dependency of RunnerTests within Xcode.

@testable import upgrade_util

// 单元测试覆盖 UpgradeUtilPlugin 的方法分发与 launch 参数校验。
//
// See https://developer.apple.com/documentation/xctest for more information about using XCTest.

class RunnerTests: XCTestCase {

  // MARK: - 方法分发

  /// 未实现的方法应返回 FlutterMethodNotImplemented。
  func testHandle_unknownMethod_returnsNotImplemented() {
    let plugin = UpgradeUtilPlugin()
    let call = FlutterMethodCall(methodName: "unknown", arguments: nil)

    let resultExpectation = expectation(description: "result block must be called.")
    plugin.handle(call) { result in
      XCTAssertEqual(result as! String, FlutterMethodNotImplemented)
      resultExpectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }

  // MARK: - launch 参数校验

  /// 未传任何参数时应返回 INVALID_ARGUMENT。
  func testLaunch_withoutArguments_returnsInvalidArgument() {
    expectLaunchInvalidArgument(arguments: nil)
  }

  /// 参数中缺少 url 键时应返回 INVALID_ARGUMENT。
  func testLaunch_missingURL_returnsInvalidArgument() {
    expectLaunchInvalidArgument(arguments: ["other": "value"])
  }

  /// url 不是字符串时应返回 INVALID_ARGUMENT。
  func testLaunch_urlNotString_returnsInvalidArgument() {
    expectLaunchInvalidArgument(arguments: ["url": 123])
  }

  /// url 为无法解析的非法字符串时应返回 INVALID_ARGUMENT。
  func testLaunch_invalidURLString_returnsInvalidArgument() {
    expectLaunchInvalidArgument(arguments: ["url": "invalid url with space"])
  }

  /// 校验 launch 参数非法时统一返回 code 为 INVALID_ARGUMENT 的 FlutterError。
  private func expectLaunchInvalidArgument(
    arguments: Any?,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    let plugin = UpgradeUtilPlugin()
    let call = FlutterMethodCall(methodName: "launch", arguments: arguments)

    let resultExpectation = expectation(description: "result block must be called.")
    plugin.handle(call) { result in
      let error = result as? FlutterError
      XCTAssertEqual(error?.code, "INVALID_ARGUMENT", file: file, line: line)
      resultExpectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }

  // MARK: - launch 正常调用

  /// url 合法时应通过 UIApplication 发起跳转，并以 Bool 形式回调结果。
  ///
  /// 模拟器无 App Store，`itms-apps` 链接会以 false 结束；真机上可能为 true，
  /// 因此这里仅断言回调值为 Bool，不对具体取值做环境相关的判断。
  func testLaunch_validURL_callbacksWithBoolean() {
    let plugin = UpgradeUtilPlugin()
    let call = FlutterMethodCall(
      methodName: "launch",
      arguments: ["url": "itms-apps://apps.apple.com/app/id000000000"]
    )

    let resultExpectation = expectation(description: "result block must be called.")
    plugin.handle(call) { result in
      XCTAssertTrue(result is Bool, "Expected a Bool result, got: \(String(describing: result)).")
      resultExpectation.fulfill()
    }
    waitForExpectations(timeout: 5)
  }
}