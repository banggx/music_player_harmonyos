import { SafeTopArea } from '../components/common/SafeTopArea';
import { SafeBottomArea } from '../components/common/SafeBottomArea';
import { dataStorage } from '../storage/dataStorage';
import { LengthMetrics } from '@kit.ArkUI';
import display from '@ohos.display';
import { HotSearch } from '../components/search/HotSearch';
import { SearchResult } from '../components/search/SearchResult';
import { SearchSuggest } from '../model';
import { searchService } from '../service';

const SearchHistoryKey = 'music_search_keys';

@Entry
@ComponentV2
export struct SearchPage {
  @Consumer('stack') stack?: NavPathStack;
  uiContext = this.getUIContext();
  @Local history: string[] = (dataStorage.get(SearchHistoryKey) as string[]) || [];
  @Local expandHistory: boolean = false;
  @Local lineCount: number = 3;

  /* 计算第一行折起的时候可以显示的最大个数 */
  /* TODO: 思考还有没有更优的方案，不通过计算来实现效果 */
  calcLineShowHistorySize() {
    let width = this.uiContext.px2vp(display.getDefaultDisplaySync().width);
    let count = 0;
    if (width) {
      width -= 68;
      for (; count < this.history.length; count++) {
        width -= 36 + this.history[count].length * 15;
        if (width < 0) {
          break;
        }
      }
    }
    if (!count) {
      count = 3;
    }
    this.lineCount = count;
  }
  aboutToAppear() {
    this.calcLineShowHistorySize();
  }

  @Local keyword: string = '';
  @Local searchSuggest: SearchSuggest[] = [];
  async getSearchSuggest() {
    if (!this.keyword) return;
    let currentKey = this.keyword;
    const res = await searchService.getSearchSuggest(currentKey);
    if (res.code === 200 && this.keyword === currentKey) {
      this.searchSuggest = res.result.allMatch;
    }
  }

  // 真正的搜索的Key
  @Local searchKey: string = '';
  execSearch(key?: string) {
    this.searchKey = key || this.keyword;
    this.searchSuggest = [];
    const historyIndex = this.history.indexOf(this.searchKey);
    if (historyIndex === -1) {
      this.history.unshift(this.searchKey);
    } else {
      this.history.splice(historyIndex, 1);
      this.history.unshift(this.searchKey);
    }
    dataStorage.set(SearchHistoryKey, this.history);
  }

  // 搜索历史清除
  @Local clearHistory: boolean = false;
  clearHistoryHandler(keys: string[]) {
    keys.forEach(key => {
      const index = this.history.indexOf(key);
      if (index !== -1) {
        this.history.splice(index, 1);
      }
    });
    dataStorage.set(SearchHistoryKey, this.history);
  }

