import { SongFee } from "../../constants";
import { playerStore, PlayerStore } from "../../store"
import { appStorageConnect, AppStorageModel } from '../../storage/appStorage';
import { PlayListSheet } from '../player/PlayListSheet';

@ComponentV2
export struct PlayerCard {
  @Consumer('stack') stack?: NavPathStack;
  @Local playerStore: PlayerStore = playerStore;
  @Local appStorage: AppStorageModel = appStorageConnect();
  uiContext = this.getUIContext();
  @Local safeBottomArea: number = this.uiContext.px2vp(this.appStorage.safeBottomArea);
  @Monitor('appStorage.safeBottomArea')
  safeTopAreaChange() {
    this.safeBottomArea = this.uiContext.px2vp(this.appStorage.safeBottomArea);
  }
  @Local bottomPosition: number = this.getPlayerCardPosition();
  @Local visible: boolean = true;

  getPlayerCardPosition() {
    return this.stack && this.stack.size() > 0 ? this.safeBottomArea : this.safeBottomArea + 64;
  }
  aboutToAppear(): void {
    this.stack?.setInterception({
      willShow: (_, to) => {
        this.bottomPosition = this.getPlayerCardPosition();
        if (typeof to === 'object' && ['Player', 'PhoneLogin'].includes(to.pathInfo.name)) {
          this.visible = false;
        } else {
          this.visible = true;
        }
      }
    });
  }

  @Builder
  playMenuBuilder() {
    Image($r('app.media.music_menu'))
      .size({ width: 24, height: 24 })
  }

  build() {
    if (this.playerStore.current && this.visible) {
      Row({ space: 12 }) {
        Image(this.playerStore.current.song.al.picUrl)
          .size({ width: 56, height: 56 })
          .borderRadius({ topLeft: 8, bottomLeft: 8 })
        Row({ space: 8 }) {
          Text(this.playerStore.current.song.name
            + ' - '
            + this.playerStore.current.song.ar.map(item => item.name).join('/')
          ).fontSize(15)
            .fontColor($r('app.color.text_lv1'))
            .textOverflow({ overflow: TextOverflow.MARQUEE })
            .layoutWeight(1)
            .linearGradient({
              direction: GradientDirection.Left,
              colors: [[$r('app.color.sky_80'), 0], [$r('app.color.sky_80'), 1]]
            })
          if (this.playerStore.current.song.fee === SongFee.vip) {
            Row() {
              Text('VIP').fontSize(12).fontColor($r('app.color.purple'))
            }.border({ width: 1, color: $r('app.color.purple'), style: BorderStyle.Solid })
            .borderRadius(4)
            .padding({ top: 1, bottom: 1, left: 2, right: 2 })
          }
          Row({ space: 8 }) {
            if (this.playerStore.musicPlayer.state === 'playing') {
              Image($r('app.media.pause_outlined'))
                .size({ width: 24, height: 24 })
                .onClick(() => {
                  this.playerStore.musicPlayer.pause();
                })
            } else {
              Image($r('app.media.play_outlined'))
                .size({ width: 24, height: 24 })
                .onClick(() => {
                  this.playerStore.musicPlayer.play();
                })
            }
            PlayListSheet({
              builder: this.playMenuBuilder
            })
          }.margin({ left: 8 })
        }.padding({ right: 16 })
        .layoutWeight(1)
      }.position({ bottom: this.bottomPosition, left: 20, right: 20 })
      .borderRadius({ topRight: 40, bottomRight: 40 })
      .width('calc(100% - 40vp)')
      .backgroundColor($r('app.color.sky_80'))
      .onClick(() => {
        this.stack?.pushPathByName("Player", null, false);
      })
    }
  }
}