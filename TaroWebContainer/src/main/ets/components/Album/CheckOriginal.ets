@Component
export struct CheckOriginal {
  @Link checked: boolean;
  @Prop active: boolean;

  build() {
    Row({ space: 5 }) {
      Stack({ alignContent: Alignment.Center }) {
        Circle()
          .width(14)
          .height(14)
          .fillOpacity(0)
          .strokeWidth(1)
          .stroke((this.active && this.checked) ? Color.Green : (this.active ? Color.White : '#555555'))
          .antiAlias(true)
        Circle()
          .width(9)
          .height(9)
          .fillOpacity((this.checked || !this.active) ? 1 : 0)
          .fill(!this.active ? '#888888' : (this.active ? Color.Green : Color.White))
          .antiAlias(true)
      }

      Text('原图')
        .fontColor(Color.White)
    }
    .onClick(() => {
      if (this.active) {
        this.checked = !this.checked;
      }
    })
  }
}
