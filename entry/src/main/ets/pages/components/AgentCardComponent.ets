import { AgentModel } from "../model/AgentModel"
import { router } from "@kit.ArkUI"

@Component
export struct AgentCardComponent {

  // @Prop 表示当前这个属性值是从父组件传到子组件的  父组件的值改变后子组件也会改变 但是子组件的值改变父组件是不会变的
  // @Link 表示当前这个属性值是从父组件传到子组件的  父组件的值改变后子组件也会改变 但是子组件的值改变父组件是也会变的
  @Prop agentModel:AgentModel

  build() {
    Row({space:20}){
      Image(this.agentModel.icon).width(70)
      Column({space:5}){
        Row(){
          Text(this.agentModel.name).fontWeight(700).fontSize(20)
          Button("运行").type(ButtonType.Normal).borderRadius(5)
            .onClick(()=>{
              router.pushUrl({url:"pages/AgentPage",params:this.agentModel})
            })
        }.width('100%').justifyContent(FlexAlign.SpaceBetween)
        Row(){
          Text(this.agentModel.descs).maxLines(1).textOverflow({overflow:TextOverflow.Ellipsis}) // 最多显示一行，超出后显示省略号
            .fontColor(Color.Gray)
        }.width('100%')
        Row(){
          Rating({rating:this.agentModel.ratio,indicator:true}) // 设置分数不可变
          Text(`${this.agentModel.ratio?.toFixed(1)} | ${this.agentModel.downloadCount}次下载`)
        }.width('100%').justifyContent(FlexAlign.Start)
      }.layoutWeight(1) // 占用父组件剩下的所有空间
    }.width('100%')
    .height(100)
  }
}