import router from '@ohos.router'

import { AgentModel } from '../model/AgentModel'
import ListChatItem, { ChatItemData } from '../../component/ListChatItem'
import WechatToolbar from '../../component/WechatToolbar'


@Preview
@Component
export default struct Home {
    @State chatList: ChatItemData[] = [

        {
            headSrc: $r("app.media.ic_user_head2"),
            nickname: "老婆",
            content: "今晚给你做了好吃的，早点下班哦😊",
            time: "17:21"
        },
        {
            headSrc: $r("app.media.ic_user_head3"),
            nickname: "游戏好友",
            content: "我今天又拿了五杀，牛逼不？",
            time: "15:38"
        },
        { headSrc: $r("app.media.ic_user_head4"),
            nickname: "同事小李",
            content: "领导，报给写好了，请过目",
            time: "14:12"
        },
        { headSrc: $r("app.media.ic_user_head5"),
            nickname: "HR小孙",
            content: "这个岗位还需要招两个人",
            time: "12:08"
        },
        { headSrc: $r("app.media.ic_user_head6"),
            nickname: "客户小潘",
            content: "这是我们公司的报价，希望您能考虑下",
            time: "昨天" },
        { headSrc: $r("app.media.ic_user_head7"),
            nickname: "老弟",
            content: "好的，哥",
            time: "周一" }
    ]

    build() {
        Column() {
            WechatToolbar({ title: "秘语(5)" })
            // 添加智能体入口作为特殊功能区
            Row() {
                Image($r("app.media.ic_ai_agent"))
                    .width(40)
                    .height(40)
                    .margin(10)
                Column() {
                    Text("我的智能体")
                        .fontSize(16)
                        .fontColor(Color.Black)
                    Text("AI助手随时为您服务")
                        .fontSize(12)
                        .fontColor('#666')
                }
                .layoutWeight(1)
            }
            .width('100%')
            .backgroundColor(Color.White)
            .padding(5)
            .onClick(() => {
                const agent = new AgentModel(
                    "https://www.coze.cn/store/agent/7528984685125861427?bot_id=true",
                    "我的智能体"
                );
                router.pushUrl({
                    url: 'pages/AgentPage/AgentPage',
                    params: agent
                })
            })


            List() {
                ForEach(this.chatList, (item: ChatItemData, index: number) => {
                    ListItem() {
                        ListChatItem({ data: item })
                    }
                    .onClick(() => {
                        if (item.nickname === "我的智能体") {
                            // 创建智能体对象
                            const agent = new AgentModel(
                                "https://www.coze.cn/store/agent/7528984685125861427?bot_id=true",
                                "我的智能体"
                            );

                            // 跳转到智能体页面
                            router.pushUrl({
                                url: 'pages/AgentPage/AgentPage',
                                params: agent
                            })
                        } else {
                            // 普通聊天跳转
                            router.pushUrl({
                                url: 'pages/chat/ChatPage',
                                params: {name:item.nickname}
                            })
                        }
                    })
                })
                ListItem() {
                    Divider().color('#0000').strokeWidth(0)
                }
            }
            .divider({ strokeWidth: 0.8, color: '#f0f0f0', startMargin: 90, endMargin: 0 }) // 每行之间的分界线
            .backgroundColor(Color.White)
            .width("100%")
            .height("100%")

        }
        .width("100%")
        .height("100%")
        .backgroundColor("#f0f0f0")
    }
}
