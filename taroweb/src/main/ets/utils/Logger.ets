

const TAG: string = 'TaroWeb'
export class Logger {
  static log(message: string) {
    console.log(`[${TAG}] ${message}`)
  }
}