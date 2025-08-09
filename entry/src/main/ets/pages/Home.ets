import { Starter } from './Starter';
import { Profile } from './Profile';
import { appStorageConnect, AppStorageModel } from '../storage/appStorage';

@ComponentV2
export struct HomePage {
  @Local appStorage: AppStorageModel = appStorageConnect();
  uiContext = this.getUIContext();
  @Local safeBottomArea: number = this.uiContext.px2vp(this.appStorage.safeBottomArea);
  @Local currentIndex: number = 0;

  @Monitor('appStorage.safeBottomArea')
  safeTopAreaChange() {
    this.safeBottomArea = this.uiContext.px2vp(this.appStorage.safeBottomArea);
  }

  @Builder tabBuilder(text: string, icon: Resource, index: number) {
    Column() {
      Image(icon)
        .size({ width: 24, height: 24 })
        .fillColor(index === this.currentIndex ? $r('app.color.purple') : $r('app.color.text_lv1'))
      Text(text)
        .margin({ top: 6 })
        .fontSize(14)
        .fontWeight(index === this.currentIndex ? 500 : 400)
        .fontColor(index === this.currentIndex ? $r('app.color.purple') : $r('app.color.text_lv1'))
    }.padding({ top: 12 })
  }

  build() {
    Tabs({ barPosition: BarPosition.End }) {
      TabContent() {
        Starter()
      }.tabBar(this.tabBuilder("音乐", $r("app.media.starter"), 0))
      TabContent() {
        Text('发现页')
      }.tabBar(this.tabBuilder("发现", $r("app.media.find"), 1))
      TabContent() {
        Profile()
      }.tabBar(this.tabBuilder("我的", $r("app.media.profile"), 2))
    }.divider({ color: $r('app.color.cyan'), strokeWidth: 1 })
    .backgroundColor($r('app.color.bg_cyan'))
    .scrollable(false)
    .barHeight('auto')
    .padding({ bottom: this.safeBottomArea })
    .onChange((index) => {
      this.currentIndex = index;
    })
  }
}