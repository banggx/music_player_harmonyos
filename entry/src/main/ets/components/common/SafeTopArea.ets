import { appStorageConnect, AppStorageModel } from '../../storage/appStorage';

@ComponentV2
export struct SafeTopArea {
  @Local appStorage: AppStorageModel = appStorageConnect();
  uiContext = this.getUIContext();
  @Local safeTopArea: number = this.uiContext.px2vp(this.appStorage.safeTopArea);
  @Monitor('appStorage.safeTopArea')
  safeTopAreaChange() {
    this.safeTopArea = this.uiContext.px2vp(this.appStorage.safeTopArea);
  }

  build() {
    Row() {}
    .width('100%')
    .height(this.safeTopArea)
  }
}