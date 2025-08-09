import { SingerItem } from '../singer';

export interface AlbumItem {
  publishTime:     number;
  artist:          SingerItem;
  blurPicUrl:      string;
  description:     string;
  commentThreadId: string;
  pic:             number;
  type:            string;
  tags:            string;
  picUrl:          string;
  companyId:       number;
  size:            number;
  briefDesc:       string;
  copyrightId:     number;
  artists:         SingerItem[];
  name:            string;
  paid:            boolean;
  alias:           string[];
  onSale:          boolean;
  company:         string;
  subType:         string;
  id:              number;
  alg:             string;
  picId:           number;
  status:          number;
}
