import { OperationType, SubHeader } from "@ohos.arkui.advanced.SubHeader"
import { promptAction } from "@kit.ArkUI"
import { ClassifyModel } from "../model/ClassifyModel"

@Component
export struct  ClassifyComponent {

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
      name:"生活服务1",
      image:$r("app.media.Life_Services")
    },

    {
      id:5,
      name:"生活服务2",
      image:$r("app.media.Life_Services")
    },

    {
      id:5,
      name:"生活服务3",
      image:$r("app.media.Life_Services")
    },

    {
      id:5,
      name:"生活服务4",
      image:$r("app.media.Life_Services")
    },

    {
      id:5,
      name:"生活服务",
      image:$r("app.media.Life_Services")
    },

    {
      id:5,
      name:"生活服务5",
      image:$r("app.media.Life_Services")
    },

    {
      id:5,
      name:"生活服务6",
      image:$r("app.media.Life_Services")
    },

    {
      id:5,
      name:"生活服务7",
      image:$r("app.media.Life_Services")
    },

    {
      id:5,
      name:"生活服务8",
      image:$r("app.media.Life_Services")
    },

  ]

  scroller:Scroller = new Scroller();
  @State currentSelectedClassify:string = ""
  build() {
    Column(){
      SubHeader({
        primaryTitle:"分类",
        operationType:OperationType.ICON_GROUP,
        operationItem:[
          {
            value:$r('app.media.search'),
            action:()=>{
              promptAction.showToast({message:"点击了搜索图标"})
            }
          }
        ]

      }) .border({width:{bottom:1},color:'#e3e3e3'})
      Row(){
        Scroll(this.scroller){
          Column({space:10}){
            ForEach(this.classifys,(item:ClassifyModel,index:number)=>{
              Column({space:5}){
                Image(item.image).width(40).height(40).fillColor(this.currentSelectedClassify == item.name ? Color.Blue:"#e3e3e3")
                Text(item.name).fontSize(15).fontColor(this.currentSelectedClassify == item.name ? Color.Blue:"#e3e3e3")
              }.height(70).width('100%').padding(5)
              .backgroundColor(this.currentSelectedClassify == item.name ? "#ffb5bfef" : "#fff")
              .border(this.currentSelectedClassify == item.name ? {width:{left:3},color:Color.Blue}:undefined)
              .onClick(()=>{
                this.currentSelectedClassify = item.name!

              })
            })
          }.width(100)
          .border({width:{right:1},color:'#e3e3e3'})
        }
      }.layoutWeight(1).width('100%')
    }.width('100%')
    .height('100%')
  }
}