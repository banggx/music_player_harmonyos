import axios, { Axios, AxiosRequestConfig, InternalAxiosRequestConfig, AxiosResponse } from '@ohos/axios';
import { assign } from '../utils/tools';
import { dataStorage } from '../storage/dataStorage';
import { LOGIN_COOKIE } from '../constants/common';

interface CookieParams {
  cookie: string;
}

export class Service {
  instance: Axios;
  constructor(config: AxiosRequestConfig = {}) {
    const opts = assign({
      "baseURL": 'http://127.0.0.1:3000',
      "timeout": 10000,
    }, config);
    this.instance = axios.create(opts);
    this.instance.interceptors.request.use((request: InternalAxiosRequestConfig) => {
      const cookie = dataStorage.get(LOGIN_COOKIE) as string;
      if (cookie) {
        const cookieParams: CookieParams = {cookie: encodeURIComponent(cookie)};
        if (request.method?.toUpperCase() === 'GET') {
          request.params = assign(request.params || {}, cookieParams);
        } else if (request.method?.toUpperCase() === 'POST') {
          request.data = assign(request.data || {}, cookieParams);
        }
      }
      return request;
    });
    this.instance.interceptors.response.use((response: AxiosResponse) => {
      return response.data;
    })
  }

  get<T>(url: string, config?: AxiosRequestConfig): Promise<T> {
    return this.instance.get(url, config);
  }

  post<T>(url: string, data?: Record<string, Object>, config?: AxiosRequestConfig): Promise<T> {
    return this.instance.post(url, data, config);
  }
}
