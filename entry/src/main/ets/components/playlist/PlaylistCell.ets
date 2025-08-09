import { Playlist, PlaylistRouteParams } from "../../model"

@ComponentV2
export struct PlaylistCell {
  @Consumer('stack') stack?: NavPathStack;
  @Param @Require playlist: Playlist

  build() {
    Row({ space: 12 }) {
      Stack({ alignContent: Alignment.TopStart }) {
        Image(this.playlist.coverImgUrl)
          .size({ width: 64, height: 64 })
          .borderRadius(8)
        if (this.playlist.highQuality) {
          Row() {
            Text('优质')
              .fontColor($r('app.color.white'))
              .fontSize(12)
          }.backgroundColor($r('app.color.green'))
          .padding({ top: 2, bottom: 2, left: 4, right: 4 })
          .borderRadius({ bottomRight: 8 })
        }
      }
      Column({ space: 8 }) {
        Text(this.playlist.name)
          .fontSize(16)
          .fontColor($r('app.color.text_lv1'))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Row({ space: 6 }) {
          Text(this.playlist.trackCount + '首')
            .fontSize(14)
            .fontColor($r('app.color.text_lv2'))
          Text(this.playlist.description)
            .fontSize(14)
            .fontColor($r('app.color.text_lv2'))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .layoutWeight(1)
        }
      }.layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Image($r('app.media.arrow'))
        .size({ width: 24, height: 24 })
        .fillColor($r('app.color.text_lv2'))
    }.width('100%')
    .onClick(() => {
      const params: PlaylistRouteParams = { id: this.playlist.id };
      this.stack?.pushPathByName("Playlist", params, false);
    })
  }
}