import { commonService } from '../../service';
import { Playlist, PlaylistRouteParams } from '../../model';
import { CardHeader } from '../common/CardHeader';

@ComponentV2
export struct HotPlaylist {
  @Consumer('stack') stack?: NavPathStack;
  @Local playlists: Playlist[][] = [];

  async aboutToAppear() {
    const res = await commonService.getHotPlaylists();
    if (res.code === 200) {
      const result: Playlist[][] = [];
      for (let i = 0; i < res.playlists.length; i += 2) {
        result.push(res.playlists.slice(i, i + 2))
      }
      this.playlists = result;
    }
  }

  build() {
    Column() {
      CardHeader({ title: '热门歌单' })
      Column({ space: 16 }) {
          List({ space: 20 }) {
            ForEach(this.playlists, (lists: Playlist[]) => {
              ListItem() {
                Column({ space: 16 }) {
                  ForEach(lists, (playlist: Playlist) => {
                    Column() {
                      Stack({ alignContent: Alignment.BottomStart }) {
                        Image(playlist.coverImgUrl)
                          .size({ width: 100, height: 100 })
                          .borderRadius(8)
                        Row() {
                          Image($r('app.media.play'))
                            .size({ width: 12, height: 12 })
                          Text(playlist.playCount.toString())
                            .fontSize(10)
                            .fontColor($r('app.color.text_lv1'))
                        }.padding({ top: 2, bottom: 2, left: 4, right: 4 })
                        .backgroundColor($r('app.color.white_80'))
                        .borderRadius('50%')
                        .position({ left: 4, bottom: 4 })
                      }
                      Text(playlist.name)
                        .maxLines(2)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                        .fontSize(12)
                        .fontColor($r('app.color.text_lv1'))
                        .lineHeight(16)
                        .margin({ top: 8 })
                      }.onClick(() => {
                      const params: PlaylistRouteParams = { id: playlist.id };
                      this.stack?.pushPathByName("Playlist", params, false);
                    })
                  })
                }
              }.width(100)
            })
          }.listDirection(Axis.Horizontal)
        .scrollBar(BarState.Off)
      }.margin({ top: 12 })
    }.width('100%')
  }
}
