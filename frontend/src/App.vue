<template>
  <header class="site-header">
    <RouterLink class="brand" to="/">
      <span class="brand-mark">Y</span>
      <span>
        <strong>武汉一尧科技有限公司</strong>
        <small>YIYAO TECHNOLOGY</small>
      </span>
    </RouterLink>
    <nav class="nav">
      <RouterLink to="/">首页</RouterLink>
      <RouterLink to="/products">产品中心</RouterLink>
      <RouterLink to="/solutions">解决方案</RouterLink>
      <RouterLink to="/news">新闻资讯</RouterLink>
      <RouterLink to="/downloads">下载中心</RouterLink>
      <RouterLink to="/contact">联系我们</RouterLink>
      <RouterLink to="/laser-control">激光加工控制软件</RouterLink>
    </nav>
  </header>

  <RouterView />
</template>
