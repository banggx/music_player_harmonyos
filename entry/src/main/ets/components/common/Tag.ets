@ComponentV2
export struct Tag {
  @Param @Require text: string;
  @Param type: 'primary' | 'default' | Resource = 'default';
  @Param mode: 'outlined' | 'filled' = 'outlined';
  @Param bg: Resource | null = null;

  @Computed
  get color() {
    if (this.type === 'primary') {
      return this.mode === 'filled' ? $r('app.color.white') :  $r('app.color.purple');
    } else if (this.type === 'default') {
      return this.mode === 'filled' ? $r('app.color.white') : $r('app.color.text_lv2')
    }
    return this.type;
  }

  build() {
    Row() {
      Text(this.text)
        .fontSize(10)
        .fontColor(this.color)
    }.padding({ top: 2, bottom: 2, left: 3, right: 3 })
    .border({ width: 1, style: BorderStyle.Solid, color: this.color })
    .borderRadius(4)
    .backgroundColor(this.mode === 'filled' ? this.color : this.bg || Color.Transparent)
  }
}