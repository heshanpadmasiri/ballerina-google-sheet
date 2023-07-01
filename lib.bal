import ballerina/http;
import ballerina/lang.regexp;

type RenderOptions "FORMATTED_VALUE"|"UNFORMATTED_VALUE"|"FORMULA";

public type ValueRange record {
    @display {label: "Row Number"}
    int rowPosition;
    @display {label: "Values"}
    (int|string|decimal|boolean|float)[] values;
    @display {label: "A1 Range"}
    A1Range a1Range;
};

# File information
#
# + kind - Identifies what kind of resource is this. Value: the fixed string "drive#file".   
# + id - The Id of the file
# + name - The name of the file
# + mimeType - The MIME type of the file
@display {label: "File"}
public type File record {
    @display {label: "Kind"}
    string kind;
    @display {label: "Id"}
    string id;
    @display {label: "Name"}
    string name;
    @display {label: "Mime Type"}
    string mimeType;
};

# Single cell or a group of adjacent cells in a sheet.
#
# + a1Notation - The column letter followed by the row number.
# For example for a single cell "A1" refers to the intersection of column "A" with row "1",
# and for a range of cells "A1:D5" refers to the top left cell and the bottom right cell of a range
# + values - Values of the given range
@display {label: "Range"}
public type Range record {
    @display {label: "A1 Notation"}
    string a1Notation;
    @display {label: "Values"}
    (int|string|decimal)[][] values;
};

public type Column record {
    @display {label: "Column Letter"}
    string columnPosition;
    @display {label: "Values"}
    (int|string|decimal)[] values;
};

public type Row record {
    @display {label: "Row Number"}
    int rowPosition;
    @display {label: "Values"}
    (int|string|decimal)[] values;
};

public type Cell record {
    @display {label: "A1 Notation"}
    string a1Notation;
    @display {label: "Value"}
    (int|string|decimal) value;
};

public type A1Range record {
    @display {label: "Sheet Name"}
    string sheetName;
    @display {label: "Start Index"}
    string startIndex?;
    @display {label: "End Index"}
    string endIndex?;
};

public type FilesResponse record {
    @display {label: "Kind"}
    string kind;
    @display {label: "Next Page Token"}
    string nextPageToken?;
    @display {label: "Incomplete Search"}
    boolean incompleteSearch;
    @display {label: "Array of Files"}
    File[] files;
};

public enum Visibility {
    UNSPECIFIED_VISIBILITY = "DEVELOPER_METADATA_VISIBILITY_UNSPECIFIED",
    DOCUMENT = "DOCUMENT",
    PROJECT = "PROJECT"
};

public type Filter A1Range|DeveloperMetadataLookupFilter|GridRangeFilter;

public type GridRangeFilter record {
    @display {label: "Worksheet ID"}
    int sheetId;
    @display {label: "Starting Row Index"}
    int startRowIndex?;
    @display {label: "Ending Row Index"}
    int endRowIndex?;
    @display {label: "Starting Column Index"}
    int startColumnIndex?;
    @display {label: "Ending Column Index"}
    int endColumnIndex?;
};

public type DeveloperMetadataLookupFilter record {
    @display {label: "Location Type"}
    LocationType locationType;
    @display {label: "Location matching strategy"}
    LocationMatchingStrategy locationMatchingStrategy?;
    @display {label: "Metadata Id"}
    int metadataId?;
    @display {label: "Metadata Key"}
    string metadataKey?;
    @display {label: "Metadata Value"}
    string metadataValue;
    @display {label: "Metadata Visibility"}
    Visibility visibility?;
    @display {label: "Metadata Location"}
    MetadataLocation metadataLocation?;
};

public type MetadataLocation record {
    @display {label: "Location Type"}
    LocationType locationType;
    @display {label: "Spreadsheet"}
    boolean spreadsheet;
    @display {label: "Worksheet ID"}
    int sheetId;
    @display {label: "Dimension Range"}
    DimensionRange dimensionRange;
};

public enum LocationType {
    UNSPECIFIED_LOCATION = "DEVELOPER_METADATA_LOCATION_TYPE_UNSPECIFIED",
    COLUMN = "COLUMN",
    SPREADSHEET = "SPREADSHEET",
    SHEET = "SHEET",
    ROW = "ROW"
};

public enum LocationMatchingStrategy {
    UNSPECIFIED_STRATEGY = "DEVELOPER_METADATA_LOCATION_MATCHING_STRATEGY_UNSPECIFIED",
    EXACT_LOCATION = "EXACT_LOCATION",
    INTERSECTING_LOCATION = "INTERSECTING_LOCATION"
};

