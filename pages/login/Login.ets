// ets/pages/login/Login.ets
import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import axios, {AxiosResponse} from '@ohos/axios'
import InputField from '../../utils/InputField'
import PrimaryButton from '../../utils/PrimaryButton'
import { InputParams } from '../../params/InputParams'
import { ButtonParams } from '../../params/ButtonParams'
import { ResponseDao, IUserDao } from '../../params/APIModel'

@Entry
@Component
struct LoginPage {
    @State email: string = ''
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
                        placeholder: '请输入邮箱',
                        value: this.email,
                        onValueChange: (value: string) => {
                            this.email = value
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

                    Text('记住密码')
                        .fontSize(12)
                        .fontColor('#666')
                    Blank('10')

                    Checkbox({ name: 'rememberMe' })
                        .width(20)
                        .height(20)
                        .onChange((isChecked: boolean) => {
                            // 处理自动登录逻辑
                        })

                    Text('自动登录')
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
                                // router.pushUrl({ url: 'pages/Index' })
                                this.onLogin()
                            }
                        }
                    } as ButtonParams,
                })
            }
            .padding({ left: 20, right: 20 })

            // 底部操作区域重构
            Column({ space: 20 }) {
                // 忘记密码与注册行
                Row({ space: 15 }) {
                    Text('忘记密码？')
                        .fontSize(14)
                        .fontColor('#57be6a')
                        .onClick(() => {
                            // 跳转到找回密码页面
                        })

                    // 右侧自动填充
                    Blank()

                    // 注册链接
                    Text('没有账号？去注册')
                        .fontColor('#57be6a')
                        .fontSize(14)
                        .onClick(() => {
                            router.pushUrl({
                                url: 'pages/register/Register'
                            })
                        })
                }
                .width('100%')
                .padding({ left: 20, right: 20 })

                // 分割线
                Divider()
                    .strokeWidth(1)
                    .color('#eee')

                // 其他登录方式区域
                Column({ space: 10 }) {
                    Text('其他登录方式')
                        .fontSize(14)
                        .fontColor('#999')
                        .width('100%')
                        .textAlign(TextAlign.Center)

                    // 图标行（居中对齐）
                    Row({ space: 30 }) {
                        Image($r('app.media.icon_wechat'))
                            .width(40)
                            .height(40)
                            .objectFit(ImageFit.Contain)

                        Image($r('app.media.icon_qq'))
                            .width(40)
                            .height(40)
                            .objectFit(ImageFit.Contain)
                    }
                    .width('100%')
                    .justifyContent(FlexAlign.Center)
                    // .alignItems(A)
                }
                .width('100%')
            }
            .padding({ left: 20, right: 20, top: 10 })

        }
        .width('100%')
        .height('100%')
        .backgroundColor('#f5f5f5')
    }

    // 表单验证
    validateForm(): boolean {
        if (!this.email.trim()) {
            promptAction.showToast({ message: '请输入邮箱' })
            return false
        }
        if (!this.password.trim()) {
            promptAction.showToast({ message: '请输入密码' })
            return false
        }
        return true
    }

    onLogin() {
        const user: IUserDao = {
            email: this.email,
            password: this.password
        }
        axios({
            method: "POST",
            url: "http://47.109.74.84:9999/ddchat/index/login",
            data: user
        }).then(async (res: AxiosResponse<ResponseDao<IUserDao>>) => {
            const data = res.data
            if (data.code == "S1") {
                router.pushUrl({ url: 'pages/Index'})
            } else {
                promptAction.showToast({ message: data.message })
            }
        }).catch((error: Error) => {
            promptAction.showToast({ message: '网络请求失败：' + error.message })
        })
    }
}
