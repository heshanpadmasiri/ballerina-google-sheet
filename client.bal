import ballerina/http;

# Reads and writes Google Sheets.
isolated client class GsheetClient {
    final http:Client clientEp;
    # Gets invoked to initialize the `connector`.
    #
    # + config - The configurations to be used when initializing the `connector` 
    # + serviceUrl - URL of the target service 
    # + return - An error if connector initialization failed 
    public isolated function init(ConnectionConfig config, string serviceUrl = "https://sheets.googleapis.com/") returns error? {
        http:ClientConfiguration httpClientConfig = {auth: config.auth, httpVersion: config.httpVersion, timeout: config.timeout, forwarded: config.forwarded, poolConfig: config.poolConfig, compression: config.compression, circuitBreaker: config.circuitBreaker, retryConfig: config.retryConfig, validation: config.validation};
        do {
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
        }
        http:Client httpEp = check new (serviceUrl, httpClientConfig);
        self.clientEp = httpEp;
        return;
    }
    # Creates a spreadsheet, returning the newly created spreadsheet.
    #
    # + xgafv - V1 error format.
    # + access_token - OAuth access token.
    # + alt - Data format for response.
    # + callback - JSONP
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
    # + upload_protocol - Upload protocol for media (e.g. "raw", "multipart").
    # + uploadType - Legacy upload protocol for media (e.g. "media", "multipart").
    # + return - Successful response 
    remote isolated function createSpreadsheet(Spreadsheet payload, "1"|"2"? xgafv = (), string? access_token = (), "json"|"media"|"proto"? alt = (), string? callback = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? upload_protocol = (), string? uploadType = ()) returns Spreadsheet|error {
        string resourcePath = string `/v4/spreadsheets`;
        map<anydata> queryParam = {"$.xgafv": xgafv, "access_token": access_token, "alt": alt, "callback": callback, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "upload_protocol": upload_protocol, "uploadType": uploadType};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        Spreadsheet response = check self.clientEp->post(resourcePath, request);
        return response;
    }
    # Returns the spreadsheet at the given ID. The caller must specify the spreadsheet ID. By default, data within grids is not returned. You can include grid data in one of 2 ways: * Specify a [field mask](https://developers.google.com/sheets/api/guides/field-masks) listing your desired fields using the `fields` URL parameter in HTTP * Set the includeGridData URL parameter to true. If a field mask is set, the `includeGridData` parameter is ignored For large spreadsheets, as a best practice, retrieve only the specific spreadsheet fields that you want. To retrieve only subsets of spreadsheet data, use the ranges URL parameter. Ranges are specified using [A1 notation](/sheets/api/guides/concepts#cell). You can define a single cell (for example, `A1`) or multiple cells (for example, `A1:D5`). You can also get cells from other sheets within the same spreadsheet (for example, `Sheet2!A1:C4`) or retrieve multiple ranges at once (for example, `?ranges=A1:D5&ranges=Sheet2!A1:C4`). Limiting the range returns only the portions of the spreadsheet that intersect the requested ranges.
    #
    # + xgafv - V1 error format.
    # + access_token - OAuth access token.
    # + alt - Data format for response.
    # + callback - JSONP
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
    # + upload_protocol - Upload protocol for media (e.g. "raw", "multipart").
    # + uploadType - Legacy upload protocol for media (e.g. "media", "multipart").
    # + spreadsheetId - The spreadsheet to request.
    # + includeGridData - True if grid data should be returned. This parameter is ignored if a field mask was set in the request.
    # + ranges - The ranges to retrieve from the spreadsheet.
    # + return - Successful response 
    remote isolated function getSpreadsheetById(string spreadsheetId, "1"|"2"? xgafv = (), string? access_token = (), "json"|"media"|"proto"? alt = (), string? callback = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? upload_protocol = (), string? uploadType = (), boolean? includeGridData = (), string[]? ranges = ()) returns Spreadsheet|error {
        string resourcePath = string `/v4/spreadsheets/${getEncodedUri(spreadsheetId)}`;
        map<anydata> queryParam = {"$.xgafv": xgafv, "access_token": access_token, "alt": alt, "callback": callback, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "upload_protocol": upload_protocol, "uploadType": uploadType, "includeGridData": includeGridData, "ranges": ranges};
        map<Encoding> queryParamEncoding = {"ranges": {style: FORM, explode: true}};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam, queryParamEncoding);
        Spreadsheet response = check self.clientEp->get(resourcePath);
        return response;
    }
    # Returns the developer metadata with the specified ID. The caller must specify the spreadsheet ID and the developer metadata's unique metadataId.
    #
    # + xgafv - V1 error format.
    # + access_token - OAuth access token.
    # + alt - Data format for response.
    # + callback - JSONP
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
    # + upload_protocol - Upload protocol for media (e.g. "raw", "multipart").
    # + uploadType - Legacy upload protocol for media (e.g. "media", "multipart").
    # + spreadsheetId - The ID of the spreadsheet to retrieve metadata from.
    # + metadataId - The ID of the developer metadata to retrieve.
    # + return - Successful response 
    remote isolated function getDeveloperMetadata(string spreadsheetId, int metadataId, "1"|"2"? xgafv = (), string? access_token = (), "json"|"media"|"proto"? alt = (), string? callback = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? upload_protocol = (), string? uploadType = ()) returns DeveloperMetadata|error {
        string resourcePath = string `/v4/spreadsheets/${getEncodedUri(spreadsheetId)}/developerMetadata/${getEncodedUri(metadataId)}`;
        map<anydata> queryParam = {"$.xgafv": xgafv, "access_token": access_token, "alt": alt, "callback": callback, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "upload_protocol": upload_protocol, "uploadType": uploadType};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        DeveloperMetadata response = check self.clientEp->get(resourcePath);
        return response;
    }
    # Returns all developer metadata matching the specified DataFilter. If the provided DataFilter represents a DeveloperMetadataLookup object, this will return all DeveloperMetadata entries selected by it. If the DataFilter represents a location in a spreadsheet, this will return all developer metadata associated with locations intersecting that region.
    #
    # + xgafv - V1 error format.
    # + access_token - OAuth access token.
    # + alt - Data format for response.
    # + callback - JSONP
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
    # + upload_protocol - Upload protocol for media (e.g. "raw", "multipart").
    # + uploadType - Legacy upload protocol for media (e.g. "media", "multipart").
    # + spreadsheetId - The ID of the spreadsheet to retrieve metadata from.
    # + return - Successful response 
    remote isolated function searchForDeveloperMetadata(string spreadsheetId, SearchDeveloperMetadataRequest payload, "1"|"2"? xgafv = (), string? access_token = (), "json"|"media"|"proto"? alt = (), string? callback = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? upload_protocol = (), string? uploadType = ()) returns SearchDeveloperMetadataResponse|error {
        string resourcePath = string `/v4/spreadsheets/${getEncodedUri(spreadsheetId)}/developerMetadata:search`;
        map<anydata> queryParam = {"$.xgafv": xgafv, "access_token": access_token, "alt": alt, "callback": callback, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "upload_protocol": upload_protocol, "uploadType": uploadType};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        SearchDeveloperMetadataResponse response = check self.clientEp->post(resourcePath, request);
        return response;
    }
    # Copies a single sheet from a spreadsheet to another spreadsheet. Returns the properties of the newly created sheet.
    #
    # + xgafv - V1 error format.
    # + access_token - OAuth access token.
    # + alt - Data format for response.
    # + callback - JSONP
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
    # + upload_protocol - Upload protocol for media (e.g. "raw", "multipart").
    # + uploadType - Legacy upload protocol for media (e.g. "media", "multipart").
    # + spreadsheetId - The ID of the spreadsheet containing the sheet to copy.
    # + sheetId - The ID of the sheet to copy.
    # + return - Successful response 
    remote isolated function copySpreadsheet(string spreadsheetId, int sheetId, CopySheetToAnotherSpreadsheetRequest payload, "1"|"2"? xgafv = (), string? access_token = (), "json"|"media"|"proto"? alt = (), string? callback = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? upload_protocol = (), string? uploadType = ()) returns SheetProperties|error {
        string resourcePath = string `/v4/spreadsheets/${getEncodedUri(spreadsheetId)}/sheets/${getEncodedUri(sheetId)}:copyTo`;
        map<anydata> queryParam = {"$.xgafv": xgafv, "access_token": access_token, "alt": alt, "callback": callback, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "upload_protocol": upload_protocol, "uploadType": uploadType};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        SheetProperties response = check self.clientEp->post(resourcePath, request);
        return response;
    }
    # Returns a range of values from a spreadsheet. The caller must specify the spreadsheet ID and a range.
    #
    # + xgafv - V1 error format.
    # + access_token - OAuth access token.
    # + alt - Data format for response.
    # + callback - JSONP
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
    # + upload_protocol - Upload protocol for media (e.g. "raw", "multipart").
    # + uploadType - Legacy upload protocol for media (e.g. "media", "multipart").
    # + spreadsheetId - The ID of the spreadsheet to retrieve data from.
    # + range - The [A1 notation or R1C1 notation](/sheets/api/guides/concepts#cell) of the range to retrieve values from.
    # + dateTimeRenderOption - How dates, times, and durations should be represented in the output. This is ignored if value_render_option is FORMATTED_VALUE. The default dateTime render option is SERIAL_NUMBER.
    # + majorDimension - The major dimension that results should use. For example, if the spreadsheet data in Sheet1 is: `A1=1,B1=2,A2=3,B2=4`, then requesting `range=Sheet1!A1:B2?majorDimension=ROWS` returns `[[1,2],[3,4]]`, whereas requesting `range=Sheet1!A1:B2?majorDimension=COLUMNS` returns `[[1,3],[2,4]]`.
    # + valueRenderOption - How values should be represented in the output. The default render option is FORMATTED_VALUE.
    # + return - Successful response 
    remote isolated function getRange(string spreadsheetId, string range, "1"|"2"? xgafv = (), string? access_token = (), "json"|"media"|"proto"? alt = (), string? callback = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? upload_protocol = (), string? uploadType = (), "SERIAL_NUMBER"|"FORMATTED_STRING"? dateTimeRenderOption = (), "DIMENSION_UNSPECIFIED"|"ROWS"|"COLUMNS"? majorDimension = (), "FORMATTED_VALUE"|"UNFORMATTED_VALUE"|"FORMULA"? valueRenderOption = ()) returns GsheetValueRange|error {
        string resourcePath = string `/v4/spreadsheets/${getEncodedUri(spreadsheetId)}/values/${getEncodedUri(range)}`;
        map<anydata> queryParam = {"$.xgafv": xgafv, "access_token": access_token, "alt": alt, "callback": callback, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "upload_protocol": upload_protocol, "uploadType": uploadType, "dateTimeRenderOption": dateTimeRenderOption, "majorDimension": majorDimension, "valueRenderOption": valueRenderOption};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        GsheetValueRange response = check self.clientEp->get(resourcePath);
        return response;
    }
    # Sets values in a range of a spreadsheet. The caller must specify the spreadsheet ID, range, and a valueInputOption.
    #
    # + xgafv - V1 error format.
    # + access_token - OAuth access token.
    # + alt - Data format for response.
    # + callback - JSONP
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
    # + upload_protocol - Upload protocol for media (e.g. "raw", "multipart").
    # + uploadType - Legacy upload protocol for media (e.g. "media", "multipart").
    # + spreadsheetId - The ID of the spreadsheet to update.
    # + range - The [A1 notation](/sheets/api/guides/concepts#cell) of the values to update.
    # + includeValuesInResponse - Determines if the update response should include the values of the cells that were updated. By default, responses do not include the updated values. If the range to write was larger than the range actually written, the response includes all values in the requested range (excluding trailing empty rows and columns).
    # + responseDateTimeRenderOption - Determines how dates, times, and durations in the response should be rendered. This is ignored if response_value_render_option is FORMATTED_VALUE. The default dateTime render option is SERIAL_NUMBER.
    # + responseValueRenderOption - Determines how values in the response should be rendered. The default render option is FORMATTED_VALUE.
    # + valueInputOption - How the input data should be interpreted.
    # + return - Successful response 
    remote isolated function setRange(string spreadsheetId, string range, GsheetValueRange payload, "1"|"2"? xgafv = (), string? access_token = (), "json"|"media"|"proto"? alt = (), string? callback = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? upload_protocol = (), string? uploadType = (), boolean? includeValuesInResponse = (), "SERIAL_NUMBER"|"FORMATTED_STRING"? responseDateTimeRenderOption = (), "FORMATTED_VALUE"|"UNFORMATTED_VALUE"|"FORMULA"? responseValueRenderOption = (), "INPUT_VALUE_OPTION_UNSPECIFIED"|"RAW"|"USER_ENTERED"? valueInputOption = ()) returns UpdateValuesResponse|error {
        string resourcePath = string `/v4/spreadsheets/${getEncodedUri(spreadsheetId)}/values/${getEncodedUri(range)}`;
        map<anydata> queryParam = {"$.xgafv": xgafv, "access_token": access_token, "alt": alt, "callback": callback, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "upload_protocol": upload_protocol, "uploadType": uploadType, "includeValuesInResponse": includeValuesInResponse, "responseDateTimeRenderOption": responseDateTimeRenderOption, "responseValueRenderOption": responseValueRenderOption, "valueInputOption": valueInputOption};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        UpdateValuesResponse response = check self.clientEp->put(resourcePath, request);
        return response;
    }
    # Appends values to a spreadsheet. The input range is used to search for existing data and find a "table" within that range. Values will be appended to the next row of the table, starting with the first column of the table. See the [guide](/sheets/api/guides/values#appending_values) and [sample code](/sheets/api/samples/writing#append_values) for specific details of how tables are detected and data is appended. The caller must specify the spreadsheet ID, range, and a valueInputOption. The `valueInputOption` only controls how the input data will be added to the sheet (column-wise or row-wise), it does not influence what cell the data starts being written to.
    #
    # + xgafv - V1 error format.
    # + access_token - OAuth access token.
    # + alt - Data format for response.
    # + callback - JSONP
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
    # + upload_protocol - Upload protocol for media (e.g. "raw", "multipart").
    # + uploadType - Legacy upload protocol for media (e.g. "media", "multipart").
    # + spreadsheetId - The ID of the spreadsheet to update.
    # + range - The [A1 notation](/sheets/api/guides/concepts#cell) of a range to search for a logical table of data. Values are appended after the last row of the table.
    # + includeValuesInResponse - Determines if the update response should include the values of the cells that were appended. By default, responses do not include the updated values.
    # + insertDataOption - How the input data should be inserted.
    # + responseDateTimeRenderOption - Determines how dates, times, and durations in the response should be rendered. This is ignored if response_value_render_option is FORMATTED_VALUE. The default dateTime render option is SERIAL_NUMBER.
    # + responseValueRenderOption - Determines how values in the response should be rendered. The default render option is FORMATTED_VALUE.
    # + valueInputOption - How the input data should be interpreted.
    # + return - Successful response 
    remote isolated function appendValues(string spreadsheetId, string range, GsheetValueRange payload, "1"|"2"? xgafv = (), string? access_token = (), "json"|"media"|"proto"? alt = (), string? callback = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? upload_protocol = (), string? uploadType = (), boolean? includeValuesInResponse = (), "OVERWRITE"|"INSERT_ROWS"? insertDataOption = (), "SERIAL_NUMBER"|"FORMATTED_STRING"? responseDateTimeRenderOption = (), "FORMATTED_VALUE"|"UNFORMATTED_VALUE"|"FORMULA"? responseValueRenderOption = (), "INPUT_VALUE_OPTION_UNSPECIFIED"|"RAW"|"USER_ENTERED"? valueInputOption = ()) returns AppendValuesResponse|error {
        string resourcePath = string `/v4/spreadsheets/${getEncodedUri(spreadsheetId)}/values/${getEncodedUri(range)}:append`;
        map<anydata> queryParam = {"$.xgafv": xgafv, "access_token": access_token, "alt": alt, "callback": callback, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "upload_protocol": upload_protocol, "uploadType": uploadType, "includeValuesInResponse": includeValuesInResponse, "insertDataOption": insertDataOption, "responseDateTimeRenderOption": responseDateTimeRenderOption, "responseValueRenderOption": responseValueRenderOption, "valueInputOption": valueInputOption};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        AppendValuesResponse response = check self.clientEp->post(resourcePath, request);
        return response;
    }
    # Clears values from a spreadsheet. The caller must specify the spreadsheet ID and range. Only values are cleared -- all other properties of the cell (such as formatting, data validation, etc..) are kept.
    #
    # + xgafv - V1 error format.
    # + access_token - OAuth access token.
    # + alt - Data format for response.
    # + callback - JSONP
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
    # + upload_protocol - Upload protocol for media (e.g. "raw", "multipart").
    # + uploadType - Legacy upload protocol for media (e.g. "media", "multipart").
    # + spreadsheetId - The ID of the spreadsheet to update.
    # + range - The [A1 notation or R1C1 notation](/sheets/api/guides/concepts#cell) of the values to clear.
    # + return - Successful response 
    remote isolated function clearValues(string spreadsheetId, string range, ClearValuesRequest payload, "1"|"2"? xgafv = (), string? access_token = (), "json"|"media"|"proto"? alt = (), string? callback = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? upload_protocol = (), string? uploadType = ()) returns ClearValuesResponse|error {
        string resourcePath = string `/v4/spreadsheets/${getEncodedUri(spreadsheetId)}/values/${getEncodedUri(range)}:clear`;
        map<anydata> queryParam = {"$.xgafv": xgafv, "access_token": access_token, "alt": alt, "callback": callback, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "upload_protocol": upload_protocol, "uploadType": uploadType};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        ClearValuesResponse response = check self.clientEp->post(resourcePath, request);
        return response;
    }
    # Clears one or more ranges of values from a spreadsheet. The caller must specify the spreadsheet ID and one or more ranges. Only values are cleared -- all other properties of the cell (such as formatting and data validation) are kept.
    #
    # + xgafv - V1 error format.
    # + access_token - OAuth access token.
    # + alt - Data format for response.
    # + callback - JSONP
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
    # + upload_protocol - Upload protocol for media (e.g. "raw", "multipart").
    # + uploadType - Legacy upload protocol for media (e.g. "media", "multipart").
    # + spreadsheetId - The ID of the spreadsheet to update.
    # + return - Successful response 
    remote isolated function batchClearValues(string spreadsheetId, BatchClearValuesRequest payload, "1"|"2"? xgafv = (), string? access_token = (), "json"|"media"|"proto"? alt = (), string? callback = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? upload_protocol = (), string? uploadType = ()) returns BatchClearValuesResponse|error {
        string resourcePath = string `/v4/spreadsheets/${getEncodedUri(spreadsheetId)}/values:batchClear`;
        map<anydata> queryParam = {"$.xgafv": xgafv, "access_token": access_token, "alt": alt, "callback": callback, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "upload_protocol": upload_protocol, "uploadType": uploadType};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        BatchClearValuesResponse response = check self.clientEp->post(resourcePath, request);
        return response;
    }
    # Clears one or more ranges of values from a spreadsheet. The caller must specify the spreadsheet ID and one or more DataFilters. Ranges matching any of the specified data filters will be cleared. Only values are cleared -- all other properties of the cell (such as formatting, data validation, etc..) are kept.
    #
    # + xgafv - V1 error format.
    # + access_token - OAuth access token.
    # + alt - Data format for response.
    # + callback - JSONP
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
    # + upload_protocol - Upload protocol for media (e.g. "raw", "multipart").
    # + uploadType - Legacy upload protocol for media (e.g. "media", "multipart").
    # + spreadsheetId - The ID of the spreadsheet to update.
    # + return - Successful response 
    remote isolated function batchClearValuesByDataFilter(string spreadsheetId, BatchClearValuesByDataFilterRequest payload, "1"|"2"? xgafv = (), string? access_token = (), "json"|"media"|"proto"? alt = (), string? callback = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? upload_protocol = (), string? uploadType = ()) returns BatchClearValuesByDataFilterResponse|error {
        string resourcePath = string `/v4/spreadsheets/${getEncodedUri(spreadsheetId)}/values:batchClearByDataFilter`;
        map<anydata> queryParam = {"$.xgafv": xgafv, "access_token": access_token, "alt": alt, "callback": callback, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "upload_protocol": upload_protocol, "uploadType": uploadType};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        BatchClearValuesByDataFilterResponse response = check self.clientEp->post(resourcePath, request);
        return response;
    }
    # Returns one or more ranges of values from a spreadsheet. The caller must specify the spreadsheet ID and one or more ranges.
    #
    # + xgafv - V1 error format.
    # + access_token - OAuth access token.
    # + alt - Data format for response.
    # + callback - JSONP
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
    # + upload_protocol - Upload protocol for media (e.g. "raw", "multipart").
    # + uploadType - Legacy upload protocol for media (e.g. "media", "multipart").
    # + spreadsheetId - The ID of the spreadsheet to retrieve data from.
    # + dateTimeRenderOption - How dates, times, and durations should be represented in the output. This is ignored if value_render_option is FORMATTED_VALUE. The default dateTime render option is SERIAL_NUMBER.
    # + majorDimension - The major dimension that results should use. For example, if the spreadsheet data is: `A1=1,B1=2,A2=3,B2=4`, then requesting `ranges=["A1:B2"],majorDimension=ROWS` returns `[[1,2],[3,4]]`, whereas requesting `ranges=["A1:B2"],majorDimension=COLUMNS` returns `[[1,3],[2,4]]`.
    # + ranges - The [A1 notation or R1C1 notation](/sheets/api/guides/concepts#cell) of the range to retrieve values from.
    # + valueRenderOption - How values should be represented in the output. The default render option is ValueRenderOption.FORMATTED_VALUE.
    # + return - Successful response 
    remote isolated function batchGetValues(string spreadsheetId, "1"|"2"? xgafv = (), string? access_token = (), "json"|"media"|"proto"? alt = (), string? callback = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? upload_protocol = (), string? uploadType = (), "SERIAL_NUMBER"|"FORMATTED_STRING"? dateTimeRenderOption = (), "DIMENSION_UNSPECIFIED"|"ROWS"|"COLUMNS"? majorDimension = (), string[]? ranges = (), "FORMATTED_VALUE"|"UNFORMATTED_VALUE"|"FORMULA"? valueRenderOption = ()) returns BatchGetValuesResponse|error {
        string resourcePath = string `/v4/spreadsheets/${getEncodedUri(spreadsheetId)}/values:batchGet`;
        map<anydata> queryParam = {"$.xgafv": xgafv, "access_token": access_token, "alt": alt, "callback": callback, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "upload_protocol": upload_protocol, "uploadType": uploadType, "dateTimeRenderOption": dateTimeRenderOption, "majorDimension": majorDimension, "ranges": ranges, "valueRenderOption": valueRenderOption};
        map<Encoding> queryParamEncoding = {"ranges": {style: FORM, explode: true}};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam, queryParamEncoding);
        BatchGetValuesResponse response = check self.clientEp->get(resourcePath);
        return response;
    }
    # Returns one or more ranges of values that match the specified data filters. The caller must specify the spreadsheet ID and one or more DataFilters. Ranges that match any of the data filters in the request will be returned.
    #
    # + xgafv - V1 error format.
    # + access_token - OAuth access token.
    # + alt - Data format for response.
    # + callback - JSONP
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
    # + upload_protocol - Upload protocol for media (e.g. "raw", "multipart").
    # + uploadType - Legacy upload protocol for media (e.g. "media", "multipart").
    # + spreadsheetId - The ID of the spreadsheet to retrieve data from.
    # + return - Successful response 
    remote isolated function batchGetValuesByDataFilter(string spreadsheetId, BatchGetValuesByDataFilterRequest payload, "1"|"2"? xgafv = (), string? access_token = (), "json"|"media"|"proto"? alt = (), string? callback = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? upload_protocol = (), string? uploadType = ()) returns BatchGetValuesByDataFilterResponse|error {
        string resourcePath = string `/v4/spreadsheets/${getEncodedUri(spreadsheetId)}/values:batchGetByDataFilter`;
        map<anydata> queryParam = {"$.xgafv": xgafv, "access_token": access_token, "alt": alt, "callback": callback, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "upload_protocol": upload_protocol, "uploadType": uploadType};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        BatchGetValuesByDataFilterResponse response = check self.clientEp->post(resourcePath, request);
        return response;
    }
    # Sets values in one or more ranges of a spreadsheet. The caller must specify the spreadsheet ID, a valueInputOption, and one or more GsheetValueRanges.
    #
    # + xgafv - V1 error format.
    # + access_token - OAuth access token.
    # + alt - Data format for response.
    # + callback - JSONP
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
    # + upload_protocol - Upload protocol for media (e.g. "raw", "multipart").
    # + uploadType - Legacy upload protocol for media (e.g. "media", "multipart").
    # + spreadsheetId - The ID of the spreadsheet to update.
    # + return - Successful response 
    remote isolated function batchUpdateValues(string spreadsheetId, BatchUpdateValuesRequest payload, "1"|"2"? xgafv = (), string? access_token = (), "json"|"media"|"proto"? alt = (), string? callback = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? upload_protocol = (), string? uploadType = ()) returns BatchUpdateValuesResponse|error {
        string resourcePath = string `/v4/spreadsheets/${getEncodedUri(spreadsheetId)}/values:batchUpdate`;
        map<anydata> queryParam = {"$.xgafv": xgafv, "access_token": access_token, "alt": alt, "callback": callback, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "upload_protocol": upload_protocol, "uploadType": uploadType};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        BatchUpdateValuesResponse response = check self.clientEp->post(resourcePath, request);
        return response;
    }
    # Sets values in one or more ranges of a spreadsheet. The caller must specify the spreadsheet ID, a valueInputOption, and one or more DataFilterValueRanges.
    #
    # + xgafv - V1 error format.
    # + access_token - OAuth access token.
    # + alt - Data format for response.
    # + callback - JSONP
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
    # + upload_protocol - Upload protocol for media (e.g. "raw", "multipart").
    # + uploadType - Legacy upload protocol for media (e.g. "media", "multipart").
    # + spreadsheetId - The ID of the spreadsheet to update.
    # + return - Successful response 
    remote isolated function batchUpdateValuesByDataFilter(string spreadsheetId, BatchUpdateValuesByDataFilterRequest payload, "1"|"2"? xgafv = (), string? access_token = (), "json"|"media"|"proto"? alt = (), string? callback = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? upload_protocol = (), string? uploadType = ()) returns BatchUpdateValuesByDataFilterResponse|error {
        string resourcePath = string `/v4/spreadsheets/${getEncodedUri(spreadsheetId)}/values:batchUpdateByDataFilter`;
        map<anydata> queryParam = {"$.xgafv": xgafv, "access_token": access_token, "alt": alt, "callback": callback, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "upload_protocol": upload_protocol, "uploadType": uploadType};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        BatchUpdateValuesByDataFilterResponse response = check self.clientEp->post(resourcePath, request);
        return response;
    }
    # Applies one or more updates to the spreadsheet. Each request is validated before being applied. If any request is not valid then the entire request will fail and nothing will be applied. Some requests have replies to give you some information about how they are applied. The replies will mirror the requests. For example, if you applied 4 updates and the 3rd one had a reply, then the response will have 2 empty replies, the actual reply, and another empty reply, in that order. Due to the collaborative nature of spreadsheets, it is not guaranteed that the spreadsheet will reflect exactly your changes after this completes, however it is guaranteed that the updates in the request will be applied together atomically. Your changes may be altered with respect to collaborator changes. If there are no collaborators, the spreadsheet should reflect your changes.
    #
    # + xgafv - V1 error format.
    # + access_token - OAuth access token.
    # + alt - Data format for response.
    # + callback - JSONP
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
    # + upload_protocol - Upload protocol for media (e.g. "raw", "multipart").
    # + uploadType - Legacy upload protocol for media (e.g. "media", "multipart").
    # + spreadsheetId - The spreadsheet to apply the updates to.
    # + return - Successful response 
    remote isolated function batchUpdate(string spreadsheetId, BatchUpdateSpreadsheetRequest payload, "1"|"2"? xgafv = (), string? access_token = (), "json"|"media"|"proto"? alt = (), string? callback = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? upload_protocol = (), string? uploadType = ()) returns BatchUpdateSpreadsheetResponse|error {
        string resourcePath = string `/v4/spreadsheets/${getEncodedUri(spreadsheetId)}:batchUpdate`;
        map<anydata> queryParam = {"$.xgafv": xgafv, "access_token": access_token, "alt": alt, "callback": callback, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "upload_protocol": upload_protocol, "uploadType": uploadType};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        BatchUpdateSpreadsheetResponse response = check self.clientEp->post(resourcePath, request);
        return response;
    }
    # Returns the spreadsheet at the given ID. The caller must specify the spreadsheet ID. This method differs from GetSpreadsheet in that it allows selecting which subsets of spreadsheet data to return by specifying a dataFilters parameter. Multiple DataFilters can be specified. Specifying one or more data filters returns the portions of the spreadsheet that intersect ranges matched by any of the filters. By default, data within grids is not returned. You can include grid data one of 2 ways: * Specify a [field mask](https://developers.google.com/sheets/api/guides/field-masks) listing your desired fields using the `fields` URL parameter in HTTP * Set the includeGridData parameter to true. If a field mask is set, the `includeGridData` parameter is ignored For large spreadsheets, as a best practice, retrieve only the specific spreadsheet fields that you want.
    #
    # + xgafv - V1 error format.
    # + access_token - OAuth access token.
    # + alt - Data format for response.
    # + callback - JSONP
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
    # + upload_protocol - Upload protocol for media (e.g. "raw", "multipart").
    # + uploadType - Legacy upload protocol for media (e.g. "media", "multipart").
    # + spreadsheetId - The spreadsheet to request.
    # + return - Successful response 
    remote isolated function getSpreadsheetByDataFilter(string spreadsheetId, GetSpreadsheetByDataFilterRequest payload, "1"|"2"? xgafv = (), string? access_token = (), "json"|"media"|"proto"? alt = (), string? callback = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? upload_protocol = (), string? uploadType = ()) returns Spreadsheet|error {
        string resourcePath = string `/v4/spreadsheets/${getEncodedUri(spreadsheetId)}:getByDataFilter`;
        map<anydata> queryParam = {"$.xgafv": xgafv, "access_token": access_token, "alt": alt, "callback": callback, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "upload_protocol": upload_protocol, "uploadType": uploadType};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        Spreadsheet response = check self.clientEp->post(resourcePath, request);
        return response;
    }
}
