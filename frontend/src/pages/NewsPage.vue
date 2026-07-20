<script setup>
const news = [
  ['一尧科技完成玻璃激光工艺数据库升级', '2026-07-18', '新增多类玻璃厚度与切割轨迹参数，提升打样效率。'],
  ['面向车载显示的新一代异形切割方案发布', '2026-06-26', '针对大尺寸与复杂轮廓玻璃优化路径和边缘质量。'],
  ['激光冷加工在高端玻璃制造中的应用趋势', '2026-05-12', '解析低热影响加工在消费电子与光学器件中的价值。'],
]
</script>

<template>
  <main class="page-main">
    <section class="page-hero">
      <p class="section-kicker">NEWS</p>
      <h1>新闻资讯</h1>
      <p>关注玻璃激光加工、智能制造和高端装备行业动态。</p>
    </section>
    <section class="section">
      <div class="news-list">
        <article v-for="item in news" :key="item[0]">
          <time>{{ item[1] }}</time>
          <h3>{{ item[0] }}</h3>
          <p>{{ item[2] }}</p>
          <RouterLink to="/contact">了解详情</RouterLink>
        </article>
      </div>
    </section>
  </main>
</template>