  build() {
    NavDestination() {
      Column() {
        SafeTopArea()
        Stack({ alignContent: Alignment.Top }) {
          /* 搜索框 */
          Row({ space: 12 }) {
            Image($r('app.media.arrow_left'))
              .size({ width: 24, height: 24 })
              .fillColor($r('app.color.text_lv1'))
              .onClick(() => {
                this.stack?.pop();
              })
            Row() {
              Image($r('app.media.circle'))
                .size({ width: 20, height: 20 })
                .fillColor($r('app.color.text_lv2'))
              TextInput({ placeholder: '搜索内容', text: this.keyword  })
                .layoutWeight(1)
                .backgroundColor(Color.Transparent)
                .onChange((val: string) => {
                  this.keyword = val;
                  this.getSearchSuggest();
                })
                .onSubmit(() => {
                  this.execSearch();
                })
            }.layoutWeight(1)
            .backgroundColor($r('app.color.white'))
            .borderRadius(20)
            .padding({ left: 12 })
          }.padding({ left: 12, right: 16 })
          .height(64)
          .alignItems(VerticalAlign.Center)

          /* 搜索默认信息 */
          Scroll() {
            Column() {
              if (this.searchSuggest.length && this.keyword) {
                List({ space: 4 }) {
                  ForEach(this.searchSuggest, (item: SearchSuggest) => {
                    ListItem() {
                      Row({ space: 8 }) {
                        Image($r('app.media.search'))
                          .size({ width: 20, height: 20 })
                          .fillColor($r('app.color.text_lv2'))
                        Text(item.keyword)
                          .fontSize(16)
                          .fontColor($r('app.color.text_lv1'))
                          .fontWeight(500)
                          .maxLines(1)
                          .textOverflow({ overflow: TextOverflow.Ellipsis })
                      }.width('100%').onClick(() => {
                        this.execSearch(item.keyword);
                      })
                    }.padding({ top: 6, bottom: 6 })
                  })
                }.width('100%')
                .layoutWeight(1)
              } else if (this.searchKey) {
                SearchResult({ searchKey: this.searchKey })
                  .layoutWeight(1)
                  .width('100%')
              } else {
                /* 搜索历史 */
                if (this.history.length) {
                  Column() {
                    Row() {
                      Text('搜索历史')
                        .fontSize(18)
                        .fontColor($r('app.color.text_lv1'))
                        .fontWeight(500)
                      if (this.clearHistory) {
                        Row({ space: 24 }) {
                          Text('全部清除')
                            .fontSize(14)
                            .fontColor($r('app.color.text_lv1'))
                            .onClick(() => {
                              this.clearHistoryHandler(this.history);
                            })
                          Text('完成')
                            .fontSize(14)
                            .fontColor($r('app.color.purple'))
                            .onClick(() => {
                              this.clearHistory = false;
                            })
                        }
                      } else {
                        Image($r('app.media.delete'))
                          .size({ width: 20, height: 20 })
                          .onClick(() => {
                            this.clearHistory = true;
                          })
                      }
                    }.width('100%')
                    .justifyContent(FlexAlign.SpaceBetween)
                    Flex({
                      direction: FlexDirection.Row,
                      wrap: FlexWrap.Wrap,
                      space: { main: LengthMetrics.vp(12), cross: LengthMetrics.vp(8) },
                      alignItems: ItemAlign.Center
                    }) {
                      ForEach(this.expandHistory ? this.history : this.history.slice(0, this.lineCount), (item: string) => {
                        Row({ space: 4 }) {
                          Text(item)
                            .fontSize(15)
                            .lineHeight(20)
                            .fontColor($r('app.color.text_lv1'))
                            .maxLines(1)
                          if (this.clearHistory) {
                            Image($r('app.media.close'))
                              .size({ width: 16, height: 16 })
                              .onClick(() => {
                                this.clearHistoryHandler([item]);
                              })
                          }
                        }.padding({ top: 4, bottom: 4, left: 12, right: 12 })
                        .borderRadius(20)
                        .backgroundColor($r('app.color.white'))
                        .onClick(() => {
                          this.execSearch(item);
                        })
                      })
                      if (this.lineCount < this.history.length) {
                        Row() {
                          Image($r('app.media.arrow_down'))
                            .size({ width: 18, height: 18 })
                            .rotate({ angle: this.expandHistory ? 180 : 0 })
                            .onClick(() => {
                              this.expandHistory = !this.expandHistory;
                            })
                        }.width(28)
                        .height(28)
                        .alignItems(VerticalAlign.Center)
                        .justifyContent(FlexAlign.Center)
                        .backgroundColor($r('app.color.white'))
                        .borderRadius('50%')
                      }
                    }.margin({ top: 12 })
                    .width('100%')
                  }.margin({ bottom: 24 })
                }

                /* 热门搜索 */
                List() {
                  ListItem() {
                    HotSearch()
                  }
                }.listDirection(Axis.Horizontal)
                .alignListItem(ListItemAlign.Start)
                .layoutWeight(1)
              }
              SafeBottomArea()
            }.padding({ left: 20, right: 20 })
            .alignItems(HorizontalAlign.Start)
          }.width('100%')
          .height('calc(100% - 64vp)')
          .layoutWeight(1)
          .position({ top: 64 })
        }.layoutWeight(1)
      }.width('100%')
    }.hideTitleBar(true)
    .backgroundColor($r('app.color.sky_80'))
  }
}

@Builder
export function SearchPageBuilder() {
  SearchPage()
}