@ComponentV2
export struct CardHeader {
  @Param title: string = '';
  private allClickHandler?: () => void;

  onClickAll(callback: () => void) {
    this.allClickHandler = callback;
    return this;
  }

  build() {
    Row() {
      Text(this.title)
        .fontSize(16)
        .fontWeight(600)
        .fontColor($r('app.color.text_lv1'))
      Row() {
        Text('全部')
          .fontSize(12)
          .fontColor($r('app.color.text_lv2'))
        Image($r('app.media.arrow'))
          .size({ width: 20, height: 20 })
      }.alignItems(VerticalAlign.Center)
      .onClick(() => {
        if (this.allClickHandler) {
          this.allClickHandler();
        }
      })
    }.width('100%')
    .height(24)
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
  }
}