public isolated client class Client {
    private final GsheetClient gClient;
    private final http:Client driveClient;

    public isolated function init(ConnectionConfig config) returns error? {
        self.driveClient = check new ("https://www.googleapis.com",
            check intoHttpClientConfiguration(config)
        );
        self.gClient = check new (config);
    }

    remote isolated function createSpreadsheet(@display {label: "Google Sheet Name"} string name)
                                                returns @tainted Spreadsheet|error {
        return self.gClient->createSpreadsheet({properties: {title: name}});
    }

    remote isolated function openSpreadsheetById(@display {label: "Google Sheet ID"} string spreadsheetId)
                                                returns @tainted Spreadsheet|error {
        return self.gClient->getSpreadsheetById(spreadsheetId);
    }

    remote isolated function openSpreadsheetByUrl(@display {label: "Google Sheet Url"} string url)
                                                returns @tainted Spreadsheet|error {
        return self->openSpreadsheetById(check getIdFromUrl(url));
    }

    remote isolated function getAllSpreadsheets() returns @display {label: "Stream of Files"} stream<File, error?>|error {
        // NOTE: this is just a copy of original
        SpreadsheetStream spreadsheetStream = check new SpreadsheetStream(self.driveClient);
        return new stream<File, error?>(spreadsheetStream);
    }

    // NOTE: this is depricated but there is a bunch of tests that depend on it
    remote isolated function appendRowToSheet(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet Name"} string sheetName,
            @display {label: "Row Values"} (int|string|decimal)[] values,
            @display {label: "Range A1 Notation"} string? a1Notation = (),
            @display {label: "Value Input Option"} string? valueInputOption = ())
                                            returns @tainted error? {
        string notation = (a1Notation is ()) ? string `${sheetName}` : string `${sheetName}!${a1Notation}`;
        Range range = {a1Notation: notation, values: [values]};
        GsheetValueRange payload = inToGsheetValueRange(range);
        // FIXME: value input option
        AppendValuesResponse _ = check self.gClient->appendValues(spreadsheetId, notation, payload, valueInputOption = "RAW");
    }

    remote isolated function renameSpreadsheet(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "New Google Sheet Name"} string name)
                                                returns @tainted error? {
        BatchUpdateSpreadsheetResponse _ = check self.gClient->batchUpdate(spreadsheetId, {requests: [{updateSpreadsheetProperties: {properties: {title: name}, fields: "title"}}]});
    }

    remote isolated function getSheets(@display {label: "Google Sheet ID"} string spreadsheetId)
                                        returns @tainted@display {label: "Array of Worksheets"} Sheet[]|error {
        Spreadsheet spreadsheet = check self.gClient->getSpreadsheetById(spreadsheetId);
        Sheet[]? sheets = spreadsheet.sheets;
        if sheets == () {
            return error("empty sheet array");
        }
        return sheets;
    }

    remote isolated function getSheetByName(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet Name"} string sheetName)
                                            returns @tainted Sheet|error {
        Sheet[] sheets = check self->getSheets(spreadsheetId);
        foreach var sheet in sheets {
            SheetProperties? properties = sheet.properties;
            if properties != () && properties.title == sheetName {
                return sheet;
            }
        }
        return error("no such sheet");
    }

    remote isolated function addSheet(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet Name"} string sheetName)
                                    returns @tainted Sheet|error {
        // NOTE: isn't it better to take () instead of ""?
        AddSheetRequest request = sheetName != "" ? {properties: {title: sheetName}} : {properties: {}};
        // NOTE: response actually don't have all the sheets (i.e. ())
        BatchUpdateSpreadsheetResponse _ = check self.gClient->batchUpdate(spreadsheetId, {requests: [{addSheet: request}]});
        return self->getSheetByName(spreadsheetId, sheetName);
    }

    remote isolated function removeSheet(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet ID"} int sheetId) returns @tainted error? {
        DeleteSheetRequest request = {sheetId: <int:Signed32>sheetId};
        BatchUpdateSpreadsheetResponse _ = check self.gClient->batchUpdate(spreadsheetId, {requests: [{deleteSheet: request}]});
    }

    remote isolated function removeSheetByName(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet Name"} string sheetName)
                                                returns @tainted error? {
        Sheet sheet = check self->getSheetByName(spreadsheetId, sheetName);
        return self->removeSheet(spreadsheetId, <int>sheet.properties?.sheetId);
    }

    remote isolated function renameSheet(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Existing Worksheet Name"} string sheetName,
            @display {label: "New Worksheet Name"} string name)
                                        returns @tainted error? {
        Sheet sheet = check self->getSheetByName(spreadsheetId, sheetName);
        UpdateSheetPropertiesRequest request = {fields: "title", properties: {sheetId: sheet.properties?.sheetId, title: name}};
        BatchUpdateSpreadsheetResponse _ = check self.gClient->batchUpdate(spreadsheetId, {requests: [{updateSheetProperties: request}]});
    }

    remote isolated function setRange(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet Name"} string sheetName,
            Range range, @display {label: "Value Input Option"} string? valueInputOption = ())
                                    returns @tainted error? {
        // TODO: handle value input option
        // FIXME: we are ignoring the a1Notation in range why?
        string rangeRep = string `${sheetName}!${range.a1Notation}`;
        GsheetValueRange payload = inToGsheetValueRange(range);
        payload.range = rangeRep;
        UpdateValuesResponse _ = check self.gClient->setRange(spreadsheetId, rangeRep, payload, valueInputOption = "RAW");
    }

    remote isolated function getRange(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet Name"} string sheetName,
            @display {label: "Range A1 Notation"} string a1Notation,
            @display {label: "Value Render Option"} RenderOptions? valueRenderOption = ())
                                    returns @tainted Range|error {
        // TODO: sheetName + a1Notation is common enough and we should have a helper for it 
        string notation = string `${sheetName}!${a1Notation}`;
        GsheetValueRange? valueRange = check self.gClient->getRange(spreadsheetId, notation, valueRenderOption = valueRenderOption);
        if valueRange == () {
            return error("empty value range");
        }
        return intoRange(valueRange);
    }

    remote isolated function clearRange(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet Name"} string sheetName,
            @display {label: "Range A1 Notation"} string a1Notation)
                                        returns @tainted error? {
        string notation = string `${sheetName}!${a1Notation}`;
        ClearValuesResponse _ = check self.gClient->clearValues(spreadsheetId, notation, {});
    }

    remote isolated function addColumnsBefore(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet ID"} int sheetId,
            @display {label: "Column Position"} int index,
            @display {label: "Number of Columns"} int numberOfColumns)
                                            returns @tainted error? {
        int:Signed32 startIndex = checkpanic (index - 1).ensureType();
        int:Signed32 endIndex = checkpanic (startIndex + numberOfColumns).ensureType();
        InsertDimensionRequest request = {range: {sheetId: <int:Signed32>sheetId, dimension: "COLUMNS", startIndex, endIndex}};
        BatchUpdateSpreadsheetResponse _ = check self.gClient->batchUpdate(spreadsheetId, {requests: [{insertDimension: request}]});
    }

    remote isolated function addColumnsBeforeBySheetName(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet Name"} string sheetName,
            @display {label: "Column Position"} int index,
            @display {label: "Number of Columns"}
                                                        int numberOfColumns)
                                                        returns @tainted error? {
        // TODO: we need to this to get id's from name many times, factor in to a seperate function
        Sheet sheet = check self->getSheetByName(spreadsheetId, sheetName);
        return self->addColumnsBefore(spreadsheetId, <int>sheet.properties?.sheetId, index, numberOfColumns);
    }

    remote isolated function addColumnsAfter(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet ID"} int sheetId,
            @display {label: "Column Position"} int index,
            @display {label: "Number of Columns"} int numberOfColumns)
                                            returns @tainted error? {
        InsertDimensionRequest request = {range: {sheetId: <int:Signed32>sheetId, dimension: "COLUMNS", startIndex: <int:Signed32>index, endIndex: <int:Signed32>(index + numberOfColumns)}};
        BatchUpdateSpreadsheetResponse _ = check self.gClient->batchUpdate(spreadsheetId, {requests: [{insertDimension: request}]});
    }

    remote isolated function addColumnsAfterBySheetName(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet Name"} string sheetName,
            @display {label: "Column Position"} int index,
            @display {label: "Number of Columns"}
                                                        int numberOfColumns)
                                                        returns @tainted error? {
        Sheet sheet = check self->getSheetByName(spreadsheetId, sheetName);
        return self->addColumnsAfter(spreadsheetId, <int>sheet.properties?.sheetId, index, numberOfColumns);
    }

    remote isolated function createOrUpdateColumn(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet Name"} string sheetName,
            @display {label: "Column Position"} string column,
            @display {label: "Column Values"} (int|string|decimal)[] values,
            @display {label: "Value Input Option"} string? valueInputOption = ())
                                                returns @tainted error? {
        string notation = string `${sheetName}!${column}:${column}`;
        (int|string|decimal)[][] rows = from var item in values
            select [item];
        Range range = {a1Notation: notation, values: rows};
        GsheetValueRange payload = inToGsheetValueRange(range);
        UpdateValuesResponse _ = check self.gClient->setRange(spreadsheetId, notation, payload, valueInputOption = "RAW");
    }

    remote isolated function getColumn(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet Name"} string sheetName,
            @display {label: "Column Position"} string column,
            @display {label: "Value Render Option"} string? valueRenderOption = ())
                                        returns @tainted Column|error {
        string notation = string `${sheetName}!${column}:${column}`;
        GsheetValueRange? valueRange = check self.gClient->getRange(spreadsheetId, notation, valueRenderOption = checkpanic valueRenderOption.ensureType());
        if valueRange == () {
            return error("empty value range");
        }
        return intoColumn(intoRange(valueRange));
    }

    remote isolated function deleteColumns(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet ID"} int sheetId,
            @display {label: "Starting Column Position"} int column,
            @display {label: "Number of Columns"} int numberOfColumns)
                                            returns @tainted error? {
        // NOTE: why is this not consistent 
        int:Signed32 startIndex = checkpanic (column - 1).ensureType();
        int:Signed32 endIndex = checkpanic (startIndex + numberOfColumns).ensureType();
        DeleteDimensionRequest request = {range: {sheetId: <int:Signed32>sheetId, dimension: "COLUMNS", startIndex, endIndex}};
        BatchUpdateSpreadsheetResponse _ = check self.gClient->batchUpdate(spreadsheetId, {requests: [{deleteDimension: request}]});
    }

    remote isolated function deleteColumnsBySheetName(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet Name"} string sheetName,
            @display {label: "Starting Column Position"} int column,
            @display {label: "Number of Columns"}
                                                    int numberOfColumns)
                                                    returns @tainted error? {
        Sheet sheet = check self->getSheetByName(spreadsheetId, sheetName);
        return self->deleteColumns(spreadsheetId, <int>sheet.properties?.sheetId, column, numberOfColumns);
    }

    remote isolated function addRowsBefore(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet ID"} int sheetId,
            @display {label: "Row Position"} int index,
            @display {label: "Number of Rows"} int numberOfRows)
                                            returns @tainted error? {
        int:Signed32 startIndex = checkpanic (index - 1).ensureType();
        int:Signed32 endIndex = checkpanic (startIndex + numberOfRows).ensureType();
        InsertDimensionRequest request = {range: {sheetId: <int:Signed32>sheetId, dimension: "ROWS", startIndex, endIndex}};
        BatchUpdateSpreadsheetResponse _ = check self.gClient->batchUpdate(spreadsheetId, {requests: [{insertDimension: request}]});
    }

    remote isolated function addRowsBeforeBySheetName(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet Name"} string sheetName,
            @display {label: "Row Position"} int index,
            @display {label: "Number of Rows"} int numberOfRows)
                                                    returns @tainted error? {
        Sheet sheet = check self->getSheetByName(spreadsheetId, sheetName);
        return self->addRowsBefore(spreadsheetId, <int>sheet.properties?.sheetId, index, numberOfRows);
    }

    remote isolated function addRowsAfter(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet ID"} int sheetId,
            @display {label: "Row Position"} int index,
            @display {label: "Number of Rows"} int numberOfRows)
                                        returns @tainted error? {
        InsertDimensionRequest request = {range: {sheetId: <int:Signed32>sheetId, dimension: "ROWS", startIndex: <int:Signed32>(index), endIndex: <int:Signed32>(index + numberOfRows)}};
        BatchUpdateSpreadsheetResponse _ = check self.gClient->batchUpdate(spreadsheetId, {requests: [{insertDimension: request}]});
    }

    remote isolated function addRowsAfterBySheetName(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet Name"} string sheetName,
            @display {label: "Row Position"} int index,
            @display {label: "Number of Rows"} int numberOfRows)
                                                    returns @tainted error? {
        Sheet sheet = check self->getSheetByName(spreadsheetId, sheetName);
        return self->addRowsAfter(spreadsheetId, <int>sheet.properties?.sheetId, index, numberOfRows);
    }

    remote isolated function createOrUpdateRow(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet Name"} string sheetName,
            @display {label: "Row Position"} int row,
            @display {label: "Row Values"} (int|string|decimal)[] values,
            @display {label: "Value Input Option"} string? valueInputOption = ())
                                                returns @tainted error? {
        string notation = string `${sheetName}!${row}:${row}`;
        (int|string|decimal)[][] rows = [
            from var item in values
            select item
        ];
        Range range = {a1Notation: notation, values: rows};
        GsheetValueRange payload = inToGsheetValueRange(range);
        UpdateValuesResponse _ = check self.gClient->setRange(spreadsheetId, notation, payload, valueInputOption = "RAW");
    }

    remote isolated function getRow(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet Name"} string sheetName,
            @display {label: "Row Position"} int row,
            @display {label: "Value Render Option"} string? valueRenderOption = ())
                                    returns @tainted Row|error {
        string notation = string `${sheetName}!${row}:${row}`;
        GsheetValueRange? valueRange = check self.gClient->getRange(spreadsheetId, notation, valueRenderOption = checkpanic valueRenderOption.ensureType());
        if valueRange == () {
            return error("empty value range");
        }
        return intoRow(intoRange(valueRange));
    }

    remote isolated function deleteRows(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet ID"} int sheetId,
            @display {label: "Starting Row Position"} int row,
            @display {label: "Number of Rows"} int numberOfRows)
                                        returns @tainted error? {
        int:Signed32 startIndex = checkpanic (row - 1).ensureType();
        int:Signed32 endIndex = checkpanic (startIndex + numberOfRows).ensureType();
        DeleteDimensionRequest request = {range: {sheetId: <int:Signed32>sheetId, dimension: "ROWS", startIndex, endIndex}};
        BatchUpdateSpreadsheetResponse _ = check self.gClient->batchUpdate(spreadsheetId, {requests: [{deleteDimension: request}]});
    }

    remote isolated function deleteRowsBySheetName(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet Name"} string sheetName,
            @display {label: "Starting Row Position"} int row,
            @display {label: "Number of Rows"} int numberOfRows)
                                                    returns @tainted error? {
        Sheet sheet = check self->getSheetByName(spreadsheetId, sheetName);
        return self->deleteRows(spreadsheetId, <int>sheet.properties?.sheetId, row, numberOfRows);
    }

    remote isolated function setCell(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet Name"} string sheetName,
            @display {label: "Cell A1 Notation"} string a1Notation,
            @display {label: "Cell Value"} int|string|decimal value,
            @display {label: "Value Input Option"} string? valueInputOption = ())
                                    returns @tainted error? {
        string notation = string `${sheetName}!${a1Notation}`;
        Range range = {a1Notation: notation, values: [[value]]};
        GsheetValueRange payload = inToGsheetValueRange(range);
        UpdateValuesResponse _ = check self.gClient->setRange(spreadsheetId, notation, payload, valueInputOption = "RAW");
    }

    remote isolated function getCell(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet Name"} string sheetName,
            @display {label: "Cell A1 Notation"} string a1Notation,
            @display {label: "Value Render Option"} string? valueRenderOption = ())
                                    returns @tainted Cell|error {
        BatchGetValuesResponse res = check self.gClient->batchGetValues(spreadsheetId, ranges = [sheetName + "!" + a1Notation]);
        return intoCell(res);
    }

    remote isolated function clearCell(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet name"} string sheetName,
            @display {label: "Required Cell A1 Notation"} string a1Notation)
                                        returns @tainted error? {
        return self->clearRange(spreadsheetId, sheetName, a1Notation);
    }

    // NOTE: in cases where we store a float we get a decimal (note that in handcoded version,
    // we are somewhat cheating by returning the parmeter itself here)
    remote isolated function appendValue(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Row Values"} (int|string|decimal|boolean|float)[] values,
            @display {label: "Range A1 Notation"} A1Range a1Range,
            @display {label: "Value Input Option"} string? valueInputOption = ())
                                        returns error|ValueRange {
        string range = check getA1RangeString(a1Range);
        GsheetValueRange payload = {range, majorDimension: "ROWS", values: [values]};
        // TODO: fix valueinput option
        AppendValuesResponse res = check self.gClient->appendValues(spreadsheetId, range, payload, includeValuesInResponse = true, valueInputOption = "RAW", responseValueRenderOption = "UNFORMATTED_VALUE");
        GsheetValueRange? valueRange = res.updates?.updatedData;
        return valueRange != () ? intoValueRange(valueRange) : error("Error appending values");
    }

    remote isolated function copyTo(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet ID"} int sheetId,
            @display {label: "Destination Google Sheet ID"} string destinationId)
                                    returns @tainted error? {
        CopySheetToAnotherSpreadsheetRequest request = {destinationSpreadsheetId: destinationId};
        SheetProperties _ = check self.gClient->copySpreadsheet(spreadsheetId, <int:Signed32>sheetId, request);
    }

    remote isolated function copyToBySheetName(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet Name"} string sheetName,
            @display {label: "Destination Google Sheet ID"} string destinationId)
                                                returns @tainted error? {
        Sheet sheet = check self->getSheetByName(spreadsheetId, sheetName);
        return self->copyTo(spreadsheetId, <int>sheet.properties?.sheetId, destinationId);
    }

    remote isolated function clearAll(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet ID"} int sheetId) returns @tainted error? {
        UpdateCellsRequest request = {fields: "*", range: {sheetId: <int:Signed32>sheetId}, rows: []};
        BatchUpdateSpreadsheetResponse _ = check self.gClient->batchUpdate(spreadsheetId, {requests: [{updateCells: request}]});
    }

    remote isolated function clearAllBySheetName(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet Name"} string sheetName)
                                                returns @tainted error? {
        Sheet sheet = check self->getSheetByName(spreadsheetId, sheetName);
        return self->clearAll(spreadsheetId, <int>sheet.properties?.sheetId);
    }

    remote isolated function setRowMetaData(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet ID"} int sheetId,
            @display {label: "Index of the Row"} int rowIndex,
            @display {label: "Visibility of the Metadata"} Visibility visibility,
            @display {label: "Metadata Key"} string key,
            @display {label: "Metadata Value"} string value)
                                            returns error? {
        CreateDeveloperMetadataRequest request = {
            developerMetadata: {
                location: {
                    dimensionRange: {
                        sheetId: <int:Signed32>sheetId,
                        dimension: "ROWS",
                        startIndex: <int:Signed32>(rowIndex - 1),
                        endIndex: <int:Signed32>rowIndex
                    }
                },
                visibility,
                metadataKey: key,
                metadataValue: value
            }
        };
        BatchUpdateSpreadsheetResponse _ = check self.gClient->batchUpdate(spreadsheetId, {requests: [{createDeveloperMetadata: request}]});
    }

    remote isolated function getRowByDataFilter(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet ID"} int sheetId,
            @display {label: "Filter"} Filter filter)
                                                returns error|ValueRange[] {
        DataFilter dataFilter = intoDataFilter(filter);
        BatchGetValuesByDataFilterRequest request = {dataFilters: [dataFilter], majorDimension: "ROWS"};
        BatchGetValuesByDataFilterResponse res = check self.gClient->batchGetValuesByDataFilter(spreadsheetId, request);
        MatchedValueRange[]? matchedRanges = res.valueRanges;
        if matchedRanges == () {
            // FIXME: not sure why this is the expected behavior
            return [];
        }
        ValueRange?[] vals = from var each in matchedRanges
            select tryIntoValueRange(checkpanic each.valueRange.ensureType());
        return from var each in vals
            where each != ()
            select each;
    }

    remote isolated function updateRowByDataFilter(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet ID"} int sheetId,
            @display {label: "Filter"} Filter filter,
            @display {label: "Row Values"} (int|string|decimal|boolean|float)[] values,
            @display {label: "Value Input Option"} string valueInputOption)
                                                    returns error? {
        // batchUpdateValuesByDataFilter
        DataFilter dataFilter = intoDataFilter(filter);
        DataFilterValueRange filterRange = {dataFilter, values: [values], majorDimension: "ROWS"};
        BatchUpdateValuesByDataFilterRequest request = {
            data: [filterRange],
            includeValuesInResponse: false,
            valueInputOption: check valueInputOption.cloneWithType()
        };
        BatchUpdateValuesByDataFilterResponse _ = check self.gClient->batchUpdateValuesByDataFilter(spreadsheetId, request);
    }

    remote isolated function deleteRowByDataFilter(@display {label: "Google Sheet ID"} string spreadsheetId,
            @display {label: "Worksheet ID"} int sheetId,
            @display {label: "Filter"} Filter filter)
                                                returns error? {
        ValueRange[] values = check self->getRowByDataFilter(spreadsheetId, sheetId, filter);
        DeleteDimensionRequest[] reqs = [];
        foreach var each in values {
            int:Signed32 startIndex = checkpanic (each.rowPosition - 1).ensureType();
            int:Signed32 endIndex = checkpanic each.rowPosition.ensureType();
            DeleteDimensionRequest req = {range: {sheetId: <int:Signed32>sheetId, dimension: "ROWS", startIndex, endIndex}};
            reqs.push(req);
        }
        Request[] requests = from var each in reqs
            select {deleteDimension: each};
        BatchUpdateSpreadsheetResponse _ = check self.gClient->batchUpdate(spreadsheetId, {requests});
    }
}

const string URL_START = "https://docs.google.com/spreadsheets/d/";
const string URL_END = "/edit";

isolated function getIdFromUrl(string url) returns string|error {
    if (!url.startsWith(URL_START)) {
        return error("Invalid url: " + url);
    }
    int? endIndex = url.indexOf(URL_END);
    return endIndex is int ? url.substring(URL_START.length(), endIndex) :
        error("Invalid url: " + url);
}

class SpreadsheetStream {
    private final http:Client httpClient;
    private string? pageToken;
    private File[] currentEntries = [];
    int index = 0;

    isolated function init(http:Client httpClient) returns @tainted error? {
        self.httpClient = httpClient;
        self.pageToken = "";
        self.currentEntries = check self.fetchFiles();
    }

    public isolated function next() returns @tainted record {|File value;|}|error? {
        if self.index < self.currentEntries.length() {
            record {|File value;|} file = {value: self.currentEntries[self.index]};
            self.index += 1;
            return file;
        }
        if self.pageToken !is string {
            return ();
        }
        self.index = 0;
        self.currentEntries = check self.fetchFiles();
        record {|File value;|} file = {value: self.currentEntries[self.index]};
        self.index += 1;
        return file;
    }

    isolated function fetchFiles() returns @tainted File[]|error {
        string drivePath = <@untainted>prepareDriveUrl(self.pageToken);
        json response = check sendRequest(self.httpClient, drivePath);
        FilesResponse|error filesResponse = response.cloneWithType(FilesResponse);
        if filesResponse is error {
            return error("Error occurred while constructing FileResponse record.", filesResponse);
        }
        self.pageToken = filesResponse?.nextPageToken;
        return filesResponse.files;
    }
}

isolated function prepareDriveUrl(string? pageToken = ()) returns string {
    if pageToken != () {
        return string `/drive/v3/files?q=mimeType='application/vnd.google-apps.spreadsheet'&trashed=false&pageToken=${pageToken}`;
    }
    return string `/drive/v3/files?q=mimeType='application/vnd.google-apps.spreadsheet'&trashed=false`;
}

isolated function sendRequest(http:Client httpClient, string path) returns @tainted json|error {
    http:Response|error httpResponse = httpClient->get(<@untainted>path);
    if httpResponse !is http:Response {
        return getSpreadsheetError(httpResponse);
    }
    int statusCode = httpResponse.statusCode;
    json|error jsonResponse = httpResponse.getJsonPayload();
    if jsonResponse !is json {
        return getSpreadsheetError(jsonResponse);
    }
    error? validateStatusCodeRes = validateStatusCode(jsonResponse, statusCode);
    if (validateStatusCodeRes is error) {
        return validateStatusCodeRes;
    }
    return jsonResponse;
}

isolated function validateStatusCode(json response, int statusCode) returns error? {
    if statusCode != http:STATUS_OK {
        return getSpreadsheetError(response);
    }
}

isolated function getSpreadsheetError(json|error errorResponse) returns error {
    if (errorResponse is json) {
        return error(errorResponse.toString());
    }
    return errorResponse;
}

// Conversion functions

isolated function intoHttpClientConfiguration(ConnectionConfig config) returns http:ClientConfiguration|error {
    http:ClientConfiguration httpClientConfig = {
        auth: config.auth,
        httpVersion: config.httpVersion,
        timeout: config.timeout,
        forwarded: config.forwarded,
        poolConfig: config.poolConfig,
        compression: config.compression,
        circuitBreaker: config.circuitBreaker,
        retryConfig: config.retryConfig,
        validation: config.validation
    };
    if config.http1Settings is ClientHttp1Settings {
        ClientHttp1Settings settings = check config.http1Settings.ensureType(ClientHttp1Settings);
        httpClientConfig.http1Settings = {...settings};
    }
    if config.http2Settings is http:ClientHttp2Settings {
        httpClientConfig.http2Settings = check config.http2Settings.ensureType(http:ClientHttp2Settings);
    }
    if config.cache is http:CacheConfig {
        httpClientConfig.cache = check config.cache.ensureType(http:CacheConfig);
    }
    if config.responseLimits is http:ResponseLimitConfigs {
        httpClientConfig.responseLimits = check config.responseLimits.ensureType(http:ResponseLimitConfigs);
    }
    if config.secureSocket is http:ClientSecureSocket {
        httpClientConfig.secureSocket = check config.secureSocket.ensureType(http:ClientSecureSocket);
    }
    if config.proxy is http:ProxyConfig {
        httpClientConfig.proxy = check config.proxy.ensureType(http:ProxyConfig);
    }
    return httpClientConfig;
}

isolated function intoCell(BatchGetValuesResponse res) returns Cell {
    GsheetValueRange[]? valueRanges = res.valueRanges;
    if valueRanges == () {
        panic error("empty value range");
    }
    if valueRanges.length() != 1 {
        panic error("invalid value range");
    }
    anydata[][] values = <anydata[][]>valueRanges[0].values;
    if values.length() != 1 || values[0].length() != 1 {
        panic error("unexpected shape");
    }
    int|decimal|string value = checkpanic values[0][0].ensureType();
    string a1Notation = <string>valueRanges[0].range;
    return {
        a1Notation,
        value
    };
}

isolated function intoRow(Range range) returns Row {
    (int|string|decimal)[][] resVal = range.values;
    if resVal.length() != 1 {
        panic error("invalid row");
    }
    (int|string|decimal)[] values = resVal[0];
    var {startIndex} = intoA1Notation(range.a1Notation);
    if startIndex == () {
        panic error("unexpected a1Notation:" + range.a1Notation);
    }
    int rowPosition = <int>startIndex[1];
    return {
        rowPosition,
        values
    };
}

isolated function intoColumn(Range range) returns Column {
    (int|string|decimal)[][] resVal = range.values;
    (int|string|decimal)[] values = [];
    foreach var row in resVal {
        if row.length() != 1 {
            panic error("invalid column");
        }
        values.push(row[0]);
    }
    var {startIndex} = intoA1Notation(range.a1Notation);
    if startIndex == () {
        panic error("unexpected a1Notation:" + range.a1Notation);
    }
    string columnPosition = <string>startIndex[0];
    return {
        columnPosition,
        values
    };
}

isolated function intoRange(GsheetValueRange valueRange) returns Range {
    return {values: checkpanic valueRange.values.cloneWithType(), a1Notation: <string>valueRange.range};
}

isolated function inToGsheetValueRange(Range range) returns GsheetValueRange {
    return {range: range.a1Notation, values: range.values};
}

isolated function intoDataFilter(Filter filter) returns DataFilter {
    if filter is A1Range {
        return {a1Range: checkpanic getA1RangeString(filter)};
    } else if filter is GridRangeFilter {
        return {gridRange: checkpanic filter.cloneWithType()};
    } else {
        return {developerMetadataLookup: checkpanic filter.cloneWithType()};
    }
}

isolated function tryIntoValueRange(GsheetValueRange valueRange) returns ValueRange? {
    if valueRange.values == () || valueRange.majorDimension == () || valueRange.range == () {
        return ();
    }
    return intoValueRange(valueRange);
}

isolated function intoValueRange(GsheetValueRange valueRange) returns ValueRange {
    anydata[][] tmpValues = <anydata[][]>valueRange.values;
    string range = <string>valueRange.range;
    A1Range a1Range = intoA1Range(range);
    var {startIndex} = intoA1Notation(range);
    if startIndex == () {
        panic error("invalid range" + range);
    }
    int rowPosition = <int>startIndex[1];
    (int|string|decimal|boolean|float)[] values = checkpanic tmpValues[0].cloneWithType();
    return {rowPosition, values, a1Range};
}

type Index [string?, int?];

type A1Notation record {|
    string? sheetName;
    Index? startIndex;
    Index? endIndex;
|};

isolated function intoA1Range(string range) returns A1Range {
    var {sheetName, startIndex, endIndex} = intoA1Notation(range);
    string? sIndex = startIndex != () ? intoString(startIndex) : ();
    string? eIndex = endIndex != () ? intoString(endIndex) : ();
    if sheetName == () {
        panic error("sheet name is required");
    }
    return {
        sheetName,
        startIndex: sIndex,
        endIndex: eIndex
    };
}

isolated function intoString(Index index) returns string {
    var [column, row] = index;
    string rowString = row == () ? "" : row.toString();
    string columnString = column ?: "";
    return columnString + rowString;
}

isolated function intoA1Notation(string notation) returns A1Notation {
    string:RegExp a1Patter = re `(.*!)?([A-Z]*[0-9]*):?([A-Z]*[0-9]*)`;
    regexp:Groups? groups = a1Patter.findGroups(notation);
    if groups == () {
        panic error("invalid A1 notation: " + notation);
    }
    regexp:Span? nameSpan = groups[1];
    regexp:Span? startColumnSpan = groups[2];
    regexp:Span? endColumnSpan = groups[3];
    string? sheetName = nameSpan != () ? nameSpan.substring() : ();
    Index? startIndex = startColumnSpan != () ? parseIndex(startColumnSpan.substring()) : ();
    Index? endIndex = endColumnSpan != () ? parseIndex(endColumnSpan.substring()) : ();
    return {
        sheetName,
        startIndex,
        endIndex
    };
}

isolated function parseIndex(string index) returns Index? {
    if index.length() == 0 {
        return ();
    }
    string:RegExp indexPattern = re `([A-Z]*)([0-9]*)`;
    regexp:Groups? groups = indexPattern.findGroups(index);
    if groups == () {
        return ();
    }
    regexp:Span? columnSpan = groups[1];
    regexp:Span? rowSpan = groups[2];
    string? column = columnSpan != () ? columnSpan.substring() : ();
    int? row = rowSpan != () ? checkpanic int:fromString(rowSpan.substring()) : ();
    return [column, row];
}

isolated function getA1RangeString(A1Range a1Range) returns string|error {
    string filter = a1Range.sheetName;
    if a1Range.startIndex == () && a1Range.endIndex != () {
        return error("Error: The provided A1 range is not supported. ");
    }
    if a1Range.startIndex != () {
        filter = string `${filter}!${<string>a1Range.startIndex}`;
    }
    if a1Range.endIndex != () {
        filter = string `${filter}:${<string>a1Range.endIndex}`;
    }
    return filter;
}