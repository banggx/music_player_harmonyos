import { SongItem, SongSearchRes, PlayerRouteParams } from "../../model";
import { searchService } from "../../service";
import { SearchType } from '../../constants';
import { SongCell } from "../song/SongCell";
import { formatSongModel } from '../../utils/song';
import { LoadMore } from '../common/LoadMore';
import { playerStore } from '../../store';

@ComponentV2
export struct SongResult {
  @Consumer('stack') stack?: NavPathStack;
  @Param @Require searchKey: string;
  @Local songs: SongItem[] = [];
  @Local count: number = 0;
  @Local loading: boolean = false;

  async searchSongs() {
    this.loading = true;
    const offset = this.songs.length;
    const res = await searchService.search<SongSearchRes>(this.searchKey, SearchType.song, 30, offset);
    if (res.code === 200) {
      this.songs.push(...res.result.songs.map(formatSongModel));
      this.count = res.result.songCount;
    }
    this.loading = false;
  }

  async aboutToAppear() {
    this.searchSongs();
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.TopStart }) {
        Row() {
          Row({ space: 8 }) {
            Image($r('app.media.circle_play'))
              .size({ width: 24, height: 24 })
            Text('播放全部')
              .fontSize(16)
              .fontColor($r('app.color.text_lv1'))
              .fontWeight(500)
          }.onClick(() => {
            playerStore.clearSongs();
            playerStore.addSongs(this.songs.map(item => item.id));
            const params: PlayerRouteParams = { id: this.songs[0].id };
            this.stack?.pushPathByName("Player", params, false);
          })
          Text('全部' + this.count + '首')
            .fontSize(14)
            .fontColor($r('app.color.text_lv2'))
        }.height(32)
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)

        List({ space: 24 }) {
          ForEach(this.songs, (song: SongItem) => {
            ListItem() {
              SongCell({ song })
            }
          })
          ListItem() {
            LoadMore({ loading: this.loading })
          }
        }.position({ top: 48 })
        .height('calc(100% - 48vp)')
        .layoutWeight(1)
        .onScrollIndex((_: number, end: number) => {
          if (end >= this.songs.length - 1 && this.songs.length < this.count) {
            this.searchSongs();
          }
        })
      }
    }.width('100%')
    .height('100%')
  }
}