import { Service } from './_base';
import { GetSingerDetailInfoRes, GetSingerSongsRes } from '../model';

export class SingerService extends Service {
  getSingerDetail(id: number): Promise<GetSingerDetailInfoRes> {
    return this.get<GetSingerDetailInfoRes>(`/artist/detail?id=${id}`);
  }

  getSingerSongs(id: number, page: number): Promise<GetSingerSongsRes> {
    return this.get<GetSingerSongsRes>(`/artist/songs?id=${id}&limit=${50}&offset=${page * 50}`);
  }
}