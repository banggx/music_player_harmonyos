import image from '@ohos.multimedia.image';
import effectKit from '@ohos.effectKit';
import { http } from '@kit.NetworkKit';

export function getImagePixelInfo(imageURL: string): Promise<string> {
  return new Promise<string>(async (resolve, reject) => {
    try {
      const data: http.HttpResponse = await http.createHttp().request(imageURL);
      let code: number = data.responseCode;
      if (http.ResponseCode.OK === code) {
        const imageSource: image.ImageSource = await image.createImageSource(data.result as string);
        // 获取图片信息
        const pixelMap: image.PixelMap = await imageSource.createPixelMap();
        effectKit.createColorPicker(pixelMap, (err, colorPicker) => {
          if (err) {
            reject(err);
          }
          let color = colorPicker.getMainColorSync();
          const bgColor = "#" + color.alpha.toString(16) + color.red.toString(16) + color.green.toString(16) + color.blue.toString(16);
          resolve(bgColor);
        })
      } else {
        throw new Error('get image error');
      }
    } catch(err) {
      console.log(err);
      resolve('#222628');
    }
  })
}