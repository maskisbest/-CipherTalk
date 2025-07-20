// Login.ets

import router from '@ohos.router'
// import { InputType } from '@ohos.ohosFramework'
import promptAction from '@ohos.promptAction'

@Entry
@Component//声明这个是可复用的部件
struct LoginPage {
    @State username: string = ''
    @State password: string = ''

    build() {
        Column({ space: 10 }) {
            TextInput({ placeholder: '请输入用户名' })
                .onChange((value: string) => {
                    this.username = value
                    console.log("1111")
                })

            TextInput({ placeholder: '请输入密码' })
                .type(InputType.Password)
                .onChange((value: string) => {
                    this.password = value
                })


            Button('登录')
                .onClick(() => {
                    // 模拟登录验证
                    console.log("0")
                    if (this.username === 'test' && this.password === '123456') {
                        console.log("1")
                        router.pushUrl({ url: 'pages/Index' })
                    } else {
                        console.log("2")
                        promptAction.showToast({
                            message: '用户名或密码错误',
                            duration: 2000
                        })
                    }
                })

            Text('没有账号？去注册')
                .fontColor('#57be6a')
                .fontSize(14)
                .onClick(() => {
                    console.log("3")
                    router.pushUrl({ url: 'pages/register/Register' })
                })
        }
        .padding(20)
    }
}

// function alert(arg0: string) {
//     throw new Error('Function not implemented.')
// }
