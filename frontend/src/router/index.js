import { createRouter, createWebHistory } from 'vue-router'
import HomePage from '../pages/HomePage.vue'
import ProductsPage from '../pages/ProductsPage.vue'
import SolutionsPage from '../pages/SolutionsPage.vue'
import NewsPage from '../pages/NewsPage.vue'
import DownloadsPage from '../pages/DownloadsPage.vue'
import ContactPage from '../pages/ContactPage.vue'
import LaserControlPage from '../pages/LaserControlPage.vue'

const routes = [
  { path: '/', name: 'home', component: HomePage },
  { path: '/products', name: 'products', component: ProductsPage },
  { path: '/solutions', name: 'solutions', component: SolutionsPage },
  { path: '/news', name: 'news', component: NewsPage },
  { path: '/downloads', name: 'downloads', component: DownloadsPage },
  { path: '/contact', name: 'contact', component: ContactPage },
  { path: '/laser-control', name: 'laser-control', component: LaserControlPage },
]

export default createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior() {
    return { top: 0 }
  },
})
