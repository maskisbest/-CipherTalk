import home from './home/Home'
// import contact from './contact/Contact'
// import discovery from './discovery/Discovery'
// import mine from './mine/Mine'
import WindowManager from '../utils/WindowManager'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { router, Router } from '@kit.ArkUI'
import InputField from '../utils/InputField'
import { InputParams } from '../params/InputParams'
import axios from '@ohos/axios'

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
struct Index {
    @State currentIndex: number = 0 // 用于记录当前选中的tab索引
    @State target_email:string=''

    @Builder
    mybuilder(title: string, tabIndex: number) {
        Column() {
            if (title == '秘语') {
                Image(this.currentIndex === tabIndex ?
                $r('app.media.ic_public_community_messages_filled') :
                $r('app.media.ic_public_community_messages'))
                    .width(30)
            }
            else if(title=='联系人'){
                Image(this.currentIndex === tabIndex ?
                $r('app.media.ic_public_contacts_group_filled') :
                $r('app.media.ic_public_contacts_group'))
                    .width(30)
            }
            else if(title=='发现'){
                Image(this.currentIndex === tabIndex ?
                $r('app.media.ic_public_highlightsed') :
                $r('app.media.ic_public_highlights'))
                    .width(30)
            }
            else if(title=='我'){
                Image(this.currentIndex === tabIndex ?
                $r('app.media.ic_public_contacts_filled') :
                $r('app.media.ic_public_contacts'))
                    .width(30)
            }
            Text(title)
            // .fontColor(this.currentIndex === tabIndex ? Color.Blue : Color.Gray)
                .fontSize(12)
                .margin({ top: 4 })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
    }
    @Builder
    coin(title:string,img:ResourceStr){
        Button({ type: ButtonType.Normal, stateEffect: true }) {
            Row() {
                // 左侧图片
                Image(img)
                    .width(30)
                    .height(30)
                    .margin({ left:20,right: 10 })  // 图片与文字间隔10px

                // 右侧文字
                Text(title)
                    .fontSize(16)
                    .fontColor('#333333')
                Image($r('app.media.ic_public_arrow_right'))
                    .position({ x: '90%' ,y:'12%'})  // 右侧定位
                    .width(20)
            }
            .width('100%')
        }
        .height(50)  // 按钮高度
        .backgroundColor('#FFFFFF')  // 白底
        .border({
            width: 0.8,
            color: '#DDDDDD',  // 浅灰色边框
            style: BorderStyle.Solid
        })
        .width('100%')
        .stateEffect(true)  // 启用按压效果
    }
    private tabController: TabsController = new TabsController()
    private tabTipCounts: number[] = [5, 0, 8, 0]
    private tabTitles: string[] = ["秘语", "联系人", "发现", "我"]
    private tabTextColors: string[] = ["#040404", "#57be6a"]

    build() {
        Column() {
            Tabs({ barPosition: BarPosition.End, controller: this.tabController }) {
                // 首页
                TabContent() {
                    home()
                }
                .tabBar(this.mybuilder('秘语',0))
                // 通讯录
                TabContent() {
                    Column(){
                        InputField({
                            config: {
                                placeholder: '请输入需要添加的用户邮箱',
                                value: this.target_email,
                                onValueChange: (value: string) => {
                                    this.target_email = value
                                },
                            } as InputParams
                        })

                        Button({ type: ButtonType.Normal, stateEffect: true }) {
                            Row() {
                                // 右侧文字
                                Text('搜索')
                                    .fontSize(16)
                                    .fontColor(Color.Green)
                            }
                        }
                        .onClick(()=>{
                            router.back()
                        })
                        .height(50)  // 按钮高度
                        .backgroundColor('#FFFFFF')  // 白底
                        .border({
                            width: 0.8,
                            color: '#DDDDDD',  // 浅灰色边框
                            style: BorderStyle.Solid
                        })
                        .width('100%')
                        .stateEffect(true)  // 启用按压效果
                    }
                    .height('100%')
                }
                .tabBar(this.mybuilder('联系人',1))
                .backgroundColor('#f0f0f0') // 浅灰色背景
                //  发现
                TabContent() {
                    Column() {
                        Column(){
                            this.coin('朋友圈',$r('app.media.groupa'))
                            Blank(10)
                            this.coin('视频号',$r('app.media.avd'))
                            this.coin('直播',$r('app.media.living'))
                            Blank(10)
                            this.coin('扫一扫',$r('app.media.pic1'))
                            this.coin('听一听',$r('app.media.pic2'))
                            Blank(10)
                            this.coin('看一看',$r('app.media.pic3'))
                            this.coin('搜一搜',$r('app.media.pic4'))
                            Blank(10)
                            this.coin('附近',$r('app.media.living'))

                            Blank(10)
                            this.coin('小程序',$r('app.media.living'))
                        }
                    }.height('100%')
                }
                .height('100%')
                .tabBar(this.mybuilder('发现',2))
                .backgroundColor('#f0f0f0') // 浅灰色背景
                // 我的
                TabContent() {
                    Column() {
                        // 联系人列表
                        Column() {
                            //用户信息
                            Button({ type: ButtonType.Normal, stateEffect: true }) {
                                Column(){

                                }
                            }
                            .height(125)  // 按钮高度
                            .backgroundColor('#FFFFFF')  // 白底
                            .border({
                                width: 0.8,
                                color: '#DDDDDD',  // 浅灰色边框
                                style: BorderStyle.Solid
                            })
                            .width('100%')
                            .stateEffect(true)  // 启用按压效果


                            Blank(15)
                            //服务
                            this.coin('服务',$r('app.media.serving'))

                            this.coin('收藏',$r('app.media.favorite'))

                            Row(){
                                this.coin('设置',$r('app.media.setting'))
                            }
                            Blank(15)
                            Row(){
                                Button({ type: ButtonType.Normal, stateEffect: true }) {
                                    Row() {
                                        // 右侧文字
                                        Text('退出登录')
                                            .fontSize(16)
                                            .fontColor(Color.Red)
                                    }
                                }
                                .onClick(()=>{
                                    router.back()
                                })
                                .height(50)  // 按钮高度
                                .backgroundColor('#FFFFFF')  // 白底
                                .border({
                                    width: 0.8,
                                    color: '#DDDDDD',  // 浅灰色边框
                                    style: BorderStyle.Solid
                                })
                                .width('100%')
                                .stateEffect(true)  // 启用按压效果
                            }
                        }
                        .width('100%')
                    }
                    .height('100%')
                }
                .tabBar(this.mybuilder('我',3))
                .backgroundColor('#f0f0f0') // 浅灰色背景
            }
            .onChange((index: number) => {
                this.currentIndex = index // 当tab切换时更新状态
            })
            .scrollable(false)  // 禁止左右滑动切换
            .animationDuration(0)  // 禁用切换动画
            .barMode(BarMode.Fixed)  // 固定TabBar不滚动
        }
        .width('100%')
        .height('100%')
    }


    @Builder
    createTabMenu(index: number) {

        Stack({ alignContent: Alignment.Center }) {

            // 数字右标
            Badge({
                count: this.tabTipCounts[index],
                maxCount: 99,
                position: BadgePosition.RightTop,
                style: {
                    color: 0xFFFFFF,
                    fontSize: 13,
                    badgeSize: 20,
                    badgeColor: Color.Red
                }
            }) {
                Column() {
                    /**
                     * Contain  图片按比例缩放以适应容器边界，可能会出现空白区域
                     Cover  图片按比例缩放以填充容器，可能会被裁剪
                     Auto  默认值，图片大小保持原始大小
                     Fill  图片拉伸以填充容器，可能会出现失真
                     ScaleDown  图片按比例缩小以适应容器边界，但是不会放大图片
                     None  不进行任何缩放操作，即使图片溢出容器也不会被裁剪或缩放
                     */
                    // icon图标
                    Image(this.currentIndex === index ? `/images/main_page_index${index}_pre.png` :
                        `/images/main_page_index${index}_nor.png`)
                        .width(29.714)
                        .height(26)
                        .objectFit(ImageFit.Fill)
                        .margin({ bottom: 3 })
                    // 文本
                    Text(this.tabTitles[index])
                        .fontColor(this.tabTextColors[this.currentIndex === index?1:0])
                        .fontSize(14)
                }
                .backgroundColor(Color.Transparent)
                .justifyContent(FlexAlign.Center)
            }
            .width(42)
            .height(40)
        }
        .width("100%")
        .height("100%")
    }
}