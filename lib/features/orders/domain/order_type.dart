/// Order urgency / payment type.
///
/// Stored in OrderDraftState only for Phase 1 (no column in orders yet).
/// Phase 2: add `order_type text` column and persist here.
enum OrderType { regular, urgent, credit }

extension OrderTypeLabel on OrderType {
  String get label => switch (this) {
        OrderType.regular => 'Regular',
        OrderType.urgent => 'Urgent',
        OrderType.credit => 'Credit',
      };
}
