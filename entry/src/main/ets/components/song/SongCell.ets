import { OriginSong, SongFee } from "../../constants";
import { SongItem, PlayerRouteParams } from "../../model"
import { Tag } from '../common/Tag';

@ComponentV2
export struct SongCell {
  @Consumer('stack') stack?: NavPathStack;
  @Param @Require song: SongItem;

  @Computed
  get songDesc() {
    let desc = this.song.ar.map(item => item.name).join('/');
    if (this.song.al?.name) {
      desc += '·' + this.song.al.name;
    }
    return desc;
  }

  build() {
    Column() {
      Text(this.song.name)
        .fontSize(16)
        .fontColor($r('app.color.text_lv1'))
        .fontWeight(500)
      Row({ space: 4 }) {
        if (this.song.fee === SongFee.vip) {
          Tag({ text: 'VIP', type: 'primary' })
        }
        if (this.song.sq) {
          Tag({ text: 'SQ', type: $r('app.color.yellow') })
        }
        if (this.song.originCoverType === OriginSong.origin) {
          Tag({ text: '原唱', bg: $r('app.color.orange'), type: $r('app.color.white') })
        }
        Text(this.songDesc)
          .fontSize(14)
          .fontColor($r('app.color.text_lv2'))
          .layoutWeight(1)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        // 操作按钮区
        Row({ space: 12 }) {
          Image($r('app.media.love'))
            .size({ width: 20, height: 20 })
            .fillColor($r('app.color.text_lv2'))
          Image($r('app.media.play'))
            .size({ width: 20, height: 20 })
            .fillColor($r('app.color.text_lv2'))
            .onClick(() => {
              const params: PlayerRouteParams = { id: this.song.id };
              this.stack?.pushPathByName("Player", params, false);
            })
          Image($r('app.media.more'))
            .size({ width: 20, height: 20 })
            .fillColor($r('app.color.text_lv2'))
        }.margin({ left: 8 })
      }.margin({ top: 8 })
      if (this.song.alia?.length) {
        Text(this.song.alia[0])
          .fontSize(14)
          .fontColor($r('app.color.text_lv2'))
          .margin({ top: 6 })
      }
      if (this.song.recommendText) {
        Row() {
          Text(this.song.recommendText)
            .fontColor($r('app.color.orange'))
            .fontSize(12)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }.padding({ top: 2, bottom: 2, left: 4, right: 4 })
        .backgroundColor($r('app.color.orange_light'))
        .borderRadius(4)
        .margin({ top: 6 })
      }
    }.width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}