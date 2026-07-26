/// GST slabs a product may be assigned, ascending.
///
/// The standard Indian slabs {0, 5, 12, 18, 28} plus 40 (PM-specified
/// 2026-07-26). Single source of truth for both the admin add/edit product
/// dropdown and the bulk item import's validation — they drifted apart once
/// already, so keep new call sites reading from here.
const List<int> kGstSlabs = [0, 5, 12, 18, 28, 40];
