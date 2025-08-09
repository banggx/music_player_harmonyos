import { Service } from './_base';
import { GetSongDetailRes, GetSongURLRes, GetSongLyricRes } from '../model/song';

export class SongService extends Service {
  getSongDetail(id: number[]): Promise<GetSongDetailRes> {
    return this.get<GetSongDetailRes>(`/song/detail?ids=${id.join(',')}`);
  }

  getSongURL(id: number[]): Promise<GetSongURLRes> {
    return this.get<GetSongURLRes>(`/song/url?id=${id.join(',')}`);
  }

  getSongLyric(id: number): Promise<GetSongLyricRes> {
    return this.get<GetSongLyricRes>(`lyric?id=${id}`);
  }
}