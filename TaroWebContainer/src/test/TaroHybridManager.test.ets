import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { getFromParameter } from '../main/ets/tarohybrid/TaroHybridCoreInstance'


export default function TaroHybridManagerTest() {
  describe('TaroHybridManagerTest', () => {
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
    it('TaroHybridManager.getFromParameter', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const a = getFromParameter('https://harmonymini.58.com/mps/main/index.html#/pages/index/index?aa=b&tarofrom=native&cc=aaa')
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(1)

      const b = getFromParameter('https://harmonymini.58.com/mps/main/index.html#/pages/index/index?aa=b&tarofrom=native_1&cc=aaa')
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(b).assertEqual(1)

      const c = getFromParameter('https://harmonymini.58.com/mps/main/index.html#/pages/index/index?aa=b&tarofrom=native_2&cc=aaa')
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(c).assertEqual(2)

      const d = getFromParameter('https://harmonymini.58.com/mps/main/index.html#/pages/index/index?aa=b&tarofrom=native_2')
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(d).assertEqual(2)

      const f = getFromParameter('https://harmonymini.58.com/mps/main/index.html#/pages/index/index?tarofrom=native_2')
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(f).assertEqual(2)

      const e = getFromParameter('https://harmonymini.58.com/mps/main/index.html#/pages/index/index?tarofrom=native')
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(e).assertEqual(1)

      const g = getFromParameter('https://harmonymini.58.com/mps/main/index.html#/pages/index/index?tarofrom=native_ss')
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(g).assertEqual(-1)
    })
  })
}