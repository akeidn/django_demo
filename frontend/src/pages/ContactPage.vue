<script setup>
import { reactive, ref } from 'vue'

const form = reactive({
  contact_name: '',
  contact_phone: '',
  company_brand: '',
  project_type: '',
  estimated_quantity: '',
  delivery_city: '',
  budget_range: '',
  requirement_description: '',
})

const statusMessage = ref('')
const isSubmitting = ref(false)
const isSuccess = ref(false)

async function submitContract() {
  isSubmitting.value = true
  statusMessage.value = ''
  isSuccess.value = false

  try {
    const response = await fetch('/api/contracts/', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(form),
    })
    const result = await response.json()

    if (!response.ok) {
      throw new Error(result.message || '提交失败，请稍后再试')
    }

    Object.keys(form).forEach((key) => {
      form[key] = ''
    })
    isSuccess.value = true
    statusMessage.value = result.message || '需求提交成功'
  } catch (error) {
    statusMessage.value = error.message || '提交失败，请稍后再试'
  } finally {
    isSubmitting.value = false
  }
}
</script>

<template>
  <main class="page-main">
    <section class="quote-hero">
      <p class="section-kicker">CONTACT</p>
      <h1>获取工厂报价与产品资料</h1>
      <p>
        填写项目需求后，我们会根据玻璃材质、数量、城市、预算和加工类型，给出更明确的产品建议与报价方向。
      </p>
    </section>

    <section class="quote-section">
      <form class="quote-form" @submit.prevent="submitContract">
        <div class="form-grid">
          <label>
            <span>联系人</span>
            <input v-model.trim="form.contact_name" type="text" placeholder="请输入联系人姓名" />
          </label>
          <label>
            <span>联系电话</span>
            <input v-model.trim="form.contact_phone" type="tel" placeholder="请输入手机或座机" />
          </label>
          <label>
            <span>公司 / 品牌</span>
            <input v-model.trim="form.company_brand" type="text" placeholder="请输入公司或品牌名称" />
          </label>
          <label>
            <span>项目类型</span>
            <select v-model="form.project_type">
              <option value="">请选择项目类型</option>
              <option>玻璃激光切割</option>
              <option>玻璃钻孔 / 开槽</option>
              <option>玻璃智能存储</option>
              <option>整线加工方案</option>
            </select>
          </label>
          <label>
            <span>预计数量</span>
            <input v-model.trim="form.estimated_quantity" type="text" placeholder="例如 30 套 / 120 件" />
          </label>
          <label>
            <span>交付城市</span>
            <input v-model.trim="form.delivery_city" type="text" placeholder="例如 武汉 / 上海 / 深圳" />
          </label>
          <label>
            <span>预算区间</span>
            <select v-model="form.budget_range">
              <option value="">请选择预算区间</option>
              <option>10 万以内</option>
              <option>10-50 万</option>
              <option>50-200 万</option>
              <option>200 万以上</option>
            </select>
          </label>
          <label class="full-field">
            <span>需求说明</span>
            <textarea
              v-model.trim="form.requirement_description"
              rows="6"
              placeholder="请描述玻璃尺寸、厚度、加工方式、精度要求、良率目标或存储周转需求"
            ></textarea>
          </label>
        </div>
        <div class="form-actions">
          <button type="submit" :disabled="isSubmitting">
            {{ isSubmitting ? '提交中...' : '提交需求' }}
          </button>
          <p v-if="statusMessage" :class="['form-message', { success: isSuccess }]">
            {{ statusMessage }}
          </p>
        </div>
      </form>

      <aside class="quote-aside">
        <div>
          <strong>业务邮箱</strong>
          <a href="mailto:1164796490@qq.com">1164796490@qq.com</a>
        </div>
        <div>
          <strong>服务对象</strong>
          <p>消费电子、车载显示、光学器件、医疗玻璃、玻璃深加工厂及高端制造客户。</p>
        </div>
        <div>
          <strong>沟通建议</strong>
          <p>带上玻璃材质、尺寸图、加工位置、数量、交期和目标预算，报价会更准确。</p>
        </div>
      </aside>
    </section>
  </main>
</template>
