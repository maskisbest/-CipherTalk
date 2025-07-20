import { AgentModel } from '../pages/model/AgentModel';
import http from '@ohos.net.http';
import zlib from '@ohos.zlib';

interface CozeMessage {
  role: string;
  content: string;
  content_type: string;
}

interface messageBox {
  role: string;
  content: string;
  content_type: string;
}

interface CozePostResponseMessage {
  id: string;
  conversation_id: string;
  bot_id: string;
  created_at: number;
}

interface ParsedObject {
  tool_output_content?: string;
  content?: string;
  data?: string | object;
}

interface CozePostResponse {
  data: CozePostResponseMessage;
  code: number;
  msg: string;
}

interface CozeGetResponseMessage {
  content: string;
  type: string;
}

interface CozeGetResponse {
  code: number;
  msg: string;
  data: CozeGetResponseMessage[];
}


// 会话管理类
class AgentManager {
  private static conversationId: string | null = null;
  private static chatId: string | null = null;

  // 获取当前会话ID
  static getConversationId(): string | null {
    return AgentManager.conversationId
  }

  // 更新会话ID
  static updateConversationId(newId: string) {
    AgentManager.conversationId = newId;
  }

  // 获取当前会话ID
  static getChatId(): string | null {
    return AgentManager.chatId
  }

  // 更新会话ID
  static updateChatId(newId: string) {
    AgentManager.chatId = newId;
  }

  // 重置会话
  // static resetConversation() {
  //   ConversationManager.conversationId = null;
  // }
}

interface requestInterface {
  bot_id: string;
  user_id: string;
  stream: boolean;
  auto_save_history: boolean;
  additional_messages: CozeMessage[];
}

export class AgentUtil {



  // 发送聊天记录到智能体
  static async sendToAgent(agent: AgentModel, chatHistory: string, userid: string): Promise<string> {
    // 基础API URL
    let createChatUrl = "https://api.coze.cn/v3/chat";
    let getMessageUrl = "https://api.coze.cn/v3/chat/message/list";

    // 如果存在会话ID，添加到URL参数
    let conversationId = AgentManager.getConversationId();
    let chatId = AgentManager.getChatId();
    // if (conversationId) {
    //   apiUrl += `?conversation_id=${conversationId}`;
    // }

    const authToken = "pat_xFWBg3vzkm7QZXq2m5tbGqUkqjtfGccLEJ8KhgFSB27BNSTa71KHtIITseNi7ItH";

    // 构建符合Coze API要求的消息格式
    const messages: CozeMessage[] = [
      {
        role: "user",
        content: chatHistory,
        content_type: "text"
      }
    ];

    if (conversationId === null || chatId === null) {
      const requestBody: requestInterface = {
        bot_id: "7528984685125861427",
        user_id: userid, // 使用固定用户ID或动态生成
        stream: false, // 非流式响应
        auto_save_history: true,
        additional_messages: messages
      };

      try {
        // 创建HTTP请求
        let httpRequest = http.createHttp();
        console.info("发送请求到Coze API:", JSON.stringify(requestBody, null, 2));

        let response = await httpRequest.request(
          createChatUrl,
          {
            method: http.RequestMethod.POST,
            header: {
              'Content-Type': 'application/json',
              'Authorization': `Bearer ${authToken}`
            },
            extraData: JSON.stringify(requestBody)
          }
        );

        const rawResponse = response.result.toString();
        console.log(rawResponse)
        if (response.responseCode === 200) {
          const result: CozePostResponse = JSON.parse(rawResponse);
          if (result.data.conversation_id) {
            AgentManager.updateConversationId(result.data.conversation_id);
            AgentManager.updateChatId(result.data.id);
            console.info(`更新会话ID: ${result.data.conversation_id}`);
            console.info(`更新会话ID: ${result.data.id}`);
          }
        }
      } catch (error) {
        console.error("API请求失败:", JSON.stringify(error, Object.getOwnPropertyNames(error)));
        return "网络请求失败1";
      }
    }



    conversationId = AgentManager.getConversationId();
    chatId = AgentManager.getChatId();

    try {
      while (true) {
        let httpRequest = http.createHttp();


        console.log(getMessageUrl + "?chat_id=" + chatId + "&conversation_id=" + conversationId)
        let response = await httpRequest.request(
          // getMessageUrl + "?chat_id=" + chatId + "&conversation_id=" + conversationId,
          // 临时测试：直接使用 curl 成功的参数
          `https://api.coze.cn/v3/chat/message/list?chat_id=7529130223305244726&conversation_id=7529130223305228342`,
          // `https://api.coze.cn/v3/chat/message/list?chat_id=7529119863063855154&conversation_id=7529119863063838770`,
          {
            method: http.RequestMethod.GET,
            header: {
              'Content-Type': 'application/json',
              'Authorization': `Bearer ${authToken}`,
              // 'Accept-Encoding': 'gzip'
            }
          }
        )

        // const rawResponse = response.result.toString();
        // console.log("2:" + rawResponse)

        if (response.responseCode === 200) {
          const rawResponse = response.result.toString();
          console.log("Full response:", rawResponse);

          const result: CozeGetResponse = JSON.parse(rawResponse);
          // const answerItem = result.data.find((item: CozeGetResponseMessage) => item.type === "answer" && item.content);
          // return answerItem ? answerItem.content : "没有找到答案";
          const answerItem = result.data.find(
            (item: CozeGetResponseMessage) => item.type === "answer" && item.content
          );
          if (answerItem) {
            // 处理转义字符
            const decodedContent = AgentUtil.decodeEscapedString(answerItem.content);
            return decodedContent;
          }
          return "没有找到答案";

        }
      }
    } catch (error) {
        console.error("API请求失败:", JSON.stringify(error, Object.getOwnPropertyNames(error)));
        return "网络请求失败2";
      }


    return "发生了一点错误。。"
  }
  // 解码转义字符串
  private static decodeEscapedString(str: string): string {
    // 处理常见的转义序列
    let decoded: string = str
      .replace(/\\n/g, '\n')     // 换行符
      .replace(/\\r/g, '\r')     // 回车符
      .replace(/\\t/g, '\t')     // 制表符
      .replace(/\\"/g, '"')      // 双引号
      .replace(/\\\\/g, '\\');   // 反斜杠

    // 尝试解析可能的嵌套 JSON
    if (decoded.startsWith('{') || decoded.startsWith('[')) {
      try {
        const parsed: ParsedObject = JSON.parse(decoded);
        // 如果解析后是对象，尝试提取有用信息

        return parsed.tool_output_content ??
        parsed.content ??
          (typeof parsed.data === 'string' ? parsed.data : JSON.stringify(parsed.data)) ??
        JSON.stringify(parsed);
        // return decoded;
      } catch (e) {
        console.warn("嵌套JSON解析失败，返回原始内容");
        return decoded;
      }
    }

    return decoded;
  }
}
// zhousir@qq.com