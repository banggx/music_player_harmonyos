import { preferences } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

export class DataStorage {
  store: preferences.Preferences | null = null;

  init(context: common.BaseContext) {
    return new Promise<void>(resolve => {
      preferences.getPreferences(context, 'musicStore', (err: BusinessError, val: preferences.Preferences) => {
        if (err) {
          console.error("Failed to get preferences. code =" + err.code + ", message =" + err.message);
          return;
        }
        this.store = val;
        resolve();
      })
    });
  }

  get(key: string) {
    return this.store?.getSync(key, null);
  }

  set(key: string, value: preferences.ValueType) {
    this.store?.putSync(key, value);
    this.store?.flush();
  }

  has(key: string) {
    return this.store?.hasSync(key);
  }

  delete(key: string) {
    this.store?.deleteSync(key);
    this.store?.flush();
  }

  clear() {
    this.store?.clearSync();
    this.store?.flush();
  }
}

export const dataStorage = new DataStorage();