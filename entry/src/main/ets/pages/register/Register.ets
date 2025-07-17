// Register.ets
import router from '@ohos.router'
import promptAction from '@ohos.promptAction'

@Entry
@Component
struct RegisterPage {
    @State username: string = ''
    @State password: string = ''
    @State confirmPassword: string = ''

    build() {
        Column({ space: 10 }) {
            TextInput({ placeholder: '请输入用户名' })
                .onChange((value: string) => {
                    this.username = value
                })

            TextInput({ placeholder: '请输入密码' })
                .type(InputType.Password)
                .onChange((value: string) => {
                    this.password = value
                })

            TextInput({ placeholder: '请确认密码' })
                .type(InputType.Password)
                .onChange((value: string) => {
                    this.confirmPassword = value
                })

            Button('注册')
                .onClick(() => {
                    if (this.password !== this.confirmPassword) {
                        promptAction.showToast({
                            message: '两次输入的密码不一致',
                            duration: 2000
                        })
                    } else {
                        promptAction.showToast({
                            message: '注册成功',
                            duration: 2000
                        })
                        router.back()
                    }
                })

            Text('已有账号？去登录')
                .fontColor('#57be6a')
                .fontSize(14)
                .onClick(() => {
                    router.back()
                })
        }
        .padding(20)
    }
}
