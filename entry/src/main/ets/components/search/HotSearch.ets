import { HotSearchInfo } from '../../model/search';
import { searchService } from '../../service';
import { formatNumber } from '../../utils/tools';

@ComponentV2
export struct HotSearch {
  @Local hots: HotSearchInfo[] = [];
  @Local topColors: Resource[] = [$r('app.color.red'), $r('app.color.orange'), $r('app.color.yellow')]

  async aboutToAppear() {
    const res = await searchService.getSearchHotSong();
    if (res.code === 200) {
      this.hots = res.data;
    }
  }

  build() {
    Column() {
      Text('热门搜索')
        .fontSize(18)
        .fontColor($r('app.color.text_lv1'))
        .fontWeight(500)
      List() {
        ForEach(this.hots, (hot: HotSearchInfo, index) => {
          ListItem() {
            Row({ space: 8 }) {
              Text((index + 1).toString())
                .fontSize(18)
                .fontWeight(500)
                .fontColor(this.topColors[index] ? this.topColors[index] : $r('app.color.text_lv2'))
              Text(hot.searchWord)
                .fontSize(16)
                .fontColor($r('app.color.text_lv1'))
                .layoutWeight(1)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
              Row({ space: 4 }) {
                Image($r('app.media.fire'))
                  .size({ width: 20, height: 20 })
                  .fillColor(this.topColors[index] ? this.topColors[index] : $r('app.color.text_lv2'))
                Text(formatNumber(hot.score))
                  .fontSize(14)
                  .fontColor($r('app.color.orange'))
              }
            }
          }.padding({ top: 8, bottom: 8 })
        })
      }.margin({ top: 16 })
    }.width('100%')
    .padding(16)
    .backgroundColor($r('app.color.white'))
    .borderRadius(12)
    .alignItems(HorizontalAlign.Start)
  }
}