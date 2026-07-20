<script setup>
const downloads = ['企业介绍册', '玻璃激光加工白皮书', '设备选型表', '售后服务手册', '工艺评估表', '洁净存储方案书']
</script>

<template>
  <main class="page-main">
    <section class="page-hero">
      <p class="section-kicker">DOWNLOAD</p>
      <h1>下载中心</h1>
      <p>获取企业资料、工艺介绍、设备选型和服务文档。</p>
    </section>
    <section class="section download-section">
      <div>
        <h2>资料申请</h2>
        <p>如需正式版资料、图纸模板或设备参数清单，请联系一尧科技销售与工艺团队。</p>
      </div>
      <div class="download-grid">
        <RouterLink v-for="file in downloads" :key="file" to="/contact">{{ file }}</RouterLink>
      </div>
    </section>
  </main>
</template>
