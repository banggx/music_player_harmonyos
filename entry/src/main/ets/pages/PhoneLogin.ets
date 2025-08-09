import { SafeBottomArea, SafeTopArea } from "../components/common"
import { userService } from '../service';

@Entry
@ComponentV2
export struct PhoneLogin {
  @Consumer('stack') stack?: NavPathStack;
  @Local phone: string = '';
  @Local captchaCode: string = '';
  @Local captchaTime: number = 0;
  private captchaTimer: number | null = null;
  private uiContext = this.getUIContext();
  private promptAction = this.uiContext.getPromptAction()
  @Local checkProtocol: boolean = false;

  async sendToCaptcha() {
    if (!this.phone) {
      this.promptAction.showToast({
        message: '请输入手机号后继续',
        duration: 2000
      });
      return;
    }
    const res = await userService.sendCaptcha(this.phone);
    if (res.code === 200) {
      this.captchaTime = 60;
      this.captchaTimer = setInterval(() => {
        this.captchaTime--;
        if (this.captchaTime <= 0) {
          clearInterval(this.captchaTimer);
        }
      }, 1000)
    }
  }

  async phoneLogin() {
    if (!this.checkProtocol) {
      this.promptAction.showToast({
        message: '请先勾选同意《用户许可协议》和《隐私保护指引》后继续',
        duration: 2000
      });
      return;
    }
    if (!this.captchaCode || !this.phone) {
      this.promptAction.showToast({
        message: '请输入手机号和验证码',
        duration: 2000,
      });
      return;
    }
    try {
      const res = await userService.phoneLogin(this.phone, this.captchaCode);
      console.log(JSON.stringify(res), '====');
      if (res.code === 200) {
        this.stack?.pop();
      }
    } catch(err) {
      let message: string;
      if (err.code === 'ERR_BAD_REQUEST') {
        message = '手机号未注册';
      } else {
        message = '验证码错误'
      }
      this.promptAction.showToast({
        message,
        duration: 2000,
        textColor: $r('app.color.white'),
        backgroundColor: $r('app.color.red'),
        backgroundBlurStyle: BlurStyle.NONE
      });
    }
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.TopStart }) {
        Image($r('app.media.login_form_bg'))
          .size({ width: '100%', height: '100%' })
        Column() {
          SafeTopArea()
          Row() {
            Image($r('app.media.arrow_left'))
              .size({ width: 32, height: 32 })
              .fillColor($r('app.color.text_lv1'))
              .onClick(() => {
                this.stack?.pop();
              })
          }.width('100%')
          .height(54)
          .padding({ left: 32 })
          .justifyContent(FlexAlign.Start)
          Column() {
            Text('登录后更精彩')
              .fontSize(28)
              .fontColor($r('app.color.text_lv1'))
            Text('未注册的手机号验证通过后自动完成注册')
              .fontSize(15)
              .fontColor($r('app.color.text_lv2'))
              .margin({ top: 8 })

            Column({ space: 24 }) {
              TextInput({ text: this.phone, placeholder: '请输入手机号码' })
                .width('100%')
                .height(54)
                .borderRadius(30)
                .backgroundColor($r('app.color.white_80'))
                .border({ width: 1, color: $r('app.color.black_10') })
                .padding({ left: 24, right: 24 })
                .onChange((val) => {
                  this.phone = val;
                })

              Row() {
                TextInput({ text: this.captchaCode, placeholder: '输入手机验证码' })
                  .height(54)
                  .borderRadius({ topLeft: 30, bottomLeft: 30, topRight: 0, bottomRight: 0 })
                  .backgroundColor($r('app.color.white_80'))
                  .border({ width: 1, color: $r('app.color.black_10') })
                  .padding({ left: 24, right: 24 })
                  .layoutWeight(1)
                  .onChange((val) => {
                    this.captchaCode = val;
                  })
                Button() {
                  Text(this.captchaTime ? `${this.captchaTime}秒后重试` : '获取验证码')
                    .fontSize(18)
                    .fontColor($r('app.color.white'))
                }.height(54)
                .padding({ left: 24, right: 24 })
                .border({ width: 1, color: $r('app.color.black_10') })
                .borderRadius({ topLeft: 0, bottomLeft: 0, topRight: 30, bottomRight: 30 })
                .backgroundColor($r('app.color.blue_light'))
                .onClick(() => {
                  if (this.captchaTime <= 0) {
                    this.sendToCaptcha();
                  }
                })
              }

              Button() {
                Row({ space: 8 }) {
                  Image($r('app.media.phone'))
                    .size({ width: 26, height: 26 })
                  Text('立即登录')
                    .fontSize(17)
                    .fontColor($r('app.color.white'))
                }
              }.height(54)
              .width('100%')
              .borderRadius(30)
              .backgroundColor($r('app.color.green_light'))
              .onClick(() => {
                this.phoneLogin();
              })

              Row() {
                Checkbox().shape(CheckBoxShape.ROUNDED_SQUARE)
                  .select($$this.checkProtocol)
                  .selectedColor($r('app.color.blue_light'))
                Text('同意《用户许可协议》和《隐私保护指引》')
                  .fontSize(14)
                  .fontColor($r('app.color.text_lv2'))
              }
            }.margin({ top: 64 })
          }.padding({ top: 24, left: 32, right: 32 })
          .width('100%')
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Start)

          Row({ space: 32 }) {
            Image($r('app.media.weixin'))
              .size({ width: 48, height: 48 })
            Image($r('app.media.douyin'))
              .size({ width: 48, height: 48 })
          }.margin({ bottom: 32 })
          SafeBottomArea()
        }
      }
    }.hideTitleBar(true)
  }
}

@Builder
export function phoneLoginBuilder() {
  PhoneLogin();
}