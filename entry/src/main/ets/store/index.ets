import { PlayerStore } from './player';
import { UIControl } from './uiControl';
export * from './player';
export * from './uiControl';

export const playerStore = new PlayerStore();
export const uiControl = new UIControl();