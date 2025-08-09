import { playerStore, PlayerStore } from "../../store";
import { PlayMode } from '../../constants';
import { SafeBottomArea } from '../common/SafeBottomArea';

@ComponentV2
export struct PlayListSheet {
  @BuilderParam @Require builder: () => void;
  @Local visible: boolean = false;
  @Local sheetHeight: number = 500;
  @Local store: PlayerStore = playerStore;
  @Local currentIndex: number = 0;

  @Computed
  get visitedSongs() {
    return this.store.visitedSongs.filter(song => song !== this.store.current?.song.id);
  }

  @Builder
  totalTabBuilder() {
    Text('正在播放(' + this.store.songs.length + ')')
      .fontSize(15)
      .lineHeight(24)
      .fontColor(0 === this.currentIndex ? $r('app.color.text_lv1') : $r('app.color.text_lv2'))
  }

  @Builder
  alreadyTabBuilder() {
    Text('已播歌曲(' + this.visitedSongs.length + ')')
      .fontSize(15)
      .lineHeight(24)
      .fontColor(1 === this.currentIndex ? $r('app.color.text_lv1') : $r('app.color.text_lv2'))
  }

  @Builder
  playModeBuilder(icon: Resource, text: string, target: PlayMode) {
    Row({ space: 8 }) {
      Image(icon)
        .size({ width: 20, height: 20 })
      Text(text)
        .fontSize(14)
        .fontColor($r('app.color.text_lv2'))
    }.alignItems(VerticalAlign.Center)
    .onClick(() => {
      this.store.updatePlayMode(target);
    })
  }

  @Builder
  sheetBuilder() {
    Column() {
      Tabs({ barPosition: BarPosition.Start }) {
        TabContent() {
          Column() {
            Row() {
              if (this.store.playMode === PlayMode.linear) {
                this.playModeBuilder($r('app.media.linear_play'), '顺序播放', PlayMode.random)
              } else if (this.store.playMode === PlayMode.random) {
                this.playModeBuilder($r('app.media.random_play'), '随机播放', PlayMode.circle)
              } else {
                this.playModeBuilder($r('app.media.cycle_play'), '单曲循环', PlayMode.linear)
              }
            }.width('100%')
            .justifyContent(FlexAlign.Start)
            List() {
              ForEach(this.store.songs, (song: number) => {
                ListItem() {
                  Row({ space: 8 }) {
                    Row() {
                      Text(this.store.songCache[song].song.name)
                        .fontSize(16)
                        .lineHeight(24)
                        .fontColor(song === this.store.current?.song.id ? $r('app.color.purple') : $r('app.color.text_lv1'))
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                        .maxLines(1)
                      Text('- ' + this.store.songCache[song].song.ar.map(item => item.name).join('/'))
                        .fontSize(14)
                        .lineHeight(24)
                        .fontColor(song === this.store.current?.song.id ? $r('app.color.purple') : $r('app.color.text_lv2'))
                        .layoutWeight(1)
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                    }.layoutWeight(1)
                    if (song === this.store.current?.song.id) {
                      Image($r('app.media.melody'))
                        .size({ width: 24, height: 24 })
                    }
                    Image($r('app.media.close'))
                      .size({ width: 20, height: 20 })
                      .onClick(() => {
                        this.store.removeSongs([song]);
                      })
                  }.alignItems(VerticalAlign.Center)
                  .padding({ top: 8, bottom: 8 })
                  .onClick(() => {
                    this.store.playSong(song).then(() => {
                      this.store.musicPlayer.play();
                    });
                  })
                }
              })
            }.width('100%')
            .height(200)
            .layoutWeight(1)
            .margin({ top: 12 })
            .scrollBar(BarState.Off)
          }.padding({ left: 20, right: 20 })
        }.tabBar(this.totalTabBuilder())
        TabContent() {
          Column() {
            if (this.visitedSongs.length) {
              List() {
                ForEach(this.visitedSongs, (song: number) => {
                  ListItem() {
                    Row({ space: 8 }) {
                      Row() {
                        Text(this.store.songCache[song].song.name)
                          .fontSize(16)
                          .lineHeight(24)
                          .fontColor($r('app.color.text_lv1'))
                          .textOverflow({ overflow: TextOverflow.Ellipsis })
                          .maxLines(1)
                        Text('- ' + this.store.songCache[song].song.ar.map(item => item.name).join('/'))
                          .fontSize(14)
                          .lineHeight(24)
                          .fontColor($r('app.color.text_lv2'))
                          .layoutWeight(1)
                          .maxLines(1)
                          .textOverflow({ overflow: TextOverflow.Ellipsis })
                      }.layoutWeight(1)
                      Image($r('app.media.love'))
                        .size({ width: 20, height: 20 })
                    }.alignItems(VerticalAlign.Center)
                    .padding({ top: 8, bottom: 8 })
                  }
                })
              }.width('100%')
              .height(200)
              .layoutWeight(1)
              .margin({ top: 12 })
              .scrollBar(BarState.Off)
            } else {
              Column() {
                Text('暂无数据')
                  .fontSize(14)
                  .fontColor($r('app.color.text_lv2'))
                  .textAlign(TextAlign.Center)
              }.width('100%')
              .height('100%')
              .justifyContent(FlexAlign.Center)
            }
          }.padding({ left: 20, right: 20 })
          .width('100%')
          .height('100%')
        }.tabBar(this.alreadyTabBuilder())
      }.layoutWeight(1)
      .onChange(index => {
        this.currentIndex = index;
      })
      SafeBottomArea()
    }.padding({ bottom: 12 })
  }

  build() {
    Column() {
      Row() {
        this.builder()
      }
      .onClick(() => {
        this.visible = !this.visible;
      })
      .bindSheet($$this.visible, this.sheetBuilder, {
        height: this.sheetHeight,
        backgroundColor: $r('app.color.purple_10'),
        showClose: false,
        maskColor: $r('app.color.black_10')
      })
    }
  }
}