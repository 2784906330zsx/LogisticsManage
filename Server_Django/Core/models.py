from django.db import models
from django.contrib.auth.models import AbstractUser
from decimal import Decimal


class User(AbstractUser):
    # username、password、email由AbstractUser提供
    job_number = models.CharField(max_length=20, verbose_name='员工工号')
    gender = models.IntegerField(verbose_name='性别')
    mobile = models.CharField(max_length=20, verbose_name='手机号')
    # department = models.IntegerField(verbose_name='所属部门的ID')
    position = models.IntegerField(verbose_name='职务的ID')
    status = models.IntegerField(verbose_name='状态')
    avatar = models.URLField(verbose_name='头像')

    class Meta:
        db_table = 'User'
        db_table_comment = '用户'


class Department(models.Model):
    department_name = models.CharField(max_length=100, verbose_name='部门名称')
    description = models.TextField(verbose_name='描述')
    create_time = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    is_enabled = models.BooleanField(default=True, verbose_name='是否启用')

    class Meta:
        verbose_name = '部门'
        db_table = 'Department'


class Role(models.Model):
    role_name = models.CharField(max_length=100, verbose_name='职务名称')
    role_code = models.CharField(max_length=50, unique=True, verbose_name='职务编码')
    description = models.TextField(verbose_name='职务描述')
    department = models.ForeignKey(Department, on_delete=models.CASCADE, verbose_name='所属部门')
    create_time = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    is_enabled = models.BooleanField(default=True, verbose_name='是否启用')

    class Meta:
        verbose_name = '职务'
        db_table = 'Role'


class Commodity(models.Model):
    STATUS_CHOICES = [
        ('1', '在售'),
        ('2', '下架'),
        ('3', '预售'),
        ('4', '缺货'),
    ]

    name = models.CharField(max_length=200, verbose_name='商品名称')
    image = models.URLField(verbose_name='商品图片')
    brand = models.CharField(max_length=100, verbose_name='品牌')
    description = models.TextField(verbose_name='商品介绍')
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='1', verbose_name='商品状态')
    price = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='价格')
    stock = models.IntegerField(default=0, verbose_name='库存')
    total_inbound = models.IntegerField(default=0, verbose_name='总入库数量')
    total_outbound = models.IntegerField(default=0, verbose_name='总出库数量')
    supplier = models.CharField(max_length=200, verbose_name='供货商')
    create_time = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    last_update_time = models.DateTimeField(auto_now=True, verbose_name='最近更新时间')
    storage_area = models.CharField(max_length=100, verbose_name='存储区域')

    class Meta:
        verbose_name = '商品'
        db_table = 'Commodity'


class Supplier(models.Model):
    TYPE_CHOICES = [
        ('企业', '企业'),
        ('个人或个体工商户', '个人或个体工商户'),
        ('事业单位', '事业单位'),
        ('政府部门', '政府部门'),
        ('社会团体', '社会团体'),
        ('集体组织', '集体组织'),
    ]

    STATUS_CHOICES = [
        ('1', '正常'),
        ('2', '暂停合作'),
        ('3', '黑名单'),
    ]

    name = models.CharField(max_length=200, verbose_name='供应商名称')
    supplier_type = models.CharField(max_length=50, choices=TYPE_CHOICES, verbose_name='供应商类型')
    address = models.TextField(verbose_name='供应商地址')
    contact_person = models.CharField(max_length=100, verbose_name='联系人')
    contact_phone = models.CharField(max_length=20, verbose_name='联系电话')
    contact_email = models.EmailField(verbose_name='联系邮箱')
    create_time = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='1', verbose_name='状态')

    class Meta:
        verbose_name = '供应商'
        db_table = 'Supplier'


class PurchaseOrder(models.Model):
    STATUS_CHOICES = [
        ('1', '财务审核中'),
        ('2', '审核未通过'),
        ('3', '待入库'),
        ('4', '已入库'),
        ('5', '已取消'),
    ]

    order_number = models.CharField(max_length=50, unique=True, verbose_name='订单编号')
    commodity = models.ForeignKey(Commodity, on_delete=models.CASCADE, verbose_name='商品')
    supplier = models.ForeignKey(Supplier, on_delete=models.CASCADE, verbose_name='供应商')
    unit_price = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='采购单价')
    quantity = models.IntegerField(verbose_name='采购数量')
    total_amount = models.DecimalField(max_digits=12, decimal_places=2, verbose_name='总金额')
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='1', verbose_name='订单状态')

    purchase_name = models.CharField(max_length=100, verbose_name='采购人姓名')
    purchase_job_number = models.CharField(max_length=50, verbose_name='采购人工号')
    order_time = models.DateTimeField(auto_now_add=True, verbose_name='下单时间')

    check_name = models.CharField(max_length=100, null=True, blank=True, verbose_name='审核人姓名')
    check_job_number = models.CharField(max_length=50, null=True, blank=True, verbose_name='审核人工号')
    check_time = models.DateTimeField(null=True, blank=True, verbose_name='审核时间')
    check_reason = models.CharField(max_length=200, null=True, blank=True, verbose_name='审核理由')

    inbound_name = models.CharField(max_length=100, null=True, blank=True, verbose_name='入库人姓名')
    inbound_job_number = models.CharField(max_length=50, null=True, blank=True, verbose_name='入库人工号')
    inbound_time = models.DateTimeField(null=True, blank=True, verbose_name='入库时间')

    class Meta:
        verbose_name = '采购订单'
        db_table = 'PurchaseOrder'


