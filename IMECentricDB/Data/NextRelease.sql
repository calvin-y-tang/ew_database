-- Sprint 91

-- IMEC-12959 - Add status to tblOutOfNetworkReason, set all existing to active
update tblOutOfNetworkReason set Status = 'Active'