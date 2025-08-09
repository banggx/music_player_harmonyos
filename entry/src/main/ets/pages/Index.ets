import { HomePage } from './Home';
import { PlayerCard } from '../components/common/PlayerCard';

@Entry
@ComponentV2
struct Index {
  @Provider('stack') stack: NavPathStack = new NavPathStack();

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Navigation(this.stack) {
        HomePage()
      }.width('100%')
      .height('100%')
      .hideToolBar(true)
      .mode(NavigationMode.Stack)

      // 播放器卡片
      PlayerCard()
    }
  }
}