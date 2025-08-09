import { SingerItem, SingerSearchRes } from "../../model";
import { searchService } from "../../service";
import { SearchType } from '../../constants';
import { SingerCell } from "../singer/SingerCell";
import { LoadMore } from '../common/LoadMore'

@ComponentV2
export struct SingerResult {
  @Param @Require searchKey: string;
  @Local singers: SingerItem[] = [];
  @Local count: number = 0;
  @Local loading: boolean = false;

  async searchSinger() {
    this.loading = true;
    const offset = this.singers.length;
    const res = await searchService.search<SingerSearchRes>(this.searchKey, SearchType.singer, 30, offset);
    if (res.code === 200) {
      this.singers.push(...res.result.artists);
      this.count = res.result.artistCount;
    }
    this.loading = false;
  }

  async aboutToAppear() {
    this.searchSinger();
  }

  build() {
    Column() {
      List({ space: 24 }) {
        ForEach(this.singers, (singer: SingerItem) => {
          ListItem() {
            SingerCell({ singer })
          }
        })
        ListItem() {
          LoadMore({ loading: this.loading })
        }
      }
      .layoutWeight(1)
      .onScrollIndex((_: number, end: number) => {
        if (end >= this.singers.length - 1 && this.singers.length < this.count) {
          this.searchSinger();
        }
      })
    }.width('100%')
    .height('100%')
  }
}