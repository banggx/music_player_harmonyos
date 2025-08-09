import { appStorageConnect, AppStorageModel } from '../storage/appStorage';
import { PlayerRouteParams, SongItem, FormatLyricItem } from '../model';
import { songService } from '../service';
import { timeStringToMs } from '../utils/tools';
import { playerStore, PlayerStore } from '../store';
import { SongPlay } from '../components/player/SongPlay';
import { SongLyric } from '../components/player/SongLyric';
import { Loading } from '../components/common/Loading';

@Entry
@ComponentV2
export struct Player {
  @Consumer('stack') stack?: NavPathStack;
  @Local appStorage: AppStorageModel = appStorageConnect();
  uiContext = this.getUIContext();
  @Local safeTopHeight: number = this.uiContext.px2vp(this.appStorage.safeTopArea);
  @Local safeBottomHeight: number = this.uiContext.px2vp(this.appStorage.safeBottomArea);
  @Monitor('appStorage.safeTopArea')
  safeTopAreaChange() {
    this.safeTopHeight = this.uiContext.px2vp(this.appStorage.safeTopArea);
  }
  @Monitor('appStorage.safeBottomArea')
  safeBottomAreaChange() {
    this.safeBottomHeight = this.uiContext.px2vp(this.appStorage.safeBottomArea);
  }

  @Local currentIndex: number = 1;
  @Builder
  tabBarBuilder(text: string, index: number) {
    Text(text)
      .fontSize(16)
      .fontColor(index === this.currentIndex ? $r('app.color.text_lv1') : $r('app.color.text_lv2'))
      .fontWeight(index === this.currentIndex ? 500 : 400)
  }

  @Local store: PlayerStore = playerStore;
  @Local songId: number = 0;
  @Local lyric: Array<FormatLyricItem> = [];
  @Local songInfo: SongItem | null = null;
  @Monitor('store.current')
  updateCurrentSongInfo() {
    if (this.store.current) {
      this.songInfo = this.store.current?.song;
    }
  }

  @Local lyricIndex: number = 0;
  @Monitor('store.musicPlayer.currentTime')
  updateCurrentStepAndLyric() {
    if (!this.songInfo) return;
    let lyricIdx = this.lyricIndex;
    for (;lyricIdx < this.lyric.length;) {
      if (this.store.musicPlayer.currentTime < this.lyric[lyricIdx].time) {
        break;
      } else {
        lyricIdx++;
      }
    }
    if (lyricIdx > 0) lyricIdx--;
    this.lyricIndex = lyricIdx;
  }
  startPlaySong(songId?: number) {
    if (songId) {
      this.songId = songId;
      this.store.playSong(songId).then(() => {
        this.store.musicPlayer.play();
      });
    } else if (this.store.current) {
      this.songId = this.store.current?.song.id;
      this.songInfo = this.store.current.song;
    }
    if (this.songId) {
      this.loadSongLyric();
    }
    this.lyricIndex = 0;
  }
  async loadSongLyric() {
    const res = await songService.getSongLyric(this.songId);
    if (res.code === 200) {
      this.lyric = res.lrc.lyric.split('\n').reduce<Array<FormatLyricItem>>((lyrics, item) => {
        const match = item.match(/^\[(\d{2}:\d{2}\.\d{2,3})\]\s*(.*)$/);
        if (!match || match.length < 3) return lyrics;
        const timeStr = match[1];
        const time = timeStringToMs(timeStr);
        if (time) {
          lyrics.push({
            time,
            text: match[2]
          });
        }
        return lyrics;
      }, []);
    }
  }

  build() {
    NavDestination() {
      if (this.songInfo) {
        Stack({ alignContent: Alignment.Top }) {
          Row() {
            Image($r('app.media.arrow_down'))
              .size({ width: 24, height: 24 })
              .onClick(() => {
                this.stack?.pop();
              })
            Image($r('app.media.share'))
              .size({ width: 24, height: 24 })
          }.width('100%').height(48)
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
          .zIndex(1000)

          Tabs({ index: this.currentIndex }) {
            TabContent(){
              Text('相关')
            }.tabBar(this.tabBarBuilder('相关', 0))
            TabContent(){
              SongPlay({
                songInfo: this.songInfo,
                lyric: this.lyric,
                lyricIndex: this.lyricIndex,
                onPlay: (id) => {
                  this.startPlaySong(id)
                },
              })
            }.tabBar(this.tabBarBuilder('歌曲', 1))
            TabContent(){
              SongLyric({
                lyric: this.lyric,
                lyricIndex: this.lyricIndex
              })
            }.tabBar(this.tabBarBuilder('歌词', 2))
          }.barWidth('50%')
          .barHeight(48)
          .onChange((index) => {
            this.currentIndex = index;
          })
        }
        .width('100%')
        .height('100%')
        .padding({ left: 20, right: 20, top: this.safeTopHeight, bottom: this.safeBottomHeight })
        .backgroundImage($r('app.media.player_bg'))
        .backgroundImageSize({ width: '600%', height: '320%' })
        .backgroundImagePosition({ x: '-270%', y: '-130%' })
        .backgroundColor($r('app.color.bg_cyan'))
      } else {
        Loading()
      }
    }.hideTitleBar(true)
    .onReady(async (context: NavDestinationContext) => {
      const songId = (context.pathInfo.param as PlayerRouteParams)?.id;
      this.startPlaySong(songId);
    })
  }
}

@Builder
export function PlayerBuilder() {
  Player();
}