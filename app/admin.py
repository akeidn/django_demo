from django.contrib import admin

from .models import Contract


@admin.register(Contract)
class ContractAdmin(admin.ModelAdmin):
    list_display = (
        'contact_name',
        'contact_phone',
        'company_brand',
        'project_type',
        'estimated_quantity',
        'delivery_city',
        'budget_range',
    )
    list_filter = ('project_type', 'budget_range', 'delivery_city')
    search_fields = (
        'contact_name',
        'contact_phone',
        'company_brand',
        'project_type',
        'delivery_city',
    )
    ordering = ('-id',)
