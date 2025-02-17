-- imec-14741-prevent-doctor-records-delete
-- Required to run before release to remove existing untracked trigger and table it was using for logging.

use [IMECentricEW]

DROP TRIGGER [dbo].[tblDoctor_AfterDelete_TRG]
