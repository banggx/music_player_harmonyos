import { Service } from './_base';
import { PrivateContentRes } from '../model/common';
import { RecommendSongsRes } from '../model/song';
import { GetHotPlaylistRes } from '../model/playlist';
import { GetHotSingerRes } from '../model/singer';


export class CommonService extends Service {
  getPrivateContent(): Promise<PrivateContentRes> {
    return this.get<PrivateContentRes>('/personalized/privatecontent');
  }

  getHotSinger(): Promise<GetHotSingerRes> {
    return this.get<GetHotSingerRes>('/top/artists');
  }

  getRecommendSongs(): Promise<RecommendSongsRes> {
    return this.get<RecommendSongsRes>('recommend/songs');
  }

  getHotPlaylists(): Promise<GetHotPlaylistRes> {
    return this.get<GetHotPlaylistRes>('/top/playlist/highquality')
  }
}