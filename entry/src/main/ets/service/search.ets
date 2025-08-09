import { Service } from './_base';
import { GetSearchHotSongRes, GetSearchSuggest, CommonRes } from '../model';
import { SearchType } from '../constants';

export class SearchService extends Service {
  getSearchHotSong(): Promise<GetSearchHotSongRes> {
    return this.get<GetSearchHotSongRes>('/search/hot/detail');
  }

  getSearchSuggest(key: string): Promise<GetSearchSuggest> {
    return this.get<GetSearchSuggest>(`/search/suggest?keywords=${key}&type=mobile`);
  }

  search<T extends CommonRes>(key: string, type: SearchType, limit?: number, offset?: number): Promise<T> {
    let url = `/search?keywords=${encodeURIComponent(key)}&type=${type}`;
    if (limit) {
      url += `&limit=${limit}`;
    }
    if (offset) {
      url += `&offset=${offset}`;
    }
    return this.get<T>(url);
  }
}
