import promptAction from '@ohos.promptAction'
import InputField from '../../utils/InputField'
import PrimaryButton from '../../utils/PrimaryButton'
import { InputParams } from '../../params/InputParams'
import { ButtonParams } from '../../params/ButtonParams'
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import { router } from '@kit.ArkUI'
import axios, { AxiosRequestHeaders, AxiosResponse, FormData } from '@ohos/axios';
import { fileIo, fileUri } from '@kit.CoreFileKit'
import { data } from '@kit.TelephonyKit'
import { JSON } from '@kit.ArkTS'
import json from '@ohos.util.json'

export const API_HOST = "47.109.74.84:9999";
export const API_BASE_URL = `http://${API_HOST}`;
//`$\{API_BASE_URL}/ddchat/index/uploadAvatar`


export interface IUserInfo {
    id:string,
    email:string,
    nickname:string,
    gender:number,
    avatar:string,
    creatAt?:string,
    introduction?:string,
    birthday?:string
}

export interface IUserDao {
    userinfo:IUserInfo,
    token:string
}

interface IUser {
    email:string,
    nickname:string,
    gender?:string,
    password1:string,
    password2:string
}

export interface ResponseDao {
    success:boolean,
    message:string,
    code:string,
    data:string
}

export interface ResponseDao2<T> {
    success:boolean,
    message:string,
    code:string,
    data:T
}


export interface IAvage{
    compressUrl: string,
    url: string,
}

@Entry
@Component
struct RegisterPage {
    @State gender_secret:boolean=false
    @State email:string=''
    @State nickname:string=''
    @State gender:string=''
    @State password1:string=''
    @State password2:string=''
    @State avatarPath: string = ''
    @State flag:boolean=false

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
                        Image($r('app.media.icon_user'))
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
                                const photoPiker=new photoAccessHelper.PhotoViewPicker()
                                photoPiker.select(this.selectOptions).then((result)=>{
                                    if(result.photoUris.length>0){
                                        this.avatarPath=result.photoUris[0]
                                    }
                                })
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
                        value: this.nickname,
                        onValueChange: (value: string) => {
                            this.nickname = value
                        },
                        icon: $r('app.media.icon_user')
                    } as InputParams
                })

                InputField({
                    config: {
                        placeholder: '请输入邮箱',
                        value: this.email,
                        onValueChange: (value: string) => {
                            this.email = value
                        },
                        icon: $r('app.media.icon_phone')
                    } as InputParams

                })

                Column(){
                    // 男性选项
                    Row() {
                        Text("您是:")
                        Radio({ value: '男', group: 'genderGroup' })
                            .checked(this.gender === '男')
                            .onChange((isChecked: boolean) => {
                                if (isChecked) {
                                    this.gender = '男'
                                    this.gender_secret=false
                                }
                            })
                        Text('先生')

                        Blank(10)

                        Radio({ value: '女', group: 'genderGroup' })
                            .checked(this.gender === '女')
                            .onChange((isChecked: boolean) => {
                                if (isChecked) {
                                    this.gender = '女'
                                    this.gender_secret=false
                                }
                            })
                        Text('女士')

                        Blank(10)

                        Radio({ value: '男', group: 'genderGroup' })
                            .checked(this.gender === '')
                            .onChange((isChecked: boolean) => {
                                if (isChecked) {
                                    this.gender = '男'
                                    this.gender_secret=true
                                }
                            })
                        Text('保密')
                    }
                }
                .width('100%')

                InputField({
                    config: {
                        placeholder: '请输入密码',
                        value: this.password1,
                        onValueChange: (value: string) => {
                            this.password1 = value
                        },
                        icon: $r('app.media.icon_lock'),
                        obscureText: true
                    }
                })

                InputField({
                    config: {
                        placeholder: '请确认密码',
                        value: this.password2,
                        onValueChange: (value: string) => {
                            this.password2 = value
                        },
                        icon: $r('app.media.icon_lock'),
                        obscureText: true
                    }
                })
                Button('注册')
                    .onClick(()=>{
                        this.flag=this.validateForm()
                        if(this.flag)this.NetRequest()
                    })
                    .backgroundColor(Color.Green)
                    .width(200)
            }
            .padding({ left: 20, right: 20 })

            // 底部提示区域
            Column() {
                Text('注册即表示同意用户协议')
                    .fontSize(12)
                    .fontColor('#999')

                Blank(10)

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

    //表单验证
    validateForm(): boolean {
        if(!this.avatarPath.trim()){
            promptAction.showToast({ message: '请上传头像' })
            return false
        }
        if (!this.nickname.trim()) {
            promptAction.showToast({ message: '请输入用户名' })
            return false
        }
        if (!this.email.trim()) {
            promptAction.showToast({ message: '请输入邮箱' })
            return false
        }
        if (!this.password1.trim()) {
            promptAction.showToast({ message: '请输入密码' })
            return false
        }
        if (this.password2 !== this.password1) {
            promptAction.showToast({ message: '两次输入的密码不一致' })
            return false
        }
        else if(!this.isValidEmail(this.email)){
            promptAction.showToast({ message: '邮箱格式错误' })
            return false
        }
        return true
    }

    isValidEmail(email: string): boolean {
        // 邮箱正则表达式
        const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        return emailRegex.test(email);
    }

    update_Avatar(fileUrl:string){
        const file=fileIo.openSync(fileUrl,fileIo.OpenMode.READ_ONLY)
        const filePath=getContext().cacheDir+'/'+file.name
        fileIo.copyFileSync(file.fd,filePath)
        fileIo.closeSync(file.fd)

        const formData=new FormData()
        const userID =Math.floor(Math.random()*1000000)
        formData.append('userId',userID+'')
        formData.append('image',`internal://cache/${file.name}`)

        axios({
            method:'POST',
            url:`${API_BASE_URL}/ddchat/index/uploadAvatar`,
            data:formData,
            headers:{
                'Content-Type':'multipart/form-data'
            },
            context:getContext()
        }).then((res:AxiosResponse<ResponseDao2<IAvage>>)=>{
            console.log(JSON.stringify((res)))
            const data:ResponseDao2<IAvage>=res.data
            console.log(JSON.stringify(data))
        })
    }

    NetRequest(){
        const registerUrl = `${API_BASE_URL}/ddchat/index/register`;
        const user:IUser={
            email:this.email,
            nickname:this.nickname,
            gender:this.gender,
            password1:this.password1,
            password2:this.password2
        }
        axios({
            method:'Post',
            url:registerUrl,
            data:user
        }).then((res:AxiosResponse<ResponseDao>)=>{
            console.log(JSON.stringify(res))
            const code = res.data.code; // 直接获取 code
            if(code=='S1'){
                AlertDialog.show(
                    {
                        message: '注册成功', // 对话框消息内容
                        primaryButton: {        // 主按钮配置
                            value: '确定',
                            action: () => {
                                console.log('点击了确定按钮');
                            }
                        }
                    }
                )
                router.back()
            }
        })
    }
}
