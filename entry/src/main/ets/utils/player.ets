import { media } from "@kit.MediaKit";

@ObservedV2
export class MusicPlayer {
  player: media.AVPlayer | null = null;
  @Trace
  state: media.AVPlayerState = 'idle';
  @Trace
  currentTime: number = 0;
  @Trace
  volume: number = 75;

  async init(url: string, callback: () => void) {
    this.player = await media.createAVPlayer();
    this.player.url = url;
    this.player.on('stateChange', (newState) => {
      this.state = newState;
      console.log('changeState', newState);
      if (newState === 'initialized') {
        this.player?.prepare();
      }
      if (newState === 'prepared') {
        this.player?.setVolume(this.volume / 100);
        callback();
      }
    });
    this.player.on('error', (err) => {
      console.error('【player】', err);
    });
    this.player?.on('timeUpdate', (time: number) => {
      this.currentTime = time;
    });
  }

  play() {
    if (this.state === 'prepared' || this.state === 'paused') {
      this.player?.play();
    }
  }

  pause() {
    if (this.state === 'playing') {
      this.player?.pause();
    }
  }

  updateVolume(volume: number) {
    this.volume = volume;
    this.player?.setVolume(volume / 100);
  }
}