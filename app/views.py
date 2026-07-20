import json

from django.conf import settings
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods

from .models import Contract


def frontend(request):
    index_path = settings.BASE_DIR / 'frontend' / 'dist' / 'index.html'
    if not index_path.exists():
        return HttpResponse(
            'Vue 前端尚未构建，请先运行：cd frontend && npm run build',
            status=503,
        )

    return HttpResponse(index_path.read_text(encoding='utf-8'))


def cors_response(data, status=200):
    response = JsonResponse(data, status=status)
    response['Access-Control-Allow-Origin'] = 'http://127.0.0.1:5173'
    response['Access-Control-Allow-Methods'] = 'POST, OPTIONS'
    response['Access-Control-Allow-Headers'] = 'Content-Type'
    return response


@csrf_exempt
@require_http_methods(['POST', 'OPTIONS'])
def create_contract(request):
    if request.method == 'OPTIONS':
        return cors_response({})

    try:
        payload = json.loads(request.body.decode('utf-8'))
    except json.JSONDecodeError:
        return cors_response({'message': '请求数据格式错误'}, status=400)

    required_fields = {
        'contact_name': '联系人',
        'contact_phone': '联系电话',
        'company_brand': '公司/品牌',
        'project_type': '项目类型',
        'estimated_quantity': '预计数量',
        'delivery_city': '交付城市',
        'budget_range': '预算区间',
        'requirement_description': '需求说明',
    }
    missing_fields = [
        label for field, label in required_fields.items()
        if not str(payload.get(field, '')).strip()
    ]

    if missing_fields:
        return cors_response(
            {'message': f'请填写：{"、".join(missing_fields)}'},
            status=400,
        )

    contract = Contract.objects.create(
        contact_name=payload['contact_name'].strip(),
        contact_phone=payload['contact_phone'].strip(),
        company_brand=payload['company_brand'].strip(),
        project_type=payload['project_type'].strip(),
        estimated_quantity=payload['estimated_quantity'].strip(),
        delivery_city=payload['delivery_city'].strip(),
        budget_range=payload['budget_range'].strip(),
        requirement_description=payload['requirement_description'].strip(),
    )

    return cors_response({
        'message': '需求提交成功',
        'id': contract.id,
    }, status=201)
