import { AlbumItem } from "../../model/ablum"
import { SafeBottomArea } from "../common";

@ComponentV2
export struct AlbumDescSheet {
  @Param @Require album: AlbumItem;
  @Param bgColor: string = '#222628';
  @Local visible: boolean = false;

  @Builder
  sheetBuilder() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Image($r('app.media.close'))
        .size({ width: 32, height: 32 })
        .fillColor($r('app.color.white'))
        .zIndex(100)
        .onClick(() => {
          this.visible = false;
        })
      Scroll() {
        Column() {
          Stack() {
            Image($r('app.media.record_bg'))
              .size({ width: 200, height: 200 })
              .position({ top: -24 })
            Image(this.album.picUrl)
              .size({ width: 200, height: 200 })
              .borderRadius(16)
              .zIndex(100)
          }
          Text(this.album.name)
            .fontColor($r('app.color.white'))
            .fontSize(20)
            .fontWeight(500)
            .margin({ top: 24 })
          Divider()
            .width('100%')
            .linearGradient({
              direction: GradientDirection.Right,
              colors: [[$r('app.color.white_10'), 0.0], [$r('app.color.white_80'), 0.5], [$r('app.color.white_10'), 1.0]]
            })
            .margin({ top: 24, bottom: 24 })
          Column({ space: 16 }) {
            Text('发行公司: ' + this.album.company)
              .fontSize(14)
              .lineHeight(20)
              .fontColor($r('app.color.white_80'))
            Text('专辑类别: ' + this.album.subType)
              .fontSize(14)
              .lineHeight(20)
              .fontColor($r('app.color.white_80'))
            Text(this.album.description)
              .fontSize(14)
              .lineHeight(24)
              .fontColor($r('app.color.white_80'))
          }.width('100%')
          .alignItems(HorizontalAlign.Start)
          SafeBottomArea()
        }.padding({ top: 24 })
        .width('100%')
      }.width('100%')
      .height('100%')
    }.width('100%')
    .padding(24)
    .backgroundColor(this.bgColor)
  }

  build() {
    Row({ space: 4 }) {
      Text(this.album.description)
        .maxLines(1)
        .fontColor($r('app.color.white_50'))
        .fontSize(14)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .layoutWeight(1)
      Image($r('app.media.arrow_down'))
        .size({ width: 12, height: 12 })
        .fillColor($r('app.color.white_50'))
        .rotate({ angle: -90 })
    }.onClick(() => {
      this.visible = !this.visible;
    })
    .bindSheet($$this.visible, this.sheetBuilder, {
      height: SheetSize.LARGE,
      backgroundColor: $r('app.color.purple_10'),
      showClose: false,
      maskColor: $r('app.color.black_10')
    })
  }
}