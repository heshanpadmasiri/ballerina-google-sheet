+ We can use `sheetsSpreadsheetsBatchupdate` todo all sort of changes to each *individual* sheet
    + `renameSpreadsheet`
    + `addSheet`
    + `removeSheet`
    + `renameSheet`
    + `clearRange`
    + `addColumnsBefore`
        + `addColumnsBeforeBySheetName` (same as `addColumnsBefore` needs to get id via `getSheetByName`)
    + `addColumnsAfter`
        + `addColumnsAfterBySheetName`
    + `deleteColumns`
        + `deleteColumnsBySheetName`
    + `addRowsBefore`
        + `addRowsBeforeBySheetName`
    + `addRowsAfter`
        + `addRowsAfterBySheetName`
    + `deleteRows`
        + `deleteRowsBySheetName`
    + `appendRowToSheet`
    + `appendValue`
    + `clearAll`
        + `clearAllBySheetName`
    + `setRowMetadata`
+ can use `sheetsSpreadsheetsGetbydatafilter` for both columns and rows
    + `getRowByDataFilter`
+ can use `sheetsSpreadsheetsValuesBatchupdatebydatafilter` for both columns and rows
    + `updateRowByDataFilter`
+ can use `sheetsSpreadsheetsValuesBatchget` to get both columns and rows
    + `getColumn`
    + `getRow`
    + `getCell`

+ `Spreadsheet` we get already have an array of `Sheet` so `openSpreadsheetById` can also replace 
    + `getSheets` (not sure why we have this since `Spreadsheet` type in old API also have this property)

# No equivalent in the generated version
+ `openSpreadsheetByUrl`
    + This is using a helper function `getIdFromUrl` and then call `openSpreadsheetById`
+ `getAllSpreadsheets` (TODO: see if this is actually using the drive API not sheets API)
+ `getSheets` (This is just a wrapper around `openSpreadsheetById`. In both new and old APIs that returns list of sheets)
    + `getSheetByName` (same as above and this iterate the array to find a matching name)
+ `removeSheetByName` (Internally this is still getting the sheet id using `getSheetByName` and then delete it using id via `removeSheet`)
+ `createOrUpdateColumn` (TODO: not sure if this have something special for columns, otherwise can use `UpdateCellsRequest` (in `sheetsSpreadsheetsBatchupdate`) to do the same)
+ `createOrUpdateRow` (same as `createOrUpdateColumn`)
+ `setCell` (TODO: not sure if this have something special for single values, otherwise can use `sheetsSpreadsheetsValuesBatchupdate`)
+ `clearCell` (internally uses `clearRange`)
+ `copyToBySheetName` (internally uses `copyTo`
+ `deleteRowByDataFilter` (internally this is a composite request that first fetch the data and then delete them, I think we can implement both)
