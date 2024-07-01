import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { addCustomUserAgent } from '../main/ets/inject_adapter/multi_instance/NativeRequest'
import { http } from '@kit.NetworkKit'


export default function NativeRequestTest() {
  describe('NativeRequestTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('addCustomUserAgent', 0, () => {
      let webUserAgent: string = 'xxxx'
      let customUserAgent: string = "WUBA (Phone; OpenHarmony)"

      let option: http.HttpRequestOptions = {}
      addCustomUserAgent(option, webUserAgent, customUserAgent)
      expect(option?.header?.['user-agent']).assertEqual(webUserAgent + ' ' + customUserAgent)

      option = {
        header: {
          'Content-Type': 'application/json'
        }
      }
      addCustomUserAgent(option, webUserAgent, customUserAgent)
      expect(option?.header?.['user-agent']).assertEqual(webUserAgent + ' ' + customUserAgent)

      option = {
        header: {
          'user-agent': 'liuyang'
        }
      }
      addCustomUserAgent(option, webUserAgent, customUserAgent)
      expect(option?.header?.['user-agent']).assertEqual('liuyang' + ' ' + customUserAgent)
    })
  })
}