class InboundRecord(models.Model):
    commodity = models.ForeignKey(Commodity, on_delete=models.CASCADE, verbose_name='商品')
    quantity = models.IntegerField(verbose_name='入库数量')
    reason = models.CharField(max_length=200, verbose_name='入库原因')
    inbound_time = models.DateTimeField(auto_now_add=True, verbose_name='入库时间')
    related_order = models.CharField(max_length=50, verbose_name='关联订单')
    inbound_name = models.CharField(max_length=100, verbose_name='入库人姓名')
    inbound_job_number = models.CharField(max_length=50, verbose_name='入库人工号')

    class Meta:
        verbose_name = '入库记录'
        db_table = 'InboundRecord'


class OutboundRecord(models.Model):
    commodity = models.ForeignKey(Commodity, on_delete=models.CASCADE, verbose_name='商品')
    quantity = models.IntegerField(verbose_name='出库数量')
    reason = models.CharField(max_length=200, verbose_name='出库原因')
    outbound_time = models.DateTimeField(auto_now_add=True, verbose_name='出库时间')
    related_order = models.CharField(max_length=50, verbose_name='关联订单')
    outbound_name = models.CharField(max_length=100, verbose_name='出库人姓名')
    outbound_job_number = models.CharField(max_length=50, verbose_name='出库人工号')

    class Meta:
        verbose_name = '出库记录'
        db_table = 'OutboundRecord'


class StaticRoute(models.Model):
    departure = models.CharField(max_length=200, verbose_name='出发地')
    destination = models.CharField(max_length=200, verbose_name='目的地')
    total_distance = models.DecimalField(max_digits=8, decimal_places=2, verbose_name='总距离(公里)')
    estimated_time = models.DecimalField(max_digits=5, decimal_places=1, verbose_name='预计耗时(小时)')
    schedule_info = models.TextField(verbose_name='班次信息')
    is_active = models.BooleanField(default=True, verbose_name='是否启用')
    create_time = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')

    class Meta:
        verbose_name = '固定线路'
        db_table = 'StaticRoute'


class Vehicle(models.Model):
    TYPE_CHOICES = [
        ('电动三轮车', '电动三轮车'),
        ('面包车', '面包车'),
        ('小型卡车', '小型卡车'),
        ('中型卡车', '中型卡车'),
        ('大型卡车', '大型卡车'),
    ]

    HEALTH_STATUS_CHOICES = [
        ('正常', '正常'),
        ('小破', '小破'),
        ('大破', '大破'),
    ]

    STORAGE_STATUS_CHOICES = [
        ('在库待命', '在库待命'),
        ('在库维修', '在库维修'),
        ('外出送货', '外出送货'),
        ('外出维修', '外出维修'),
    ]

    vehicle_type = models.CharField(max_length=20, choices=TYPE_CHOICES, verbose_name='车辆类型')
    current_load = models.IntegerField(default=0, verbose_name='当前载货量')
    max_load = models.IntegerField(verbose_name='最大载货量')
    health_status = models.CharField(max_length=10, choices=HEALTH_STATUS_CHOICES, default='正常', verbose_name='健康状态')
    plate_number = models.CharField(max_length=20, unique=True, verbose_name='车牌号')
    purchase_time = models.DateTimeField(verbose_name='购入时间')
    storage_status = models.CharField(max_length=20, choices=STORAGE_STATUS_CHOICES, default='在库待命', verbose_name='在库状态')
    current_route = models.CharField(max_length=500, null=True, blank=True, verbose_name='当前运行线路')
    is_enabled = models.BooleanField(default=True, verbose_name='是否启用')
    driver_job_number = models.CharField(max_length=100, verbose_name='司机的工号')

    class Meta:
        verbose_name = '车辆'
        db_table = 'Vehicle'


