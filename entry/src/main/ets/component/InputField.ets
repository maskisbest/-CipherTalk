// ... existing code ...
import { InputParams } from '../params/InputParams'

@Component
export default struct InputField {
    @Prop config: InputParams = {}
    @State isFocused: boolean = false
    @State isHovered: boolean = false

    build() {
        Row({ space: 4 }) {  // 恢复合理的间距
            // 图标区域
            Image(this.config.icon ?? $r('app.media.icon_user'))
                .width(20)
                .height(20)
                .opacity(0.7)
                .objectFit(ImageFit.Contain)
                .flexShrink(0)  // 强制固定宽度

            // 输入框区域
            TextInput({ placeholder: this.config.placeholder ?? '' })
                .type(this.config.obscureText ? InputType.Password : InputType.Normal)
                .onChange((value: string) => {
                    if (typeof this.config.onValueChange === 'function') {
                        this.config.onValueChange(value)
                    }
                })
                .width('90%')
                .height(48)
                .fontSize(16)
                .padding({ left: 8, right: 8 })  // 保持内边距
                .backgroundColor('#ffffff')
                .border({
                    width: 1.5,
                    color: this.isFocused ? '#57be6a' : '#e8e8e8',
                    radius: 12
                })
                .shadow({
                    color: this.isFocused ? '#57be6a4d' : '#0000001a',
                    radius: 8,
                    offsetX: 0,
                    offsetY: 2
                })
                .transition({ type: TransitionType.All })
                .onFocus(() => {
                    this.isFocused = true
                })
                .onBlur(() => {
                    this.isFocused = false
                })

            // 密码可视切换图标区域
            // if (this.config.obscureText) {
            //     Image(this.config.obscureText ? $r('app.media.icon_eye_closed') : $r('app.media.icon_eye'))
            //         .width(20)
            //         .height(20)
            //         .opacity(0.6)
            //         .transition({ type: TransitionType.All })
            //         .onHover((isHovered: boolean) => {
            //             this.isHovered = isHovered
            //         })
            //         .onClick(() => {
            //             if (typeof this.config.togglePassword === 'function') {
            //                 this.config.togglePassword()
            //             }
            //         })
            // }
        }
        .width(this.config.inputWidth ?? '100%')
        .padding({ top: 2, bottom: 2 })
        .backgroundColor('#f9f9f9')
        .borderRadius(12)
        .onHover((isHovered: boolean) => {
            this.isHovered = isHovered
        })
        .flexShrink(1)
        .justifyContent(FlexAlign.Start)  // 居对齐
    }
}
