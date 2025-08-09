export function assign(target: Record<string, Object>, ...source: Object[]): Record<string, Object> {
  for (const items of source) {
    for (const key of Object.keys(items)) {
      target[key] = Reflect.get(items, key)
    }
  }
  return target;
}

// 格式化音乐时长
export function formatMusicDT(dt: number) {
  const seconds = Math.ceil(dt / 1000);
  const minute = Math.floor(seconds / 60);
  const second = (seconds % 60).toString().padStart(2, '0');
  return `${minute}:${second}`;
}

// 转化 00:00.000 格式时间
export function timeStringToMs(timeStr: string) {
  const match = timeStr.match(/^(\d{2}):(\d{2})\.(\d{2,3})$/);
  if (!match) return null;

  const minutes = parseInt(match[1], 10);
  const seconds = parseInt(match[2], 10);
  const milliseconds = parseInt(match[3], 10);

  return minutes * 60 * 1000 + seconds * 1000 + milliseconds;
}

export function formatNumber(num: number): string {
  if (num === 0) return '0';

  const absNum = Math.abs(num);
  const sign = num < 0 ? '-' : '';

  if (absNum < 10000) {
    // 小于1万，直接返回原数字
    return sign + absNum.toString();
  } else if (absNum < 100000000) {
    // 1万到1亿之间，以万为单位
    const wan = absNum / 10000;
    // 如果是整数万，直接显示
    if (wan === Math.floor(wan)) {
      return sign + wan.toString() + '万';
    }
    // 否则保留一位小数
    return sign + wan.toFixed(1).replace(/\.0$/, '') + '万';
  } else {
    // 大于等于1亿，以亿为单位
    const yi = absNum / 100000000;
    // 如果是整数亿，直接显示
    if (yi === Math.floor(yi)) {
      return sign + yi.toString() + '亿';
    }
    // 否则保留一位小数
    return sign + yi.toFixed(1).replace(/\.0$/, '') + '亿';
  }
}