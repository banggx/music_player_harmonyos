import { commonService } from '../../service';
import { SongItem, PlayerRouteParams } from '../../model';
import { CardHeader } from '../common/CardHeader';

@ComponentV2
export struct RecommendSong {
  @Consumer('stack') stack?: NavPathStack;
  @Local songs: SongItem[] = [];

  async aboutToAppear() {
    const res = await commonService.getRecommendSongs();
    if (res.code === 200) {
      this.songs = res.data.dailySongs;
    }
  }

  build() {
    Column() {
      CardHeader({ title: '推荐歌曲' })
      List({ space: 16 }) {
        ForEach(this.songs, (song: SongItem) => {
          ListItem() {
            Row() {
              Image(song.al.picUrl)
                .size({ width: 64, height: 64 })
                .borderRadius(8)
              Column() {
                Text(song.name)
                  .fontSize(14)
                  .fontColor($r('app.color.text_lv1'))
                  .lineHeight(22)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                Text(song.ar.map(item => item.name).join(', '))
                  .fontSize(12)
                  .fontColor($r('app.color.text_lv2'))
                  .lineHeight(16)
                  .textAlign(TextAlign.Start)
                  .margin({ top: 4 })
              }.alignItems(HorizontalAlign.Start)
              .margin({ left: 12 })
            }.width('100%')
            .onClick(() => {
              const params: PlayerRouteParams = { id: song.id };
              this.stack?.pushPathByName("Player", params, false);
            })
          }
        })
      }
      .margin({ top: 12 })
    }.width('100%')
  }
}
