// Plain Dart model for outbox orders — no Hive codegen required.
// Serialized as JSON and stored in a Hive box keyed by [localId].

enum OutboxStatus { pending, syncing, synced, failed }

class OutboxOrderItem {
  const OutboxOrderItem({
    required this.productId,
    required this.itemCode,
    required this.itemName,
    required this.mrp,
    required this.sellingRate,
    required this.quantity,
    required this.gstPercent,
    required this.lineTotal,
    this.discountPercent = 0,
    this.freeQty = 0,
  });

  factory OutboxOrderItem.fromJson(Map<String, dynamic> json) =>
      OutboxOrderItem(
        productId: json['product_id'] as String,
        itemCode: json['item_code'] as String,
        itemName: json['item_name'] as String,
        mrp: (json['mrp'] as num).toDouble(),
        sellingRate: (json['selling_rate'] as num).toDouble(),
        quantity: json['quantity'] as int,
        gstPercent: (json['gst_percent'] as num).toDouble(),
        lineTotal: (json['line_total'] as num).toDouble(),
        discountPercent: (json['discount_percent'] as num?)?.toDouble() ?? 0,
        freeQty: json['free_qty'] as int? ?? 0,
      );

  final String productId;
  final String itemCode;
  final String itemName;
  final double mrp;
  final double sellingRate;
  final int quantity;
  final double gstPercent;
  final double lineTotal;
  final double discountPercent;
  final int freeQty;

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'item_code': itemCode,
        'item_name': itemName,
        'mrp': mrp,
        'selling_rate': sellingRate,
        'quantity': quantity,
        'gst_percent': gstPercent,
        'line_total': lineTotal,
        'discount_percent': discountPercent,
        'free_qty': freeQty,
      };
}

class OutboxOrder {
  OutboxOrder({
    required this.localId,
    required this.distributorId,
    required this.salesmanId,
    required this.shopId,
    required this.areaId,
    required this.shopName,
    required this.shopNumber,
    required this.subtotal,
    required this.gstTotal,
    required this.grandTotal,
    required this.orderDate,
    required this.orderNumber,
    required this.status,
    required this.retryCount,
    required this.createdAt,
    required this.items,
    this.notes,
  });

  factory OutboxOrder.fromJson(Map<String, dynamic> json) => OutboxOrder(
        localId: json['local_id'] as String,
        distributorId: json['distributor_id'] as String,
        salesmanId: json['salesman_id'] as String,
        shopId: json['shop_id'] as String,
        areaId: json['area_id'] as String,
        shopName: json['shop_name'] as String,
        shopNumber: json['shop_number'] as String,
        subtotal: (json['subtotal'] as num).toDouble(),
        gstTotal: (json['gst_total'] as num).toDouble(),
        grandTotal: (json['grand_total'] as num).toDouble(),
        orderDate: json['order_date'] as String,
        orderNumber: json['order_number'] as String,
        status: OutboxStatus.values.byName(json['status'] as String),
        retryCount: json['retry_count'] as int,
        createdAt: DateTime.parse(json['created_at'] as String),
        items: (json['items'] as List<dynamic>)
            .map(
              (dynamic i) =>
                  OutboxOrderItem.fromJson(i as Map<String, dynamic>),
            )
            .toList(),
        notes: json['notes'] as String?,
      );

  final String localId;
  final String distributorId;
  final String salesmanId;
  final String shopId;
  final String areaId;
  final String shopName;
  final String shopNumber;
  final double subtotal;
  final double gstTotal;
  final double grandTotal;
  final String? notes;
  final String orderDate;
  final String orderNumber;
  OutboxStatus status;
  int retryCount;
  final DateTime createdAt;
  final List<OutboxOrderItem> items;

  OutboxOrder copyWith({OutboxStatus? status, int? retryCount}) => OutboxOrder(
        localId: localId,
        distributorId: distributorId,
        salesmanId: salesmanId,
        shopId: shopId,
        areaId: areaId,
        shopName: shopName,
        shopNumber: shopNumber,
        subtotal: subtotal,
        gstTotal: gstTotal,
        grandTotal: grandTotal,
        orderDate: orderDate,
        orderNumber: orderNumber,
        status: status ?? this.status,
        retryCount: retryCount ?? this.retryCount,
        createdAt: createdAt,
        items: items,
        notes: notes,
      );

  Map<String, dynamic> toJson() => {
        'local_id': localId,
        'distributor_id': distributorId,
        'salesman_id': salesmanId,
        'shop_id': shopId,
        'area_id': areaId,
        'shop_name': shopName,
        'shop_number': shopNumber,
        'subtotal': subtotal,
        'gst_total': gstTotal,
        'grand_total': grandTotal,
        'notes': notes,
        'order_date': orderDate,
        'order_number': orderNumber,
        'status': status.name,
        'retry_count': retryCount,
        'created_at': createdAt.toIso8601String(),
        'items': items.map((i) => i.toJson()).toList(),
      };
}
