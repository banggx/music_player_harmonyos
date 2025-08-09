import { FormatLyricItem } from "../../model";
import { playerStore, PlayerStore } from '../../store';

@ComponentV2
export struct SongLyric {
  @Param lyric: Array<FormatLyricItem> = [];
  @Param lyricIndex: number = 0;

  lyricScroller = new Scroller();
  @Monitor('lyricIndex')
  scrollLyric() {
    this.lyricScroller.scrollToIndex(this.lyricIndex, true, ScrollAlign.CENTER);
  }

  @Local store: PlayerStore = playerStore;
  updateMusicSeek(index: number) {
    if (index < this.lyric.length) {
      const lyric = this.lyric[index];
      this.store.updateSeek(lyric.time);
    }
  }

  build() {
    List({ space: 16, scroller: this.lyricScroller }) {
      ForEach(this.lyric, (line: FormatLyricItem, index: number) => {
        ListItem() {
          Text(line.text)
            .fontSize(index === this.lyricIndex ? 18 : 14)
            .lineHeight(21)
            .fontColor(index === this.lyricIndex ? $r('app.color.text_lv1') : $r('app.color.text_lv2'))
            .textAlign(TextAlign.Center)
            .width('100%')
            .animation({
              duration: 200,
              curve: Curve.Ease,
            })
            .onClick(() => {
              this.updateMusicSeek(index);
            })
        }
      })
    }
  }
}