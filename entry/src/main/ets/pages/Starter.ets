import { appStorageConnect, AppStorageModel } from '../storage/appStorage';
import { commonService } from '../service';
import { PrivateContent } from '../model/common';
import { HotSinger } from '../components/starter/HotSinger';
import { HotPlaylist } from '../components/starter/HotPlaylist';
import { RecommendSong } from '../components/starter/RecommendSong';

interface MenuItem {
  name: string;
  icon: Resource;
}

@ComponentV2
export struct Starter {
  @Consumer('stack') stack?: NavPathStack;
  @Local appStorage: AppStorageModel = appStorageConnect();
  uiContext = this.getUIContext();
  @Local safeTopHeight: number = this.uiContext.px2vp(this.appStorage.safeTopArea);
  @Local privateContents: PrivateContent[] = [];
  @Local menus: MenuItem[] = [
    { name: '每日推荐', icon: $r('app.media.calendar') },
    { name: '排行榜', icon: $r('app.media.music') },
    { name: '分类', icon: $r('app.media.category') },
    { name: '歌手', icon: $r('app.media.users') },
  ];

  @Monitor('appStorage.safeTopArea')
  safeTopAreaChange() {
    this.safeTopHeight = this.uiContext.px2vp(this.appStorage.safeTopArea);
  }

  async loadPrivateContent() {
    const res = await commonService.getPrivateContent();
    if (res.code === 200) {
      this.privateContents = res.result;
    }
  }

  aboutToAppear(): void {
    this.loadPrivateContent();
  }

  build() {
    Scroll(){
      Column() {
        Row({ space: 8 }) {
          Row({ space: 12 }) {
            Image($r('app.media.circle'))
              .size({ width: 16, height: 16 })
              .fillColor($r('app.color.text_lv1'))
            Text('搜索音乐')
              .fontSize(14)
              .fontColor($r('app.color.text_lv2'))
          }.backgroundColor($r('app.color.white_50'))
          .padding({ left: 12, right: 12, top: 8, bottom: 8 })
          .borderRadius('50%')
          .layoutWeight(1)
          .alignItems(VerticalAlign.Center)
          .onClick(() => {
            this.stack?.pushPathByName('Search', null, true);
          })

          Image($r('app.media.notification'))
            .size({ width: 32, height: 32 })
            .padding(4)
        }.width('100%')
        .alignItems(VerticalAlign.Center)

        /* 轮播 */
        Swiper() {
          ForEach(this.privateContents, (item: PrivateContent) => {
            Image(item.picUrl)
          })
        }.margin({ top: 16 })
        .width('100%')
        .height(150)
        .borderRadius(8)
        .indicator(false)
        .autoPlay(true)
        .interval(3000)

        /* 菜单 */
        GridRow({ columns: 4 }) {
          ForEach(this.menus, (menu: MenuItem) => {
            GridCol({ span: 1 }) {
              Column() {
                Image(menu.icon)
                  .size({ width: 32, height: 32 })
                Text(menu.name)
                  .fontSize(13)
                  .fontColor($r('app.color.text_lv2'))
                  .margin({ top: 8 })
              }
            }
          })
        }.width('100%')
        .margin({ top: 16 })

        HotSinger().width('100%').margin({ top: 24 })

        HotPlaylist().width('100%').margin({ top: 24 })

        RecommendSong().width('100%').margin({ top: 24 })
      }.backgroundImage($r('app.media.starter_bg'))
      .backgroundImageSize({ width: '600%', height: '240%' })
      .backgroundImagePosition({ x: '-200%', y: '-64%' })
      .backgroundColor('rgba(197, 233, 255, 0.2)')
      .padding({ top: this.safeTopHeight + 12, bottom: 24, left: 20, right: 20 })
      .justifyContent(FlexAlign.Start)
    }.width('100%')
    .height('100%')
  }
}