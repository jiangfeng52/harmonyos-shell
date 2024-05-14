export class URL {
  protocol: string = 'https'
  hostname: string = ''
  port: number | null = null
  path: string = ''
  search: string = ''
  hash: string = ''

  constructor(urlString: string) {
    this.parseURL(urlString);
  }

  private parseURL(urlString: string) {
    const urlRegex = /^(https?):\/\/([^:/]+)(?::(\d+))?(\/[^?#]*)?(\?[^#]*)?(#.*)?$/;
    const match = urlString.match(urlRegex);

    if (!match) {
      throw new Error('Invalid URL format');
    }

    this.protocol = match[1]
    this.hostname = match[2]
    const portStr = match[3]
    this.path = match[4]??''
    this.search = match[5]??''
    this.hash = match[6]??''
    this.port = portStr ? parseInt(portStr, 10) : null;
  }

  toString(): string {
    const portStr = this.port ? `:${this.port}` : '';
    return `${this.protocol}://${this.hostname}${portStr}${this.path}${this.search}${this.hash}`;
  }
}
