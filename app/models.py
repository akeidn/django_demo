from django.db import models


class Contract(models.Model):
    contact_name = models.CharField('联系人', max_length=50)
    contact_phone = models.CharField('联系电话', max_length=50)
    company_brand = models.CharField('公司/品牌', max_length=120)
    project_type = models.CharField('项目类型', max_length=80)
    estimated_quantity = models.CharField('预计数量', max_length=80)
    delivery_city = models.CharField('交付城市', max_length=80)
    budget_range = models.CharField('预算区间', max_length=80)
    requirement_description = models.TextField('需求说明')

    class Meta:
        db_table = '合同'
        verbose_name = '联系表单'
        verbose_name_plural = '联系表单'

    def __str__(self):
        return f'{self.contact_name} - {self.company_brand}'
