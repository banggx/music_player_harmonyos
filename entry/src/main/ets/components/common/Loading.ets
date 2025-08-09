@ComponentV2
export struct Loading {
  @Param text: string = '加载中...';
  build() {
    Column() {
      LoadingProgress()
        .width(50)
        .height(50)
        .color($r('app.color.purple'))
      Text(this.text)
        .fontSize(14)
        .fontColor($r('app.color.text_lv2'))
        .margin({ top: 16 })
    }.width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}