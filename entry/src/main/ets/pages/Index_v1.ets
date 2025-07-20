import { ClassifyComponent } from './components/ClassifyComponent';
import { DiscoveryComponent } from './components/DiscoveryComponent';
import { TabItemModel } from './model/TabItemModel';

/**
 * @XXX 称为装饰器 在鸿蒙中有很多的装饰器
 *  @Entry 表示当前是一个页面
 * @Component 表示当前是一个组件
 *  页面就是组件 组件不一定是页面
 * struct 是定义组件的关键字
 * Index组件的名称
 * 每一个组件中必须有build方法
 */
@Entry
@Component
struct Index {


  /**
   * @State 也是一个装饰器 主要是将装饰的变量变成一个响应式变量
   * 这里的响应式变量 就是数据和页面是绑定 的 数据改变了与之绑定的UI也会随之改变
   */
  @State tabItems:TabItemModel [] = [
    {
      icon: $r('app.media.disc'),
      name: "发现"
    },
    {
      icon: $r('app.media.classes'),
      name: "分类"
    },
    {
      icon: $r('app.media.mine'),
      name: "我的"
    },
  ]

  @Builder // @Builder 表示当前方法返回一个组件 不写return
  barItem(item:TabItemModel){
    Column(){
      Image(item.icon).width(30).height(30).fillColor(item.name == this.tabItems[this.currentIndex].name ? "#2563EB":"#AAAFBA")
      Text(item.name).fontColor(item.name == this.tabItems[this.currentIndex].name ? "#2563EB":"#AAAFBA")
    }
  }

  @State currentIndex:number = 0

  /**
   * 这个方法决定了组件长什么样子
   * build方法中只能有一个节点，不能包含多个节点
   */
  build() {
    // 弹性盒子 Flex  Column 默认为主轴是从上往下的弹性盒子 Row 主轴就是从左往右的弹性盒子
    Column(){ // 容器组件，里面可以包含多个组件
      // 导航组件
      Tabs({barPosition:BarPosition.End}) {// 导航组件
        ForEach(this.tabItems,(item:TabItemModel,index:number)=>{
          TabContent(){
            if (item.name == "发现"){
              DiscoveryComponent()
            } else if (item.name == "分类"){
              ClassifyComponent()
            }else {
              Text(item.name)
            }
          }.tabBar(this.barItem(item))
        })

      }.vertical(false)
      .onChange(index=>this.currentIndex = index)
    }.width('100%')
    .height('100%')
  }
}