class ShippingOrder(models.Model):
    STATUS_CHOICES = [
        ('1', '待审核'),
        ('2', '审核未通过'),
        ('3', '审核通过/待配送'),
        ('4', '配送中'),
        ('5', '已送达'),
        ('6', '已确认收货'),
        ('7', '已取消'),
    ]

    order_number = models.CharField(max_length=50, unique=True, verbose_name='运单号')
    commodity = models.ForeignKey(Commodity, on_delete=models.CASCADE, verbose_name='商品')
    quantity = models.IntegerField(verbose_name='商品数量')
    receiver_name = models.CharField(max_length=100, verbose_name='收货人姓名')
    receiver_phone = models.CharField(max_length=20, verbose_name='联系方式')
    receiver_address = models.TextField(verbose_name='收货地址')
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='1', verbose_name='订单状态')
    complete_time = models.DateTimeField(null=True, blank=True, verbose_name='运单完成时间')

    creator_name = models.CharField(max_length=100, verbose_name='创建人姓名')
    creator_job_number = models.CharField(max_length=50, verbose_name='创建人工号')
    create_time = models.DateTimeField(auto_now_add=True, verbose_name='运单创建时间')

    check_name = models.CharField(max_length=100, null=True, blank=True, verbose_name='审核人姓名')
    check_job_number = models.CharField(max_length=50, null=True, blank=True, verbose_name='审核人工号')
    check_time = models.DateTimeField(null=True, blank=True, verbose_name='审核时间')
    check_reason = models.CharField(max_length=200, null=True, blank=True, verbose_name='审核理由')

    delivery_time = models.DateTimeField(null=True, blank=True, verbose_name='配送时间')
    delivery_job_number = models.CharField(max_length=50, null=True, blank=True, verbose_name='配送员工号')
    delivery_person_name = models.CharField(max_length=100, null=True, blank=True, verbose_name='配送员姓名')
    delivery_person_phone = models.CharField(max_length=20, null=True, blank=True, verbose_name='配送员电话')
    delivery_car_number = models.CharField(max_length=50, null=True, blank=True, verbose_name='配送车车牌号')

    class Meta:
        verbose_name = '运单'
        db_table = 'ShippingOrder'


class IncomeRecord(models.Model):
    REASON_CHOICES = [
        ('总公司拨款', '总公司拨款'),
        ('业务收入', '业务收入'),
        ('采购退款', '采购退款'),
        ('其他', '其他'),
    ]

    amount = models.DecimalField(max_digits=12, decimal_places=2, verbose_name='收入金额')
    reason = models.CharField(max_length=50, choices=REASON_CHOICES, verbose_name='收入原因')
    related_order = models.CharField(max_length=50, blank=True, null=True, verbose_name='关联订单')
    income_time = models.DateTimeField(auto_now_add=True, verbose_name='收入时间')
    operator_name = models.CharField(max_length=100, verbose_name='操作员姓名')
    operator_job_number = models.CharField(max_length=50, verbose_name='操作员工号')
    remark = models.TextField(blank=True, null=True, verbose_name='备注')
    create_time = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')

    class Meta:
        verbose_name = '财务收入记录'
        db_table = 'IncomeRecord'


class ExpenditureRecord(models.Model):
    REASON_CHOICES = [
        ('采购支出', '采购支出'),
        ('运营成本', '运营成本'),
        ('员工工资', '员工工资'),
        ('政府税收', '政府税收'),
        ('其他', '其他'),
    ]

    amount = models.DecimalField(max_digits=12, decimal_places=2, verbose_name='支出金额')
    reason = models.CharField(max_length=50, choices=REASON_CHOICES, verbose_name='支出原因')
    related_order = models.CharField(max_length=50, blank=True, null=True, verbose_name='关联订单')
    expenditure_time = models.DateTimeField(auto_now_add=True, verbose_name='支出时间')
    operator_name = models.CharField(max_length=100, verbose_name='操作员姓名')
    operator_job_number = models.CharField(max_length=50, verbose_name='操作员工号')
    remark = models.TextField(blank=True, null=True, verbose_name='备注')
    create_time = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')

    class Meta:
        verbose_name = '财务支出记录'
        db_table = 'ExpenditureRecord'


class Finance(models.Model):
    balance = models.DecimalField(max_digits=12, decimal_places=2, verbose_name='当前余额')
    income = models.DecimalField(max_digits=12, decimal_places=2, verbose_name='总收入')
    expenditure = models.DecimalField(max_digits=12, decimal_places=2, verbose_name='总支出')
    net_profit = models.DecimalField(max_digits=12, decimal_places=2, verbose_name='净利润')

    class Meta:
        verbose_name = '财务总览'
        db_table = 'Finance'
