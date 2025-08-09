import { Service } from './_base';
import { CommonRes, GetLoginStatusRes } from '../model';

export class UserService extends Service {
  getLoginStatus(): Promise<GetLoginStatusRes> {
    return this.get<GetLoginStatusRes>('/login/status');
  }

  sendCaptcha(phone: string): Promise<CommonRes> {
    return this.get<CommonRes>(`/captcha/sent?phone=${phone}`);
  }

  phoneLogin(phone: string, captcha: string): Promise<CommonRes> {
    return this.get<CommonRes>(`/login/cellphone?phone=${phone}&captcha=${captcha}&realIP=116.25.146.177`);
  }
}