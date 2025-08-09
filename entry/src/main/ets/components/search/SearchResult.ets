import { ComplexSearch } from './ComplexSearch';
import { SongResult } from './SongResult';
import { PlaylistResult } from './PlaylistResult';
import { AlbumResult } from './AlbumResult';
import { SingerResult } from './SingerResult';

@ComponentV2
export struct SearchResult {
  @Param @Require searchKey: string;
  @Local currentTab: number = 0;
  private tabController: TabsController = new TabsController();

  @Builder
  tabBuilder(name: string, index: number) {
    Column() {
      Text(name)
        .fontSize(15)
        .fontColor(index === this.currentTab ? $r('app.color.text_lv1') : $r('app.color.text_lv2'))
        .fontWeight(index === this.currentTab ? 500 : 400)
      Row()
        .width(32)
        .height(2)
        .backgroundColor(index === this.currentTab ? $r('app.color.purple') : Color.Transparent)
        .margin({ top: 2 })
    }
  }

  updateTab = (index: number) => {
    this.currentTab = index;
    this.tabController.changeIndex(index);
  }

  build() {
    Column() {
      Tabs({ index: this.currentTab, controller: this.tabController }) {
        TabContent(){
          ComplexSearch({ searchKey: this.searchKey, updateTab: this.updateTab })
        }.tabBar(this.tabBuilder('综合', 0))
        TabContent(){
          SongResult({ searchKey: this.searchKey })
        }.tabBar(this.tabBuilder('单曲', 1))
        TabContent(){
          PlaylistResult({ searchKey: this.searchKey })
        }.tabBar(this.tabBuilder('歌单', 2))
        TabContent(){
          AlbumResult({ searchKey: this.searchKey })
        }.tabBar(this.tabBuilder('专辑', 3))
        TabContent(){
          SingerResult({ searchKey: this.searchKey })
        }.tabBar(this.tabBuilder('歌手', 4))
        TabContent(){

        }.tabBar(this.tabBuilder('MV', 5))
      }.align(Alignment.Start)
      .layoutWeight(1)
      .onChange((index) => {
        this.currentTab = index;
      })
    }
  }
}