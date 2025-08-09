import { ImmersiveMode } from "@kit.ArkUI";
import { SingerItem, AlbumItem } from "../../model";

@ComponentV2
export struct AlbumSingers {
  @Param @Require album: AlbumItem;
  private uiContext = this.getUIContext();
  private promptAction = this.uiContext.getPromptAction();
  @Local dialogId: number = 0;

  @Builder
  singerBuilder() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Image($r('app.media.close'))
        .size({ width: 24, height: 24 })
        .zIndex(100)
        .onClick(() => {
          this.promptAction.closeCustomDialog(this.dialogId)
        })
      Scroll() {
        Column() {
          List({ space: 16 }) {
            ForEach(this.album.artists, (ar: SingerItem) => {
              ListItem() {
                Row({ space: 16 }) {
                  Image(ar.img1v1Url)
                    .size({ width: 32, height: 32 })
                    .borderRadius(4)
                  Text(ar.name)
                    .fontSize(17)
                    .fontColor($r('app.color.text_lv1'))
                }.alignItems(VerticalAlign.Center)
              }
            })
          }
        }.justifyContent(FlexAlign.Start)
      }
    }.width('100%')
    .height('50%')
    .padding(24)
    .borderRadius(8)
    .backgroundColor($r('app.color.white'))
  }

  build() {
    Row({ space: 4 }) {
      Text('歌手: ' + this.album.artists.map((item) => item.name).join('/'))
        .maxLines(1)
        .fontSize(14)
        .fontColor($r('app.color.white_80'))
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .layoutWeight(1)
      Image($r('app.media.arrow_down'))
        .size({ width: 12, height: 12 })
        .fillColor($r('app.color.white_80'))
        .rotate({ angle: -90 })
    }.alignItems(VerticalAlign.Center)
    .onClick(() => {
      this.promptAction.openCustomDialog({
        builder: () => {
          this.singerBuilder();
        },
        cornerRadius: 12,
        immersiveMode: ImmersiveMode.EXTEND
      }).then((dialogId: number) => {
        this.dialogId = dialogId;
      })
    })
  }
}