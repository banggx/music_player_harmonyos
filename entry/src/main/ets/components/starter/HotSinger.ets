import { commonService } from '../../service';
import { SingerItem } from '../../model/singer';
import { CardHeader } from '../common/CardHeader';
import { SingerRouteParams } from '../../model/router';

@ComponentV2
export struct HotSinger {
  @Local artists: SingerItem[] = [];
  @Consumer('stack') stack?: NavPathStack;

  async aboutToAppear() {
    const res = await commonService.getHotSinger();
    if (res.code === 200) {
      this.artists = res.artists;
    }
  }

  build() {
    Column() {
      CardHeader({ title: '热门歌手' })
      List({ space: 12 }) {
        ForEach(this.artists, (singer: SingerItem) => {
          ListItem() {
            Column() {
              Image(singer.picUrl)
                .size({ width: 52, height: 52 })
                .borderRadius('50%')
              Text(singer.name)
                .fontSize(13)
                .fontColor($r('app.color.text_lv2'))
                .margin({ top: 8 })
                .width('100%')
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .textAlign(TextAlign.Center)
                .maxLines(1)
            }.width(52)
          }.onClick(() => {
            const params: SingerRouteParams = { id: singer.id };
            this.stack?.pushPathByName("SingerDetail", params, false);
          })
        })
      }.listDirection(Axis.Horizontal)
      .scrollBar(BarState.Off)
      .margin({ top: 12 })
    }.width('100%')
  }
}
