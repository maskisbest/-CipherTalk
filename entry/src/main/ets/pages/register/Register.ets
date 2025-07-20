import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import InputField from '../../utils/InputField'
import PrimaryButton from '../../utils/PrimaryButton'
import { InputParams } from '../../utils/Params'
import { ButtonParams } from '../../utils/ButtonParams'
import photoAccessHelper from '@ohos.file.photoAccessHelper';




@Entry
@Component
struct RegisterPage {
    @State username: string = ''
    @State password: string = ''
    @State confirmPassword: string = ''
    @State phone: string = ''
    @State verificationCode: string = ''
    @State countDown: number = 0
    // @State avatarPath: string = ''  // 新增头像路径状态
    @State avatarPath: string = ''
    // @State avatarPreview: string = ''

    selectOptions: photoAccessHelper.PhotoSelectOptions = {
        MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE,
        maxSelectNumber: 1,
        isPhotoTakingSupported: true
    }

    build() {

        Column({ space: 20 }) {
            Blank()
            .height('3%')
            // 整合后的头像上传与标题区域
            Column({ space: 15 }) {
                // 标题区域
                Text('注册新账号')
                    .fontSize(24)
                    .fontWeight(FontWeight.Bold)
                    .width('100%')
                    .textAlign(TextAlign.Center)

                // 头像上传区域
                Column({ space: 15 }) {
                    // 头像预览
                    if (this.avatarPath) {
                        Image(this.avatarPath)
                            .width(80)
                            .height(80)
                            .borderRadius(40)
                            .objectFit(ImageFit.Cover)
                    } else {
                        Image($r('app.media.icon_default_avatar'))
                            .width(80)
                            .height(80)
                            .borderRadius(40)
                            .opacity(0.6)
                    }

                    // 上传按钮区域
                    Column({ space: 8 }) {
                        Button('选择头像')
                            .width('100%')
                            .height(40)
                            .fontSize(14)
                            .backgroundColor('#f0f0f0')
                            .fontColor('#333')
                            .onClick(() => {
                                this.selectAvatar()
                            })

                        Text('建议上传清晰的正方形头像')
                            .fontSize(12)
                            .fontColor('#999')
                            .width('100%')
                            .textAlign(TextAlign.Center)
                    }
                    .width('50%')
                }
                .width('100%')
                .justifyContent(FlexAlign.SpaceBetween)
            }
            .width('100%')
            .padding({ bottom: 20 })
            // .borderBottom({ width: 1, color: '#e0e0e0' })


            // 标题区域
            // Text('注册新账号')
            //     .fontSize(24)
            //     .fontWeight(FontWeight.Bold)
            //     .margin({ bottom: 30 })

            // 表单区域
            Column({ space: 15 }) {
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
                        placeholder: '请输入手机号',
                        value: this.phone,
                        onValueChange: (value: string) => {
                            this.phone = value
                        },
                        icon: $r('app.media.icon_phone')
                    } as InputParams

                })

                Row() {
                    InputField({
                        config: {
                            placeholder: '请输入验证码',
                            value: this.verificationCode,
                            onValueChange: (value: string) => {
                                this.verificationCode = value
                            },
                            inputWidth: '70%'
                        } as InputParams
                    })

                    Button(this.countDown > 0 ? `${this.countDown}s` : '获取验证码')
                        .width('30%')
                        .height(40)
                        .backgroundColor(this.countDown > 0 ? '#ccc' : '#57be6a')
                        .fontColor('#fff')
                        .margin({ left: 7 })
                        .onClick(() => {
                            if (!this.phone.trim()) {
                                promptAction.showToast({ message: '请输入手机号' })
                                return
                            }
                            this.startCountdown()
                            // 发送验证码逻辑
                        })
                }

                InputField({
                    config: {
                        placeholder: '请输入密码',
                        value: this.password,
                        onValueChange: (value: string) => {
                            this.password = value
                        },
                        icon: $r('app.media.icon_lock'),
                        obscureText: true
                    }
                })

                InputField({
                    config: {
                        placeholder: '请确认密码',
                        value: this.confirmPassword,
                        onValueChange: (value: string) => {
                            this.confirmPassword = value
                        },
                        icon: $r('app.media.icon_lock'),
                        obscureText: true
                    }
                })

                PrimaryButton({
                    config: {
                        text: '注册',
                        onClickFlag: () => {
                            if (this.validateForm()) {
                                promptAction.showToast({ message: '注册成功' })
                                router.back()
                            }
                        }
                    } as ButtonParams
                })
            }
            .padding({ left: 20, right: 20 })

            // 底部提示区域
            Column() {
                Text('注册即表示同意用户协议')
                    .fontSize(12)
                    .fontColor('#999')
                    .margin({ top: 10 })

                Text('已有账号？去登录')
                    .fontSize(14)
                    .fontColor('#57be6a')
                    .onClick(() => {
                        router.back()
                    })
            }
            .width('100%')
            .alignItems(HorizontalAlign.Center)
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#f5f5f5')
    }

    // 表单验证
    validateForm(): boolean {
        if (!this.avatarPath.trim()) {
            promptAction.showToast({ message: '请上传头像' })
            return false
        }
        if (!this.username.trim()) {
            promptAction.showToast({ message: '请输入用户名' })
            return false
        }
        if (!this.phone.trim()) {
            promptAction.showToast({ message: '请输入手机号' })
            return false
        }
        if (!this.verificationCode.trim()) {
            promptAction.showToast({ message: '请输入验证码' })
            return false
        }
        if (!this.password.trim()) {
            promptAction.showToast({ message: '请输入密码' })
            return false
        }
        if (this.password !== this.confirmPassword) {
            promptAction.showToast({ message: '两次输入的密码不一致' })
            return false
        }
        return true
    }

    // 验证码倒计时
    startCountdown() {
        if (this.countDown > 0) return
        this.countDown = 60
        setInterval(() => {
            if (this.countDown > 0) {
                this.countDown--
            }
        }, 1000)
    }

    selectAvatar() {
        const photoPiker = new photoAccessHelper.PhotoViewPicker()
        photoPiker.select(this.selectOptions).then((result)=>{
            console.log('result ',JSON.stringify( result))
            if(result.photoUris.length > 0){
                this.avatarPath = result.photoUris[0]
            }
        })
    }
}
