import { ComposeTitleBar, OperationType, promptAction, router, SubHeader } from '@kit.ArkUI';
import { AgentModel } from '../model/AgentModel';
import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct AgentPage {
  agent?:AgentModel

  aboutToAppear(): void {
    this.agent = router.getParams() as AgentModel
    console.log(JSON.stringify(this.agent))
    console.log(this.agent?.url!)
    webview.WebviewController.initializeWebEngine()


  }

  controller:WebviewController = new webview.WebviewController()

  build() {
    Column() {
      ComposeTitleBar({
        title: "智能体",
      }).border({width:{bottom:1},color:'#e3e3e3'})
      Web({
        src: this.agent?.url!,
        controller:this.controller
      }).backgroundColor(Color.Gray)
        .width('100%')
        .layoutWeight(1)
        .domStorageAccess(true) // 开启了本地存储的权限
        .mixedMode(MixedMode.All) // 让web组件同时支持http和https协议

    }
    .height('100%')
    .width('100%')
  }
}