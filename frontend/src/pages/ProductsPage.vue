<script setup>
const products = [
  ['玻璃激光切割系统', '适用于盖板玻璃、车载玻璃与光学玻璃的高精度切割。'],
  ['玻璃钻孔与开槽设备', '面向摄像孔、传感器窗口和异形槽口的稳定加工。'],
  ['微裂纹控制工艺包', '通过参数库与视觉定位降低崩边、烧蚀和热影响。'],
  ['智能仓储周转单元', '为玻璃片材提供洁净、可追溯的暂存与转运能力。'],
]
</script>

<template>
  <main class="page-main">
    <section class="page-hero">
      <p class="section-kicker">PRODUCT CENTER</p>
      <h1>产品中心</h1>
      <p>围绕玻璃加工前后段，提供设备、工艺包和仓储单元的组合式交付。</p>
    </section>
    <section class="section">
      <div class="product-grid">
        <article v-for="product in products" :key="product[0]" class="product-card">
          <span></span>
          <h3>{{ product[0] }}</h3>
          <p>{{ product[1] }}</p>
        </article>
      </div>
    </section>
  </main>
</template>
