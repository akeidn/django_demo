<script setup>
const solutions = [
  ['消费电子玻璃', '覆盖手机盖板、平板面板、摄像头保护片等精密加工场景。'],
  ['车载显示玻璃', '支持大尺寸、曲面与异形车载玻璃的切割、开孔和检测。'],
  ['光学与医疗玻璃', '满足高洁净、高一致性和低损伤的微细加工要求。'],
  ['玻璃存储与追溯', '通过洁净料架、批次编码和周转记录减少搬运损耗。'],
]
</script>

<template>
  <main class="page-main">
    <section class="page-hero">
      <p class="section-kicker">SOLUTION</p>
      <h1>解决方案</h1>
      <p>以玻璃材料特性、产品节拍和良率目标为起点，建立从样品验证到量产联调的完整路径。</p>
    </section>
    <section class="section split-section">
      <div>
        <h2>从样品到量产的工程化交付</h2>
        <p>针对不同玻璃厚度、镀膜状态和边缘质量要求，配置激光参数、运动平台、视觉定位与存储单元。</p>
      </div>
      <div class="solution-list">
        <article v-for="solution in solutions" :key="solution[0]">
          <h3>{{ solution[0] }}</h3>
          <p>{{ solution[1] }}</p>
        </article>
      </div>
    </section>
  </main>
</template>
