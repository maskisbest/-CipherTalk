// PrimaryButton.ets
import { ButtonParams } from '../utils/ButtonParams'

@Component
export default struct PrimaryButton {
    @Prop config: ButtonParams = {}

    build() {
        Button(this.config.text ?? '按钮')
            .width('100%')
            .height(50)
            .backgroundColor('#57be6a')
            .fontColor('#fff')
            .fontSize(16)
            .borderRadius(25)
            .onClick(() => {
                // 安全调用函数
                if (typeof this.config.onClickFlag === 'function') {
                    this.config.onClickFlag()
                }
            })
    }
}
