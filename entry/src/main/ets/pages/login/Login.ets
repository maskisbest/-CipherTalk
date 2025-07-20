// ... existing code ...
import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import InputField from '../../utils/InputField'
import PrimaryButton from '../../utils/PrimaryButton'
import { InputParams } from '../../utils/Params'
import { ButtonParams } from '../../utils/ButtonParams'

@Entry
@Component
struct LoginPage {
    @State username: string = ''
    @State password: string = ''
    @State showPassword: boolean = false

    build() {
        Column({ space: 20 }) {
            // Logo 区域
            Image($r('app.media.logo'))
                .width(100)
                .height(100)
                .margin({ bottom: 30 })

            // 表单区域
            Column({ space: 15 }) {
                // 修复：改用对象属性赋值方式
                InputField({
                    config: {
                        placeholder: '请输入用户名',
                        value: this.username,
                        onValueChange: (value: string) => {
                            this.username = value
                        },
                        icon: $r('app.media.icon_user')
                    } as InputParams
                })

                InputField({
                    config: {
                        placeholder: '请输入密码',
                        value: this.password,
                        onValueChange: (value: string) => {
                            this.password = value
                        },
                        obscureText: !this.showPassword,
                        togglePassword: () => {
                            this.showPassword = !this.showPassword
                        },
                        icon: $r('app.media.icon_lock')
                    } as InputParams
                })

                Row() {
                    Checkbox({ name: 'rememberMe' })
                        .width(20)
                        .height(20)
                        .onChange((isChecked: boolean) => {
                            // 处理记住账号逻辑
                        })

                    Text('记住账号')
                        .fontSize(12)
                        .fontColor('#666')
                }
                .margin({ top: 10 })

                // 修复：改用对象属性赋值方式
                PrimaryButton({
                    config: {
                        text: '登录',
                        onClickFlag: () => {
                            if (this.validateForm()) {
                                router.pushUrl({ url: 'pages/Index' })
                            }
                        }
                    } as ButtonParams,
                })
            }
            .padding({ left: 20, right: 20 })

            // 底部操作区域
            Column({ space: 15 }) {
                Text('忘记密码？')
                    .fontSize(14)
                    .fontColor('#57be6a')
                    .onClick(() => {
                        // 跳转到找回密码页面
                    })

                Column({ space: 15 }) {
                    // 跳转到注册页面的文本
                    Text('没有账号？去注册')
                        .fontColor('#57be6a')
                        .fontSize(14)
                        .onClick(() => {
                            // 添加路由跳转逻辑
                            router.pushUrl({
                                url: 'pages/register/Register' // 确保路径与 pages.json 中配置的路径一致
                            })
                        })
                }
                .width('100%')
                // .alignItems(HorizontalAlign.Center)

                Divider()
                    .strokeWidth(1)
                    .color('#eee')

                Row({ space: 15 }) {
                    Text('其他登录方式')
                        .fontSize(14)
                        .fontColor('#999')

                    Image($r('app.media.icon_wechat'))
                        .width(30)
                        .height(30)
                        .objectFit(ImageFit.Contain)  // 保证图片完整显示
                        // .margin({ right: 10 })      // 添加间距
                    Image($r('app.media.icon_qq'))
                        .width(30)
                        .height(30)
                        .objectFit(ImageFit.Contain)  // 保证图片完整显示
                        // .margin({ right: 10 })      // 添加间距
                        // .margin({ right: 10 })      // 添加间距
                }
            }
            .padding({ left: 20, right: 20, top: 30 })
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#f5f5f5')
    }

    // 表单验证
    validateForm(): boolean {
        if (!this.username.trim()) {
            promptAction.showToast({ message: '请输入用户名' })
            return false
        }
        if (!this.password.trim()) {
            promptAction.showToast({ message: '请输入密码' })
            return false
        }
        return true
    }
}
