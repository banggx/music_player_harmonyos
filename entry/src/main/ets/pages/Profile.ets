import { SafeBottomArea, SafeTopArea } from '../components/common';
import { userService } from '../service';

@ComponentV2
export struct Profile {
  @Consumer('stack') stack?: NavPathStack;
  @Local user: null = null;

  async aboutToAppear() {
    const res = await userService.getLoginStatus();
    if (res.code === 200 && res.profile) {
      this.user = res.profile;
    }
  }

  async routeToLogin() {
    this.stack?.pushPathByName('PhoneLogin', null, true);
  }

  build() {
    Column() {
      SafeTopArea()
      Scroll() {
        Column() {
          if (!this.user) {
            Column() {
              Row() {
                Text('登录').textAlign(TextAlign.Center)
                  .fontSize(18)
                  .fontWeight(600)
                  .fontColor($r('app.color.text_lv2'))
                  .width('100%')
              }.borderRadius('50%')
              .width(64)
              .height(64)
              .backgroundColor($r('app.color.black_10'))
              .border({ width: 2, color: $r('app.color.white'), style: BorderStyle.Solid })
              .onClick(() => {
                this.routeToLogin();
              })
            }
          }
        }.justifyContent(FlexAlign.Start)
        .width('100%')
        .height('100%')
      }.layoutWeight(1)
      .padding({ top: 32 })
      SafeBottomArea()
    }.width('100%')
    .height('100%')
    .backgroundImage($r('app.media.common_bg'))
    .backgroundImageSize({ width: '600%', height: '320%' })
    .backgroundImagePosition({ x: '-300%', y: '-130%' })
    .backgroundColor($r('app.color.bg_cyan'))
  }
}