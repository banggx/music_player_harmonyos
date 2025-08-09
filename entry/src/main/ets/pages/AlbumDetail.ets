import { Loading, SafeBottomArea, SafeTopArea } from "../components/common";
import { AlbumRouteParams, AlbumItem, SongItem, PlayerRouteParams } from "../model";
import { albumService } from "../service";
import { getImagePixelInfo } from '../utils/image';
import { hexToRGBA } from '../utils/color';
import { appStorageConnect, AppStorageModel } from '../storage/appStorage';
import dayjs from 'dayjs';
import { SongCell } from "../components/song/SongCell";
import { AlbumDescSheet } from "../components/album/AlbumDescSheet";
import { AlbumSingers } from '../components/album/AlbumSingers';
import { playerStore } from '../store';

@Entry
@ComponentV2
export struct AlbumDetail {
  @Consumer('stack') stack?: NavPathStack;
  @Local appStorage: AppStorageModel = appStorageConnect();
  uiContext = this.getUIContext();
  @Local safeTopArea: number = this.uiContext.px2vp(this.appStorage.safeTopArea);
  @Monitor('appStorage.safeTopArea')
  safeTopAreaChange() {
    this.safeTopArea = this.uiContext.px2vp(this.appStorage.safeTopArea);
  }

  @Local albumId: number = 0;
  @Local album: AlbumItem | null = null;
  @Local songs: SongItem[] = [];
  @Local bgColor: string = '#222628';
  @Local bgColorRgb: string[] = [];

  async loadAlbumInfo() {
    const res = await albumService.getAlbumInfo(this.albumId);
    if (res.code === 200) {
      this.album = res.album;
      this.songs = res.songs;
      this.bgColor = await getImagePixelInfo(this.album?.picUrl);
      this.bgColorRgb = hexToRGBA(this.bgColor).slice(0, 3);
    }
  }

  scroller = new Scroller();
  @Local navHeaderOpacity: number = 0;

  build() {
    NavDestination() {
      if (this.album) {
        Column() {
          Stack({ alignContent: Alignment.TopStart }) {
            Column() {
              SafeTopArea()
              Row({ space: 12 }) {
                Image($r('app.media.arrow_left'))
                  .size({ width: 28, height: 28 })
                  .fillColor($r('app.color.white'))
                Text('专辑')
                  .fontSize(18)
                  .fontColor($r('app.color.white'))
                  .fontWeight(500)
              }.height(56)
              .width('100%')
              .onClick(() => {
                this.stack?.pop();
              })
            }.padding({ left: 16, right: 16 })
            .width('100%')
            .zIndex(100)
            .backgroundColor(`rgba(${this.bgColorRgb.join(',')}, ${this.navHeaderOpacity})`)

            Scroll(this.scroller) {
              Column() {
                Row() {
                  Stack() {
                    Image($r('app.media.record_bg'))
                      .size({ width: 144, height: 144 })
                      .position({ top: -20 })
                    Image(this.album.picUrl)
                      .size({ width: 144, height: 144 })
                      .borderRadius(12)
                      .zIndex(100)
                  }

                  Column() {
                    Text(this.album.name)
                      .fontSize(18)
                      .fontWeight(500)
                      .fontColor($r('app.color.white'))
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                    AlbumSingers({ album: this.album }).width('100%')
                      .margin({ top: 16 })
                    Text('发行时间' + dayjs(this.album.publishTime).format('YYYY-MM-DD'))
                      .fontSize(14)
                      .fontColor($r('app.color.white_50'))
                      .margin({ top: 50 })
                    AlbumDescSheet({ album: this.album, bgColor: this.bgColor })
                      .margin({ top: 8 })
                  }.margin({ left: 24 })
                  .layoutWeight(1)
                  .alignItems(HorizontalAlign.Start)
                  .justifyContent(FlexAlign.Start)
                }
                .width('100%')
                .height('auto')
                .padding({
                  top: this.safeTopArea + 80,
                  left: 16,
                  right: 16,
                  bottom: 36
                })
                .backgroundColor(this.bgColor)
                .alignItems(VerticalAlign.Top)

                Column() {
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
                    }
                    .padding({
                      top: 8,
                      bottom: 8,
                      left: 12,
                      right: 12
                    })
                    .backgroundColor($r('app.color.sky_80'))
                  }.justifyContent(FlexAlign.Start)
                  .width('100%')

                  List({ space: 24 }) {
                    ForEach(this.songs, (song: SongItem) => {
                      ListItem() {
                        SongCell({ song })
                      }
                    })
                  }.margin({ top: 16 })
                }.margin({ top: 24 })
                .padding({ left: 16, right: 16 })

                SafeBottomArea()
              }
            }.onDidScroll(() => {
              const offsetRate = Math.min(parseFloat((this.scroller.currentOffset().yOffset / 200).toFixed(2)), 1);
              this.navHeaderOpacity = offsetRate;
            })
          }
        }
      } else {
        Loading()
      }
    }.hideTitleBar(true)
    .onReady((context) => {
      this.albumId = (context.pathInfo.param as AlbumRouteParams)?.id || 3159123;
      this.loadAlbumInfo();
    })
  }
}

@Builder
export function albumDetailBuilder() {
  AlbumDetail()
}