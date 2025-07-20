import { SwiperModel } from "../model/SwiperModel"
import { promptAction } from "@kit.ArkUI"
import { ClassifyModel } from "../model/ClassifyModel"
import { AgentModel } from "../model/AgentModel"
import { AgentCardComponent } from "./AgentCardComponent"
import { getAgents, getClassify } from "../commons/API"

@Component
export struct DiscoveryComponent {
  // 轮播图数据
  @State swiperModels:SwiperModel [] = [
    {
      id:1,
      image:"https://img95.699pic.com/xsj/1h/sz/f5.jpg",
      index:1
    },
    {
      id:2,
      image:"https://bkimg.cdn.bcebos.com/pic/90cebeec86f1dc00269791ee",
      index:2
    },
    {
      id:3,
      image:"https://bkimg.cdn.bcebos.com/pic/5fdf8db1cb1349548c0bc413544e9258d1094aab",
      index:3
    },
  ]

  // 分类数据
  @State classifys:ClassifyModel[] = [
    {
      id:1,
      name:"AI工具",
      image:$r("app.media.AI_Tool")
    },

    {
      id:2,
      name:"效率办公",
      image:$r("app.media.work")
    },

    {
      id:3,
      name:"休闲娱乐",
      image:$r("app.media.Entertainment")
    },

    {
      id:4,
      name:"教育学习",
      image:$r("app.media.Study")
    },

    {
      id:5,
      name:"生活服务",
      image:$r("app.media.Life_Services")
    },


  ]

  @State page:number = 1 // 当前显示的第几页的数据

  /**
   * 组件创建的时候会执行一次
   */
  aboutToAppear(): void {
    getClassify().then((result)=>{
      if (result.code == 200){
        this.classifys = result.data as ClassifyModel[]
      } else {
        promptAction.showToast({message:result.message})
      }
    }).catch((err:string)=>{
      promptAction.showToast({message:err})
    })
    getAgents(this.page,this.currentSelectedClassify).then((result)=>{
      if (result.code == 200){
        this.agents = result.data as AgentModel[]
      }
    })

  }

  // 推荐智能体数据
  @State agents:AgentModel[] = [
    {
      id:1,
      name:"AI工具",
      descs:"智能助手AI工具.",
      ratio:3.8,
      downloadCount:10000,
      icon:$r('app.media.startIcon'),
      classify:this.classifys[0]
    },
    {
      id:2,
      name:"效率办公",
      descs:"智能助手效率办公",
      ratio:3.8,
      downloadCount:10000,
      icon:$r('app.media.startIcon'),
      classify:this.classifys[1]
    },
    {
      id:3,
      name:"休闲娱乐",
      descs:"智能助手休闲娱乐",
      ratio:3.8,
      downloadCount:10000,
      icon:$r('app.media.startIcon'),
      classify:this.classifys[2]
    },
    {
      id:4,
      name:"教育学习",
      descs:"智能助手教育学习",
      ratio:3.8,
      downloadCount:10000,
      icon:$r('app.media.startIcon'),
      classify:this.classifys[3]
    },
    {
      id:5,
      name:"生活服务",
      descs:"智能助手生活服务",
      ratio:3.8,
      downloadCount:10000,
      icon:$r('app.media.startIcon'),
      classify:this.classifys[4]
    },
    {
      id:6,
      name:"智能助手",
      descs:"智能助手.智能助手.智能助手.智能助手.智能助手.智能助手.智能助手.智能助手.智能助手.",
      ratio:3.8,
      downloadCount:10000,
      icon:$r('app.media.startIcon'),
      classify:this.classifys[4]
    },
    {
      id:7,
      name:"智能助手",
      descs:"智能助手.智能助手.智能助手.智能助手.智能助手.智能助手.智能助手.智能助手.智能助手.",
      ratio:3.8,
      downloadCount:10000,
      icon:$r('app.media.startIcon'),
      classify:this.classifys[4]
    },
  ]

  @State currentSelectedClassify:number = 0

  build() {
    Column({space:10}){
      Row(){
        Search({placeholder:"搜索应用"}).width('100%')
      }.width('100%')
      Swiper(){
        ForEach(this.swiperModels,(item:SwiperModel,index:number)=>{
          Image(item.image)
            .width('100%')
            .aspectRatio(2 / 1) //设置宽高比
            .onClick(()=>{
              promptAction.showToast({message:`点击了id为${item.id}的第${item.index}张图片`})
            })
        })
      }.width('100%')
      .autoPlay(true)
      Row(){
        // ForEach() // 循环每一项
        List(){
          ForEach(this.classifys,(item:ClassifyModel,index:number)=>{
            ListItem(){
              Column({space:5}){
                Image(item.image).width(40).height(40).fillColor(Color.Blue)
                Text(item.name).fontSize(15)
              }.height(70).width(70)
              .backgroundColor(this.currentSelectedClassify == item.id ? "#e3e3e3" : "#fff")
              .onClick(()=>{
                this.currentSelectedClassify = item.id!
                getAgents(this.page,this.currentSelectedClassify).then((result)=>{
                  if (result.code == 200){
                    this.agents = result.data as AgentModel[]
                  }
                })
              })
            }
          })
        }.listDirection(Axis.Horizontal)
        .width('100%')
        .height(70)
      }
      Row(){
        Text('热门推荐').fontWeight(700).fontSize(20)
        Text('查看全部').fontColor(Color.Blue).fontSize(15)
      }.justifyContent(FlexAlign.SpaceBetween).width('100%')
      List(){
        ForEach(this.agents,(item:AgentModel,index:number)=>{
          if (this.currentSelectedClassify == 0){
            ListItem(){
              AgentCardComponent({agentModel:item})
            }
          } else if(this.currentSelectedClassify == item.classify?.id){
            ListItem(){
              AgentCardComponent({agentModel:item})
            }
          }
        })
      }
    }.width('100%')
    .height('100%')
    .padding(10) // 默认的单位是vp
  }
}