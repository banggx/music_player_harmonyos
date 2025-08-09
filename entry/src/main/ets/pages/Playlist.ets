import { appStorageConnect, AppStorageModel } from '../storage/appStorage';
import { PlaylistRouteParams, PlayerRouteParams, Playlist as PlaylistInfo, SongItem } from "../model";
import { playlistService } from '../service';
import { SafeBottomArea, Loading, Tag } from '../components/common';
import { formatNumber } from '../utils/tools';
import { SongFee } from '../constants';
import { playerStore } from '../store';

@Entry
@ComponentV2
export struct Playlist {
  @Consumer('stack') stack?: NavPathStack;
  @Local appStorage: AppStorageModel = appStorageConnect();
  uiContext = this.getUIContext();
  @Local safeTopArea: number = this.uiContext.px2vp(this.appStorage.safeTopArea);
  @Monitor('appStorage.safeTopArea')
  safeTopAreaChange() {
    this.safeTopArea = this.uiContext.px2vp(this.appStorage.safeTopArea);
  }
  @Local playlistId: number = 0;
  @Local playlistInfo: PlaylistInfo | null = null;
  @Local songs: Array<SongItem> = [];

  async loadPlaylist() {
    const playlistRes = await playlistService.getPlaylistDetail(this.playlistId);
    const songsRes = await playlistService.getPlaylistSongs(this.playlistId);
    if (playlistRes.code === 200 && songsRes.code === 200) {
      this.playlistInfo = playlistRes.playlist;
      this.songs = songsRes.songs;
    }
  }

  @Local navHeaderOpacity: number = 0;
  scroller = new Scroller();
  @Builder
  statisticItem(icon: Resource, count: number) {
    Row({ space: 4 }) {
      Image(icon)
        .size({ width: 24, height: 24 })
      Text(formatNumber(count))
        .fontSize(15)
        .lineHeight(20)
        .fontColor($r('app.color.text_lv1'))
    }
  }

  @Builder
  listHeader() {
    Row() {
      Button() {
        Row({ space: 6 }) {
          Image($r('app.media.primary_play'))
            .size(({ width: 16, height: 16 }))
          Text('播放全部')
            .fontSize(14)
            .fontColor($r('app.color.text_lv1'))
            .onClick(() => {
              playerStore.clearSongs();
              playerStore.addSongs(this.songs.map(item => item.id));
              const params: PlayerRouteParams = { id: this.songs[0].id };
              this.stack?.pushPathByName("Player", params, false);
            })
        }.alignItems(VerticalAlign.Center)
      }.padding({ top: 8, bottom: 8, left: 12, right: 12 })
      .backgroundColor($r('app.color.white_50'))

      Image($r('app.media.order_play'))
        .size({ width: 24, height: 24 })
    }.width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .margin({ top: 16 })
  }

