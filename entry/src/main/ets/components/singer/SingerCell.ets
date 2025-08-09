import { SingerItem, SingerRouteParams } from "../../model"

@ComponentV2
export struct SingerCell {
  @Consumer('stack') stack?: NavPathStack;
  @Param @Require singer: SingerItem;

  build() {
    Row({ space: 12 }) {
      Stack({ alignContent: Alignment.BottomEnd }) {
        Image(this.singer.picUrl)
          .size({ width: 64, height: 64 })
          .borderRadius('50%')
        if (this.singer.identityIconUrl) {
          Image(this.singer.identityIconUrl)
            .size({ width: 20, height: 20 })
        }
      }
      Column({ space: 8 }) {
        Row() {
          Text(this.singer.name)
            .fontSize(18)
            .fontColor($r('app.color.text_lv1'))
            .fontWeight(500)
          if (this.singer.alias.length) {
            Text('(' + this.singer.alias[0] + ')')
              .fontSize(14)
              .fontColor($r('app.color.text_lv2'))
              .maxLines(1)
              .layoutWeight(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
        }
        Row({ space: 8 }) {
          Text(`专辑 ` + this.singer.albumSize)
            .fontSize(14)
            .fontColor($r('app.color.text_lv2'))
          if (this.singer.mvSize) {
            Text(`MV ` + this.singer.mvSize)
              .fontSize(14)
              .fontColor($r('app.color.text_lv2'))
              .layoutWeight(1)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
        }
      }.alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Button() {
        Text(this.singer.followed ? '已关注' : '关注')
          .fontSize(14)
          .fontColor($r('app.color.text_lv1'))
      }.padding({ top: 4, bottom: 4, right: 12, left: 12 })
      .border({ width: 1, style: BorderStyle.Solid, color: $r('app.color.text_lv3') })
      .backgroundColor(Color.Transparent)
    }.width('100%')
    .justifyContent(FlexAlign.Start)
    .onClick(() => {
      const params: SingerRouteParams = { id: this.singer.id };
      this.stack?.pushPathByName("SingerDetail", params, false);
    })
  }
}