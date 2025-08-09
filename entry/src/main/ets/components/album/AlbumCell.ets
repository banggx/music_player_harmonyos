import { AlbumItem } from "../../model/ablum"
import dayjs from 'dayjs';
import { AlbumRouteParams } from "../../model";

@ComponentV2
export struct AlbumCell {
  @Consumer('stack') stack?: NavPathStack;
  @Param @Require album: AlbumItem;

  build() {
    Row({ space: 12 }) {
      Image(this.album.picUrl)
        .size({ width: 64, height: 64 })
        .borderRadius(8)
      Column({ space: 8 }) {
        Text(this.album.name)
          .fontSize(16)
          .fontColor($r('app.color.text_lv1'))
        Text((this.album.artist.trans || this.album.artist.name) + `(` + dayjs(this.album.publishTime).format('YYYY-MM-DD') + ')')
          .fontSize(14)
          .fontColor($r('app.color.text_lv2'))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }.layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      Image($r('app.media.arrow'))
        .size({ width: 24, height: 24 })
    }.onClick(() => {
      const params: AlbumRouteParams = { id: this.album.id };
      this.stack?.pushPathByName("AlbumDetail", params, false);
    })
  }
}