import { SingerRouteParams } from '../model/router';
import { singerService } from '../service';
import { SingerDetailInfo, SongItem, PlayerRouteParams } from '../model';
import { appStorageConnect, AppStorageModel } from '../storage/appStorage';
import { SongFee } from '../constants';
import { playerStore } from '../store';
import { Loading, LoadMore, Tag } from '../components/common';

@Entry
@ComponentV2
struct SingerDetail {
  @Consumer('stack') stack?: NavPathStack;
  @Local appStorage: AppStorageModel = appStorageConnect();
  uiContext = this.getUIContext();
  @Local safeTopHeight: number = this.uiContext.px2vp(this.appStorage.safeTopArea);
  @Local safeBottomHeight: number = this.uiContext.px2vp(this.appStorage.safeBottomArea);
  @Local singerId: number = 0;
  @Local singerInfo: SingerDetailInfo | null = null;
  @Local totalSongs: number = 0;
  @Local songs: SongItem[] = [];
  @Local page: number = 0;
  @Local isLoading: boolean = false;

  @Monitor('appStorage.safeTopArea')
  safeTopAreaChange() {
    this.safeTopHeight = this.uiContext.px2vp(this.appStorage.safeTopArea);
  }

  @Monitor('appStorage.safeBottomArea')
  safeBottomAreaChange() {
    this.safeBottomHeight = this.uiContext.px2vp(this.appStorage.safeBottomArea);
  }

  async loadSingerInfo() {
    const res = await singerService.getSingerDetail(this.singerId);
    if (res.code === 200 && res.data) {
      this.singerInfo = res.data;
    }
  }

  async loadSingerSongs(refresh: boolean = false) {
    this.isLoading = true;
    const res = await singerService.getSingerSongs(this.singerId, this.page);
    if (res.code === 200 && res.songs) {
      this.totalSongs = res.total;
      if (refresh) {
        this.songs = res.songs;
      } else {
        this.songs.push(...res.songs);
      }
      this.page++;
    }
    this.isLoading = false;
  }

  build() {
    NavDestination() {
      if (this.singerInfo) {
        Stack() {
          Image(this.singerInfo.artist.cover)
            .width('100%')
            .height(290)
          Image($r("app.media.arrow_left"))
            .size({ width: 32, height: 32 })
            .position({ top: this.safeTopHeight + 12, left: 16 })
            .onClick(() => {
              this.stack?.pop()
            })
          Row() {
            Image($r('app.media.more'))
              .size({ width: 24, height: 24 })
              .fillColor($r('app.color.white_80'))
          }.size({ width: 32, height: 32 })
          .backgroundColor($r('app.color.white_50'))
          .borderRadius('50%')
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .position({ top: this.safeTopHeight + 12, right: 16 })
        }
        Column() {
          Row() {
            Column() {
              Text(this.singerInfo.artist.name)
                .fontSize(24)
                .fontWeight(500)
                .fontColor($r('app.color.text_lv1'))
              Row({ space: 16 }) {
                Text('歌曲 ' + this.singerInfo.artist.musicSize)
                  .fontSize(12)
                  .fontColor($r('app.color.text_lv2'))
                Text('专辑 ' + this.singerInfo.artist.albumSize)
                  .fontSize(14)
                  .fontColor($r('app.color.text_lv2'))
              }.margin({ top: 8 })
            }.alignItems(HorizontalAlign.Start)
            Button() {
              Row() {
                Image($r('app.media.plus'))
                  .size({ width: 18, height: 18 })
                Text('关注')
                  .fontColor($r('app.color.white_80'))
                  .fontSize(14)
                  .lineHeight(22)
              }.alignItems(VerticalAlign.Center)
            }.backgroundColor($r('app.color.text_lv1'))
            .padding({ top: 5, bottom: 5, left: 14, right: 14 })
          }.justifyContent(FlexAlign.SpaceBetween)
          .width('100%')
          .padding({ top: 20, left: 20, right: 20 })
          Divider()
            .color($r('app.color.black_10'))
            .margin({ top: 16, bottom: 16 })
          Column() {
            /* 单曲header */
            Column() {
              Row() {
                Text('单曲(' + this.singerInfo.artist.musicSize + ")")
                  .fontSize(18)
                  .fontColor($r('app.color.text_lv1'))
                  .fontWeight(500)
              }
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
            }.padding({ left: 20, right: 20 })
            .alignItems(HorizontalAlign.Start)

            // 这里设置一个固定的height之后再设置flexGrow才能生效撑满Column
            /* 单曲列表 */
            List() {
              ForEach(this.songs, (song: SongItem) => {
                ListItem() {
                  Row({ space: 20 }) {
                    Column() {
                      Text(song.name)
                        .fontSize(16)
                        .fontColor($r('app.color.text_lv1'))
                      Row({ space: 8 }) {
                        if (song.fee === SongFee.vip) {
                          Tag({ text: 'VIP', type: 'primary' })
                        }
                        if (song.sq) {
                          Tag({ text: 'SQ', type: $r('app.color.orange') })
                        }
                        Text(song.ar.map(item => item.name).join('/'))
                          .fontSize(14)
                          .maxLines(1)
                          .layoutWeight(1)
                          .wordBreak(WordBreak.BREAK_ALL)
                          .textOverflow({ overflow: TextOverflow.Ellipsis })
                          .fontColor($r('app.color.text_lv2'))
                      }.margin({ top: 4 })
                    }.alignItems(HorizontalAlign.Start)
                    .layoutWeight(1)

                    Image($r('app.media.square_play'))
                      .size({ width: 24, height: 24 })
                      .fillColor($r('app.color.text_lv1'))
                      .onClick(() => {
                        const params: PlayerRouteParams = { id: song.id };
                        this.stack?.pushPathByName("Player", params, false);
                      })
                    Image($r('app.media.more'))
                      .size({ width: 24, height: 24 })
                      .fillColor($r('app.color.text_lv1'))
                  }.padding({ top: 8, bottom: 8, left: 20, right: 20 })
                  .width('100%')
                }
              })
              ListItem() {
                LoadMore({ loading: this.isLoading })
              }
            }.height(100).flexGrow(1)
            .margin({ top: 16 })
            .onScrollIndex((_: number, end: number) => {
              if (end >= this.songs.length - 1 && this.songs.length < this.totalSongs) {
                this.loadSingerSongs();
              }
            })
          }.width('100%')
          .flexGrow(1)
          .alignItems(HorizontalAlign.Start)
          .padding({ bottom: this.safeBottomHeight })
        }
        .borderRadius({ topLeft: 20, topRight: 20 })
        .width('100%')
        .flexGrow(1)
        .margin({ top: -40 })
        .backgroundImage($r('app.media.detail_bg'))
        .backgroundImageSize({ width: '600%', height: '320%' })
        .backgroundImagePosition({ x: '-250%', y: '-130%' })
        .backgroundColor($r('app.color.bg_cyan'))
      } else {
        Loading()
      }
    }.hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.singerId = (context.pathInfo.param as SingerRouteParams)?.id || 2116;
      this.loadSingerInfo();
      this.loadSingerSongs();
    })
  }
}

@Builder
export function SingerDetailBuilder() {
  SingerDetail();
}