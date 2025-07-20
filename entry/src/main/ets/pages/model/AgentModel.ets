import { ClassifyModel } from "./ClassifyModel"

export class AgentModel {
  id?: number
  icon?: ResourceStr
  name?: string
  descs?: string
  ratio?: number
  downloadCount?: number
  classify?: ClassifyModel
  url?: string

  // 添加构造函数
  constructor(url?: string, name?: string) {
    this.url = url;
    this.name = name;
  }
}