import { AnimatorResult } from '@kit.ArkUI';
import { SongItem, FormatLyricItem } from "../../model";
import { playerStore, PlayerStore } from '../../store';
import { PlayMode } from '../../constants';
import { formatMusicDT } from '../../utils/tools';
import { PlayListSheet } from './PlayListSheet';

@ComponentV2
export struct SongPlay {
  @Param songInfo: SongItem | null = null;
  @Param lyric: Array<FormatLyricItem> = [];
  @Param lyricIndex: number = 0;
  @Local coverRotate: number = 0;
  @Event onPlay: (id: number) => void;
  uiContext = this.getUIContext();

  @Local store: PlayerStore = playerStore;
  coverAnimator: AnimatorResult = this.uiContext.createAnimator({
    duration: 6000,
    easing: 'linear',
    delay: 0,
    fill: 'forwards',
    direction: 'normal',
    iterations: -1,
    begin: 0,
    end: 360
  });
  @Local currentStep: number = 0;
  @Monitor('store.musicPlayer.currentTime')
  updateCurrentStepAndLyric() {
    if (!this.songInfo) return;
    this.currentStep = Math.floor((this.store.musicPlayer.currentTime / this.songInfo.dt) * 100);
  }
  @Monitor('store.musicPlayer.state')
  updateMusicCoverAnimation() {
    if (this.store.musicPlayer.state === 'playing') {
      this.coverAnimator.onFrame = (rotate) => {
        this.coverRotate = rotate;
      };
      this.coverAnimator.play();
    } else {
      this.coverAnimator.pause();
    }
  }

  updateMusicSeek(val: number) {
    if (this.songInfo) {
      const ms = Math.floor(this.songInfo.dt * val / 100);
      this.store.updateSeek(ms);
    }
  }

  @Local
  voicePopup: boolean = false;
  @Builder
  voiceBuilder() {
    Column() {
      Slider({ value: this.store.musicPlayer.volume, direction: Axis.Vertical })
        .trackColor($r('app.color.white_50'))
        .blockColor($r('app.color.white'))
        .selectedColor($r('app.color.white'))
        .rotate({ angle: 180 })
        .onChange((val: number) => {
          this.store.musicPlayer.updateVolume(val);
        })
    }.padding({ top: 16, bottom: 16, left: 12, right: 12 })
    .height(200)
  }

  @Builder
  musicMenuBuilder() {
    Image($r('app.media.music_menu'))
      .size({ width: 24, height: 24 })
  }

  build() {
    if (this.songInfo) {
      Column() {
        Column() {
          Image(this.songInfo.al.picUrl)
            .width('80%')
            .aspectRatio(1)
            .borderRadius('50%')
            .rotate({ angle: this.coverRotate, centerX: '50%', centerY: '50%' })
        }.width('100%')
        .alignItems(HorizontalAlign.Center)
        Text(this.songInfo.name)
          .fontSize(24)
          .fontColor($r('app.color.text_lv1'))
          .fontWeight(600)
          .margin({ top: 24 })
        Text(this.songInfo.ar.map(item => item.name).join('/'))
          .fontSize(14)
          .fontColor($r('app.color.text_lv2'))
          .lineHeight(24)
          .margin({ top: 6 })
        if (this.lyric.length) {
          Text(this.lyric[this.lyricIndex].text)
            .fontSize(14)
            .fontColor($r('app.color.text_lv1'))
            .lineHeight(24)
            .margin({ top: 16 })
        }

        // 功能区
        Column() {
          Row() {
            Column() {
              Image($r('app.media.heart'))
                .size({ width: 24, height: 24 })
            }.justifyContent(FlexAlign.Center)
            .layoutWeight(1)

            Column() {
              Image($r('app.media.sliders'))
                .size({ width: 24, height: 24 })
            }.justifyContent(FlexAlign.Center)
            .layoutWeight(1)
            .bindPopup(this.voicePopup, {
              builder: this.voiceBuilder,
              placement: Placement.Top,
              popupColor: $r('app.color.purple'),
              onStateChange: (e) => {
                if (!e.isVisible) {
                  this.voicePopup = e.isVisible;
                }
              }
            })
            .onClick(() => {
              this.voicePopup = true;
            })

            Column() {
              Image($r('app.media.download'))
                .size({ width: 24, height: 24 })
            }.justifyContent(FlexAlign.Center)
            .layoutWeight(1)

            Column() {
              Image($r('app.media.comments'))
                .size({ width: 24, height: 24 })
            }.width('100%').justifyContent(FlexAlign.Center)
            .layoutWeight(1)
            Column() {
              Image($r('app.media.ellipse'))
                .size({ width: 24, height: 24 })
            }.justifyContent(FlexAlign.Center)
            .layoutWeight(1)
          }.width('100%')

          // 播放进度条
          Column() {
            Slider({ value: this.currentStep })
              .trackColor($r('app.color.white_50'))
              .blockColor($r('app.color.white'))
              .selectedColor($r('app.color.white'))
              .onChange((val: number) => {
                this.updateMusicSeek(val);
              })
            Row() {
              Text(formatMusicDT(this.store.musicPlayer.currentTime))
                .fontSize(14)
                .fontColor($r('app.color.text_lv2'))
                .lineHeight(16)
              Text(formatMusicDT(this.songInfo.dt))
                .fontSize(14)
                .fontColor($r('app.color.text_lv2'))
                .lineHeight(16)
            }.justifyContent(FlexAlign.SpaceBetween)
            .width('100%')

            // 播发区域
            Row() {
              if (this.store.playMode === PlayMode.linear) {
                Image($r("app.media.linear_play"))
                  .size({ width: 24, height: 24 })
                  .onClick(() => {
                    this.store.updatePlayMode(PlayMode.random);
                  })
              } else if (this.store.playMode === PlayMode.random) {
                Image($r("app.media.random_play"))
                  .size({ width: 24, height: 24 })
                  .onClick(() => {
                    this.store.updatePlayMode(PlayMode.circle);
                  })
              } else {
                Image($r("app.media.cycle_play"))
                  .size({ width: 24, height: 24 })
                  .onClick(() => {
                    this.store.updatePlayMode(PlayMode.linear);
                  })
              }
              Row({ space: 24 }) {
                Image($r('app.media.prev'))
                  .size({ width: 32, height: 32 })
                  .onClick(() => {
                    const prevId = this.store.getPrevSong();
                    if (prevId) {
                      this.onPlay(prevId);
                    }
                  })
                Image(this.store.musicPlayer.state === 'playing' ? $r('app.media.pause') : $r('app.media.circle_play'))
                  .size({ width: 64, height: 64 })
                  .onClick(() => {
                    if (this.store.musicPlayer.state === 'playing') {
                      this.store.musicPlayer.pause();
                      this.coverAnimator.pause();
                    } else {
                      this.store.musicPlayer.play();
                      this.coverAnimator.play();
                    }
                  })
                Image($r('app.media.next'))
                  .size({ width: 32, height: 32 })
                  .onClick(() => {
                    const nextId = this.store.getNextSong();
                    if (nextId) {
                      this.onPlay(nextId);
                    }
                  })
              }
              PlayListSheet({
                builder: this.musicMenuBuilder
              })
            }.width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .margin({ top: 24 })
          }.margin({ top: 24 })
        }.width('100%')
        .justifyContent(FlexAlign.End)
        .layoutWeight(1)
      }.justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      .width('100%')
      .height('100%')
      .padding({ top: 24, bottom: 24 })
    }
  }
}