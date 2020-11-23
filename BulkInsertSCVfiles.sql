CREATE PROCEDURE [dbo].[BulkInsertSCVfiles]
AS

declare @tableName nvarchar(50)
declare @sql nvarchar(max)
declare data_cursor CURSOR FOR
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES
open data_cursor
fetch next from data_cursor into @tableName
WHILE @@FETCH_STATUS = 0
BEGIN
    set @sql = 'TRUNCATE TABLE dbo.' + @tableName + '; BULK INSERT dbo.'+ @tableName + ' FROM ''' + ' insert path here \MIMIC-III\' + @tableName + '.CSV'' WITH ( CODEPAGE='+'''RAW'''+', FORMAT=' +'''CSV'''+', ROWTERMINATOR = ' +'''0x0a'''+', FIELDTERMINATOR =  ' +''','''+', FIELDQUOTE = ' +'''"'''+', FIRSTROW = 2, KEEPNULLS);'
    fetch next from data_cursor into @tableName
    PRINT(@sql)
END
CLOSE data_cursor
DEALLOCATE data_cursor  
  
GO
