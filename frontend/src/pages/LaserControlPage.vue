<script setup>
import { computed, ref } from 'vue'

const activePanel = ref('home')
const menuItems = [
  ['home', '主页'],
  ['stage', '位移台'],
  ['camera', '相机'],
  ['gcode', 'GCode'],
]

// 🌟 1. ACS 控制器连接状态与触发事件
const isAcsConnected = ref(false)
const acsStatusMessage = ref('ACS 控制器未连接')
const isAcsLoading = ref(false)
const isAxis0Enabled = ref(false)
const isAxisEnableLoading = ref(false)

const readJsonResponse = async (response) => {
  const text = await response.text()

  if (!text) {
    return {
      message: `ACS Bridge 返回空响应，HTTP 状态码：${response.status}`,
    }
  }

  try {
    return JSON.parse(text)
  } catch {
    return {
      message: text,
    }
  }
}

const handleConnectACS = async () => {
  if (isAcsLoading.value) return

  isAcsLoading.value = true

  try {
    const endpoint = isAcsConnected.value ? 'disconnect' : 'connect'
    const response = await fetch(`http://127.0.0.1:5055/api/acs/${endpoint}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: endpoint === 'connect'
        ? JSON.stringify({ mode: 0, ip: '10.0.0.100', port: 701 })
        : undefined,
    })
    const result = await readJsonResponse(response)

    if (!response.ok) {
      throw new Error(result.message || `ACS 请求失败，HTTP 状态码：${response.status}`)
    }

    isAcsConnected.value = Boolean(result.connected)
    if (!isAcsConnected.value) {
      isAxis0Enabled.value = false
    }
    acsStatusMessage.value = result.message || (result.connected ? 'ACS 控制器连接成功' : 'ACS 控制器未连接')
    alert(acsStatusMessage.value)
  } catch (error) {
    isAcsConnected.value = false
    acsStatusMessage.value = error.message || 'ACS Bridge 未启动或连接失败'
    alert(acsStatusMessage.value)
  } finally {
    isAcsLoading.value = false
  }
}

const handleToggleAxis0Enable = async () => {
  if (isAxisEnableLoading.value) return

  if (!isAcsConnected.value) {
    alert('请先连接 ACS 控制器')
    return
  }

  isAxisEnableLoading.value = true

  try {
    const response = await fetch('http://127.0.0.1:5055/api/acs/axis/0/enable-toggle', {
      method: 'POST',
    })
    const result = await readJsonResponse(response)

    if (!response.ok || !result.success) {
      throw new Error(result.message || `0 号轴使能切换失败，HTTP 状态码：${response.status}`)
    }

    isAcsConnected.value = Boolean(result.connected)
    isAxis0Enabled.value = Boolean(result.enabled)
    acsStatusMessage.value = result.message
    alert(result.message)
  } catch (error) {
    acsStatusMessage.value = error.message || '0 号轴使能切换失败'
    alert(acsStatusMessage.value)
  } finally {
    isAxisEnableLoading.value = false
  }
}

// 脚本管理状态
const activeTab = ref('Main.txt')
const scriptList = ref(['test.ascript', 'NewScript_3.txt'])
const scriptCounter = ref(1)
const codeContent = ref('// 在这里编写指令或 GCode 脚本\n')

const handleCreateScript = () => {
  const defaultName = `NewScript_${scriptCounter.value}.txt`
  const inputName = prompt('请输入新脚本文件名：', defaultName)

  if (inputName && inputName.trim() !== '') {
    const fileName = inputName.trim()
    if (!scriptList.value.includes(fileName)) {
      scriptList.value.push(fileName)
    }
    activeTab.value = fileName
    codeContent.value = `// ===== ${fileName} =====\n// 创建时间: ${new Date().toLocaleString()}\n`
    scriptCounter.value++
  }
}

const statusTime = computed(() => {
  if (activePanel.value === 'stage') return '2026-07-20 19:40:51'
  if (activePanel.value === 'camera') return '2026-07-20 19:41:26'
  if (activePanel.value === 'gcode') return '2026-07-20 19:41:48'
  return '2026-07-20 19:37:08'
})
</script>

<template>
  <main class="software-page">
    <div class="software-window">
      <aside class="software-sidebar">
        <div class="software-logo">
          <div class="logo-disc"></div>
          <strong>YIOTTA</strong>
          <span>一尧科技</span>
        </div>
        <nav class="software-menu">
          <button
            v-for="item in menuItems"
            :key="item[0]"
            type="button"
            :class="{ active: activePanel === item[0] }"
            @click="activePanel = item[0]"
          >
            {{ item[1] }}
          </button>
        </nav>
        <div class="gear">⚙</div>
      </aside>

      <section class="software-app">
        <!-- 🌟 2. 页面顶部标题栏中添加“连接ACS”按钮 -->
        <header class="software-titlebar">
          <div class="titlebar-left">
            <span>一尧科技&nbsp;&nbsp;|&nbsp;&nbsp;飞秒激光控制系统</span>

            <button
              type="button"
              class="acs-btn"
              :class="{ connected: isAcsConnected }"
              @click="handleConnectACS"
              :disabled="isAcsLoading"
            >
              {{ isAcsLoading ? '连接中...' : isAcsConnected ? '● ACS已连接' : '🔌 连接ACS' }}
            </button>
            <button
              type="button"
              class="enable-btn"
              :class="{ enabled: isAxis0Enabled }"
              :disabled="!isAcsConnected || isAxisEnableLoading"
              @click="handleToggleAxis0Enable"
            >
              {{ isAxisEnableLoading ? '处理中...' : isAxis0Enabled ? '● 0轴已使能' : '使能' }}
            </button>
          </div>

          <div class="window-controls">
            <span>一</span>
            <span>□</span>
            <button>×</button>
          </div>
        </header>

        <!-- 主页工作区 -->
        <div v-if="activePanel === 'home'" class="software-workspace">
          <aside class="command-panel">
            <h2>指令列表</h2>
            <section>
              <h3>▸ 逻辑语句</h3>
              <a>if判断</a>
              <a>for循环</a>
              <a>等待</a>
              <a>打印</a>
            </section>
            <section>
              <h3>▸ 位移台</h3>
              <a>获取位置</a>
              <a>设置位置</a>
              <a>设置速度</a>
              <a>加减速度设置</a>
              <a>相对位移</a>
              <a>绝对位移</a>
              <a>相对转动</a>
              <a>绝对转动</a>
              <a>修改Buffer参数</a>
              <a>运行Buffer</a>
              <a>写字</a>
              <a>DAC信号发送</a>
              <a>DAC Excel</a>
            </section>
            <section>
              <h3>▸ 激光器</h3>
              <a>开启</a>
            </section>
          </aside>

          <section class="editor-panel">
            <div class="toolbar">
              <button @click="handleCreateScript">+ 新建脚本</button>
              <button><span class="play">▶</span> 运行</button>
              <button><span class="stop">■</span> 停止</button>
              <button>▣ 代码库</button>
              <button>◎ 预览</button>
              <button>▱ 摇杆</button>
            </div>
            <div class="editor-tab">{{ activeTab }} <span>×</span></div>
            <div class="code-editor">
              <div class="line-number">1</div>
              <pre>{{ codeContent }}</pre>
            </div>
            <div class="log-panel">
              <div class="log-title">输出 / Log <span>× 清空</span></div>
              <p>
                19:37:08 [INFO]：{{ acsStatusMessage }}
              </p>
              <div class="timer">⌚ 已耗时:<br /><strong>00:00:00</strong></div>
            </div>
          </section>

          <aside class="device-panel">
            <table>
              <thead><tr><th>轴名称</th><th>使能</th><th>速度</th><th>位置</th></tr></thead>
              <tbody>
                <tr><td>X</td><td><span :class="{ on: isAxis0Enabled }">{{ isAxis0Enabled ? 'ON' : 'OFF' }}</span></td><td>0.1</td><td>0.0000</td></tr>
                <tr><td>Y</td><td><span>OFF</span></td><td>0.1</td><td>1.0673</td></tr>
                <tr><td>Z</td><td><span>OFF</span></td><td>0.1</td><td>0.0000</td></tr>
                <tr><td>ACS_Axis_3</td><td><span>OFF</span></td><td>10</td><td>0.0000</td></tr>
              </tbody>
            </table>
            <div class="graphics-panel">
              <div class="graphics-tools">
                <span>图元数量: 0</span>
                <button>X→</button>
                <button>Y↓</button>
                <button>清空</button>
              </div>
            </div>
            <div class="blank-panel"></div>
          </aside>
        </div>

        <!-- 位移台工作区 -->
        <div v-else-if="activePanel === 'stage'" class="stage-workspace">
          <aside class="stage-settings">
            <h2>控制器设置</h2>
            <p>控制卡类型</p>
            <button>正运动 (ZMC)</button>
            <button class="selected">ACS (EtherCAT)</button>
            <button>Aerotech</button>
            <div class="radio-row">连接模式: <span>◉ 模拟器</span><span>○ 网络</span></div>
            <p>通信参数</p>
            <div class="comm-box">
              <span>通信状态 <strong>{{ isAcsConnected ? '● 已连接' : '○ 未连接' }}</strong></span>
              <span>0号轴状态 <strong>{{ isAxis0Enabled ? '● 已使能' : '○ 未使能' }}</strong></span>
              <div>
                <button :disabled="isAcsConnected" @click="handleConnectACS">连接</button>
                <button :disabled="!isAcsConnected" @click="handleConnectACS">断开</button>
              </div>
            </div>
          </aside>

          <section class="stage-main">
            <div class="axis-map">
              <strong>ACS物理轴号映射</strong>
              <div><span>X轴<br />0</span><span>Y轴<br />1</span><span>Z轴<br />2</span></div>
              <button>+ 添加轴</button>
              <button class="excel">DAC Excel表格</button>
            </div>
            <div class="axis-cards">
              <article v-for="axis in ['X', 'Y', 'Z']" :key="axis" class="axis-card">
                <header><h3>{{ axis }}</h3><button>{{ axis === 'X' && isAxis0Enabled ? 'Enabled' : 'Enable' }}</button><i>×</i></header>
                <div class="axis-id">ID: <u>{{ axis === 'X' ? '0' : axis === 'Y' ? '1' : '2' }}</u><button>⌂ Home</button><span>{{ axis === 'X' ? '1' : axis === 'Y' ? '2' : '3' }}</span></div>
                <div class="feedback"><small>Feedback Position</small><strong>{{ axis === 'Y' ? '1.0673' : '0.0000' }}</strong><em>0</em></div>
                <div class="axis-inputs"><label>速度 (mm/s):<input value="0.1" /></label><label>目标位置:<input value="10.000" /></label></div>
                <div class="axis-buttons"><button>相对运动</button><button>绝对运动</button><button>Jog -</button><button>Jog +</button></div>
                <button class="stop-btn">STOP</button>
              </article>
            </div>
            <div class="buffer-panel">
              <header><strong>ACS Buffer（缓冲区）快速设置</strong><button>+ 新增</button></header>
              <table>
                <thead><tr><th>描述</th><th>Buffer ID</th><th>Function Name</th><th>执行</th><th>停止</th></tr></thead>
                <tbody>
                  <tr><td>2</td><td>1</td><td></td><td><button>执行</button></td><td><button>停止</button></td></tr>
                  <tr><td></td><td>1</td><td>test1</td><td><button>执行</button></td><td><button>停止</button></td></tr>
                  <tr><td></td><td>-1</td><td></td><td><button>执行</button></td><td><button>停止</button></td></tr>
                </tbody>
              </table>
            </div>
          </section>
        </div>

        <!-- 相机工作区 -->
        <div v-else-if="activePanel === 'camera'" class="camera-workspace">
          <aside class="camera-select">
            <fieldset>
              <legend>相机选择</legend>
              <label>◉ 迈德威视 (Mind)</label>
              <label>○ 海康威视 (Hikvis)</label>
            </fieldset>
          </aside>
          <section class="camera-view">等待相机连接...</section>
          <aside class="camera-control">
            <h2>相机显控面板</h2>
            <fieldset>
              <legend>连接状态</legend>
              <div class="connect-row"><button>连接相机</button><button>断开连接</button></div>
              <p>状态: 未连接</p>
            </fieldset>
            <div class="camera-tabs"><button>⚙ 参数设置</button><button>ϟ 触发模式</button></div>
            <fieldset>
              <legend>图像抓取</legend>
              <button>📷 拍照保存</button>
              <button class="red">🔗 极限拍照 (1秒连拍)</button>
              <button>📂 打开文件夹</button>
              <p>路径: F:\project\c#\2026\LC_WPF2026\LC_WPF2026\bin\Debug\net8.0-windows\Photos\20260720_194048</p>
            </fieldset>
            <fieldset class="camera-log">
              <legend>相机日志</legend>
              <span>🗑</span>
            </fieldset>
          </aside>
        </div>

        <!-- GCode 工作区 -->
        <div v-else class="gcode-workspace">
          <aside class="script-list">
            <h2>▣ 脚本文件列表</h2>
            <div class="script-box">
              <p
                v-for="file in scriptList"
                :key="file"
                :style="{ cursor: 'pointer', fontWeight: activeTab === file ? 'bold' : 'normal' }"
                @click="activeTab = file"
              >
                📄 {{ file }}
              </p>
            </div>
            <button @click="handleCreateScript">✚ 添加脚本文件</button>
          </aside>
          <section class="gcode-editor">
            <div class="toolbar">
              <button @click="handleCreateScript">+ 新建脚本</button>
              <button><span class="play">▶</span> 开始</button>
              <button>Ⅱ 暂停</button>
              <button>▶Ⅱ 继续</button>
              <button><span class="stop">■</span> 停止</button>
              <button>▱ 摇杆</button>
            </div>
            <div class="editor-tab">{{ activeTab }} <span>×</span></div>
            <div class="code-area">
              <pre>{{ codeContent }}</pre>
            </div>
          </section>
        </div>

        <!-- 🌟 3. 页脚同步状态 -->
        <footer class="software-statusbar">
          <span><i></i> 系统就绪</span>
          <span>{{ acsStatusMessage }}</span>
          <strong>授权状态：已激活（永久）</strong>
          <span>V 2.0.26&nbsp;&nbsp; {{ statusTime }}</span>
        </footer>
      </section>
    </div>
  </main>
</template>

<style scoped>
/* 顶栏与按钮样式 */
.titlebar-left {
  display: flex;
  align-items: center;
  gap: 16px;
}

.acs-btn {
  padding: 2px 10px;
  font-size: 12px;
  border-radius: 4px;
  border: 1px solid #1890ff;
  background-color: #1890ff;
  color: #fff;
  cursor: pointer;
  transition: all 0.2s ease;
}

.acs-btn:hover {
  opacity: 0.85;
}

/* 连接成功后的样式 */
.acs-btn.connected {
  background-color: #52c41a;
  border-color: #52c41a;
}
</style>
