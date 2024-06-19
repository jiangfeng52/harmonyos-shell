@Observed
export class OffsetModel {
  public currentX: number;
  public currentY: number;
  public lastX: number = 0;
  public lastY: number = 0;

  constructor(currentX: number = 0, currentY: number = 0) {
    this.currentX = currentX;
    this.currentY = currentY;
  }

  reset(): void {
    this.currentX = 0;
    this.currentY = 0;
    this.lastX = 0;
    this.lastY = 0;
  }

  stash(): void {
    this.lastX = this.currentX;
    this.lastY = this.currentY;
  }
}