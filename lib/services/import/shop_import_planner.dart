import 'package:distro_link/services/import/import_models.dart';

/// Stable identity for a **code-less** shop: its area plus its normalized name.
///
/// A blank `retailer_code` has no dedup key, so re-uploading the same sheet
/// would otherwise keep adding the same shop. This key lets a code-less row
/// match a shop that already exists in the same area. The name is
/// `trim().toLowerCase()` and the area is the resolved `area_id` (not the area
/// text), so area case/spelling can't split the key. **Must** be the single
/// definition used on both sides (existing DB rows and incoming sheet rows) so
/// normalization can't drift — see
/// `SuperAdminRepository.existingShopNameAreaKeys`.
String shopNameAreaKey(String areaId, String shopName) =>
    '$areaId ${shopName.trim().toLowerCase()}';

/// Splits parsed shop [rows] into insert / skip / blocking for one distributor.
///
/// Pure — all I/O (resolved area map, existing codes, existing name+area keys)
/// is passed in, so it unit-tests without Riverpod/Supabase/isolates.
///
/// Dedup rules:
/// - **Coded** row (`retailerCode` non-empty): skipped if its code already
///   exists (`existingCodes`). Distinct codes are honored — two same-named
///   shops in one area are allowed when they carry different codes.
/// - **Code-less** row: skipped if its `shopNameAreaKey` already exists
///   ([existingNameAreaKeys]) or was already added earlier in this same sheet.
///
/// Every inserted row (coded or not) registers its name+area, so a later
/// code-less row for the same shop is skipped too.
ImportPlan buildShopImportPlan({
  required List<ShopRow> rows,
  required List<RowIssue> structuralIssues,
  required Map<String, String> areaMap,
  required Set<String> ambiguousAreas,
  required Set<String> existingCodes,
  required Set<String> existingNameAreaKeys,
}) {
  final structuralRows = {for (final i in structuralIssues) i.row.rowNumber};
  final blocking = <RowIssue>[...structuralIssues];
  final skipped = <RowIssue>[];
  final toInsert = <Map<String, dynamic>>[];

  // Name+area keys added within this sheet (so intra-file repeats also skip).
  final seenNameArea = <String>{};

  for (final row in rows) {
    if (structuralRows.contains(row.rowNumber)) continue;

    final areaKey = row.area.toLowerCase();
    if (ambiguousAreas.contains(areaKey)) {
      blocking.add(RowIssue(row: row, issue: 'ambiguous area name'));
      continue;
    }
    final areaId = areaMap[areaKey];
    if (areaId == null) {
      blocking.add(RowIssue(row: row, issue: 'area not found'));
      continue;
    }

    final nameAreaKey = shopNameAreaKey(areaId, row.shop);

    if (row.retailerCode.isNotEmpty) {
      if (existingCodes.contains(row.retailerCode.toLowerCase())) {
        skipped.add(RowIssue(row: row, issue: 'retailer_code already exists'));
        continue;
      }
    } else {
      // Code-less: fall back to name+area identity (existing DB + this sheet).
      if (existingNameAreaKeys.contains(nameAreaKey) ||
          seenNameArea.contains(nameAreaKey)) {
        skipped.add(
          RowIssue(row: row, issue: 'shop already exists in this area'),
        );
        continue;
      }
    }

    toInsert.add({
      'area_id': areaId,
      'shop_name': row.shop,
      'shop_address': row.address,
      // Optional values: omit when blank so they store NULL, not '',
      // matching the admin add-shop path.
      if (row.retailerCode.isNotEmpty) 'shop_number': row.retailerCode,
      if (row.shopOwner.isNotEmpty) 'shop_owner': row.shopOwner,
      if (row.mobile.isNotEmpty) 'phone_no': row.mobile,
      if (row.gstNo.isNotEmpty) 'gstin': row.gstNo,
    });
    // Register every inserted shop so a later code-less row for the same
    // (area, name) is skipped rather than re-added.
    seenNameArea.add(nameAreaKey);
  }

  blocking.sort((a, b) => a.row.rowNumber.compareTo(b.row.rowNumber));

  return ImportPlan(toInsert: toInsert, skipped: skipped, blocking: blocking);
}
