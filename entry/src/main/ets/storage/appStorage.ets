import { AppStorageV2 } from '@kit.ArkUI';

@ObservedV2
export class AppStorageModel {
  @Trace safeTopArea: number = 0;
  @Trace safeBottomArea: number = 0;
}

export function appStorageConnect() {
  return AppStorageV2.connect(AppStorageModel, 'app', () => new AppStorageModel())!;
}