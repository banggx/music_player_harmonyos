export interface HotSearchInfo {
  score: number;
  iconType: number;
  searchWord: string;
  iconUrl?: string;
  content: string;
}

export interface SearchSuggest {
  keyword: string;
  type: number;
  alg: number;
  lastKeyword: string;
}