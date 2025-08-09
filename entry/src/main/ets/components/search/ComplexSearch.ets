import { searchService } from '../../service';
import { SearchType } from '../../constants';
import { ComplexSearchRes, ComplexSearchResult, SongItem, Playlist, SingerItem, AlbumItem, SimQueryItem } from '../../model';
import { Loading } from '../common/Loading';
import { SongCell } from '../song/SongCell';
import { PlaylistCell } from '../playlist/PlaylistCell';
import { SingerCell } from '../singer/SingerCell';
import { AlbumCell } from '../album/AlbumCell';
import { LengthMetrics } from '@kit.ArkUI';

@Extend(Text)
function headerTitle() {
  .fontSize(18)
  .fontWeight(500)
  .fontColor($r('app.color.text_lv1'))
  .width('100%')
}

@ComponentV2
export struct ComplexSearch {
  @Param @Require searchKey: string;
  @Param updateTab: ((index: number) => void) | null = null;
  @Local result: ComplexSearchResult | null = null;

  async aboutToAppear() {
    const res = await searchService.search<ComplexSearchRes>(this.searchKey, SearchType.complex);
    if (res.code === 200) {
      this.result = res.result;
    }
  }

  @Builder
  moreTextBtn(text: string, tab: number) {
    Row() {
      Text(text)
        .fontSize(13)
        .fontColor($r('app.color.text_lv1'))
      Image($r('app.media.arrow'))
        .size({ width: 16, height: 16 })
    }.onClick(() => {
      this.updateTab?.(tab);
    })
  }

  build() {
    Column() {
      if (this.result) {
        Scroll() {
          Column() {
            /* 单曲 */
            Column({ space: 12 }) {
              Row() {
                Text('单曲').headerTitle()
                Row() {
                  Image($r('app.media.play'))
                    .size({ width: 20, height: 20 })
                }.padding({ left: 8, right: 8, top: 2, bottom: 2 })
                .backgroundColor($r('app.color.white'))
                .borderRadius(20)
              }.width('100%')
              .justifyContent(FlexAlign.SpaceBetween)
              .alignItems(VerticalAlign.Center)
              Column({ space: 24 }) {
                ForEach(this.result.song.songs, (song: SongItem) => {
                  SongCell({ song })
                })
                this.moreTextBtn(this.result.song.moreText, 1)
              }.justifyContent(FlexAlign.Start)
            }

            /* 歌单 */
            Column({ space: 12 }) {
              Text('歌单').headerTitle()
              Column({ space: 24 }) {
                ForEach(this.result.playList.playLists, (playlist: Playlist) => {
                  PlaylistCell({ playlist })
                })
                this.moreTextBtn(this.result.playList.moreText, 2)
              }.justifyContent(FlexAlign.Start)
            }.margin({ top: 24 })

            /* 歌手 */
            Column({ space: 12 }) {
              Text('歌手').headerTitle()
              Column({ space: 24 }) {
                ForEach(this.result.artist.artists, (singer: SingerItem) => {
                  SingerCell({ singer })
                })
                this.moreTextBtn(this.result.artist.moreText, 4)
              }.justifyContent(FlexAlign.Start)
            }.margin({ top: 24 })

            /* 专辑 */
            Column({ space: 12 }) {
              Text('专辑').headerTitle()
              Column({ space: 24 }) {
                ForEach(this.result.album.albums, (album: AlbumItem) => {
                  AlbumCell({ album })
                })
                this.moreTextBtn(this.result.album.moreText, 3)
              }.justifyContent(FlexAlign.Start)
            }.margin({ top: 24 })

            /* 相关搜索 */
            Column({ space: 12 }) {
              Text('相关搜索').headerTitle()
              Flex({ wrap: FlexWrap.Wrap, space: { main: LengthMetrics.vp(12), cross: LengthMetrics.vp(8) } }) {
                ForEach(this.result.sim_query.sim_querys, (sim: SimQueryItem) => {
                  Button() {
                    Text(sim.keyword)
                      .fontSize(16)
                      .fontColor($r('app.color.text_lv1'))
                      .lineHeight(20)
                  }.padding({ top: 6, bottom: 6, left: 12, right: 12 })
                  .backgroundColor($r('app.color.black_10'))
                })
              }
            }.margin({ top: 24 })
          }
        }.scrollBar(BarState.Off)
      } else {
        Loading()
      }
    }.width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
  }
}