  build() {
    NavDestination() {
      if (this.playlistInfo) {
        Stack({ alignContent: Alignment.Top }) {
          Row() {
            Image($r("app.media.arrow_left"))
              .size({ width: 32, height: 32 })
              .fillColor(this.navHeaderOpacity > 0.4 ? $r('app.color.black_80') : $r('app.color.white'))
              .onClick(() => {
                this.stack?.pop()
              })
            Row() {
              Image($r('app.media.more'))
                .size({ width: 24, height: 24 })
                .fillColor(this.navHeaderOpacity > 0.4 ? $r('app.color.black_80') : $r('app.color.white'))
            }
            .size({ width: 32, height: 32 })
            .backgroundColor($r('app.color.white_50'))
            .borderRadius('50%')
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.Center)
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 12 + this.safeTopArea, bottom: 12 })
          .zIndex(100)
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
          .backgroundColor(`rgba(247, 246, 255, ${this.navHeaderOpacity})`)
          Scroll(this.scroller) {
            Column() {
              Image(this.playlistInfo.coverImgUrl)
                .width('100%')
                .height(360)
              Column({ space: 4 }) {
                /* 标题 */
                Text(this.playlistInfo.name)
                  .width('100%')
                  .fontSize(24)
                  .fontWeight(500)
                  .fontColor($r('app.color.text_lv1'))
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                /* 歌单作者信息 */
                Row({ space: 8 }) {
                  Image(this.playlistInfo.creator.avatarUrl)
                    .size({ width: 20, height: 20 })
                    .borderRadius('50%')
                  Text(this.playlistInfo.creator.nickname)
                    .fontSize(15)
                    .fontColor($r('app.color.text_lv1'))
                  Button() {
                    Text('关注').fontSize(14)
                      .lineHeight(16)
                      .fontColor($r('app.color.text_lv1'))
                  }.type(ButtonType.Capsule)
                  .padding({
                    top: 2,
                    bottom: 2,
                    left: 8,
                    right: 8
                  })
                  .backgroundColor(Color.Transparent)
                  .border({ width: 1, style: BorderStyle.Solid, color: $r('app.color.black_10') })

                  Row({ space: 4 }) {
                    Image($r('app.media.earphone'))
                      .size({ width: 16, height: 16 })
                    Text(formatNumber(this.playlistInfo.playCount))
                      .fontSize(12)
                      .fontColor($r('app.color.text_lv2'))
                  }
                }.width('100%')
                .margin({ top: 12 })
                .alignItems(VerticalAlign.Center)
                .justifyContent(FlexAlign.Start)

                /* 歌单描述 */
                Text(this.playlistInfo.description)
                  .width('100%')
                  .maxLines(2)
                  .fontSize(14)
                  .fontColor($r('app.color.text_lv2'))
                  .lineHeight(20)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .margin({ top: 8 })

                /* 歌单数据 */
                Row() {
                  this.statisticItem($r('app.media.subscribe'), this.playlistInfo.subscribedCount)
                  this.statisticItem($r('app.media.comments'), this.playlistInfo.commentCount)
                  this.statisticItem($r('app.media.share'), this.playlistInfo.shareCount)
                }.margin({ top: 12 })
                .width('100%')
                .justifyContent(FlexAlign.SpaceBetween)
                .alignItems(VerticalAlign.Center)

                /* 歌单歌曲 */
                List() {
                  ListItemGroup({ header: this.listHeader() }) {
                    ForEach(this.songs, (song: SongItem, index) => {
                      ListItem() {
                        Row({ space: 12 }) {
                          Text(`${index + 1}`)
                            .fontSize(18)
                            .fontWeight(500)
                            .fontColor($r('app.color.text_lv1'))
                          Column() {
                            Text(song.name)
                              .fontSize(16)
                              .fontColor($r('app.color.text_lv1'))
                              .lineHeight(24)
                            Row({ space: 8 }) {
                              if (song.fee === SongFee.vip) {
                                Tag({ text: 'VIP', type: 'primary' })
                              }
                              if (song.sq) {
                                Tag({ text: 'SQ', type: $r('app.color.orange') })
                              }
                              Text(song.ar.map(item => item.name).join('/'))
                                .fontSize(14)
                                .fontColor($r('app.color.text_lv1'))
                                .layoutWeight(1)
                                .maxLines(1)
                                .textOverflow({ overflow: TextOverflow.Ellipsis })
                            }
                          }.alignItems(HorizontalAlign.Start)
                          .layoutWeight(1)
                          Row({ space: 12 }) {
                            Image($r('app.media.square_play'))
                              .size({ width: 24, height: 24 })
                              .onClick(() => {
                                const params: PlayerRouteParams = { id: song.id };
                                this.stack?.pushPathByName("Player", params, false);
                              })
                            Image($r('app.media.more'))
                              .size({ width: 24, height: 24 })
                          }
                        }.padding({ top: 8, bottom: 8 })
                      }
                    })
                  }
                }
                .width('100%')
                .sticky(StickyStyle.Header)
                /* 安全距离 */
                SafeBottomArea()
              }
              .margin({ top: -64 })
              .padding({ left: 20, right: 20, top: 20 })
              .width('100%')
              .linearGradient({
                direction: GradientDirection.Bottom,
                colors: [[$r('app.color.white_30'), 0], [$r('app.color.white_50'), 0.3]]
              })
              .backdropBlur(10)
              .borderRadius(12)
            }
          }.onDidScroll(() => {
            const offsetRate = Math.min(parseFloat((this.scroller.currentOffset().yOffset / 300).toFixed(2)), 1);
            this.navHeaderOpacity = offsetRate;
          })
        }
        .width('100%')
        .height('auto')
        .backgroundImage($r('app.media.common_bg'))
        .backgroundImageSize({ width: '600%', height: '320%' })
        .backgroundImagePosition({ x: '-300%', y: '-130%' })
        .backgroundColor($r('app.color.bg_cyan'))
      } else {
        Loading()
      }
    }.hideTitleBar(true)
    .onReady((context) => {
      this.playlistId = (context.pathInfo.param as PlaylistRouteParams)?.id || 932176943;
      this.loadPlaylist();
    })
  }
}

@Builder
export function PlaylistBuilder() {
  Playlist();
}