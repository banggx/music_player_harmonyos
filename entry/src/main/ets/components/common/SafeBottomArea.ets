import { appStorageConnect, AppStorageModel } from '../../storage/appStorage';
import { playerStore } from '../../store';

@ComponentV2
export struct SafeBottomArea {
  @Local appStorage: AppStorageModel = appStorageConnect();
  uiContext = this.getUIContext();
  @Local safeBottomArea: number = this.uiContext.px2vp(this.appStorage.safeBottomArea);
  @Monitor('appStorage.safeBottomArea')
  safeTopAreaChange() {
    this.safeBottomArea = this.uiContext.px2vp(this.appStorage.safeBottomArea);
  }

  build() {
    Row() {}
    .width('100%')
    .height(this.safeBottomArea + (playerStore.current  ? 64 : 0))
  }
}