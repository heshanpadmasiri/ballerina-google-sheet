import ballerina/http;

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
        if (self.index < self.currentEntries.length()) {
            record {|File value;|} file = {value: self.currentEntries[self.index]};
            self.index += 1;
            return file;
        }

        if (self.pageToken is string) {
            self.index = 0;
            self.currentEntries = check self.fetchFiles();
            record {|File value;|} file = {value: self.currentEntries[self.index]};
            self.index += 1;
            return file;
        }

        return;
    }

    isolated function fetchFiles() returns @tainted File[]|error {
        string drivePath = <@untainted>prepareDriveUrl(self.pageToken);
        json response = check sendRequest(self.httpClient, drivePath);
        FilesResponse|error filesResponse = response.cloneWithType(FilesResponse);
        if (filesResponse is FilesResponse) {
            self.pageToken = filesResponse?.nextPageToken;
            return filesResponse.files;
        } else {
            return error("Error occurred while constructing FileResponse record.", filesResponse);
        }
    }
}

// FIXME: inline these
const string DRIVE_URL = "https://www.googleapis.com";
const string DRIVE_PATH = "/drive/v3";
const string FILES = "/files";
const string Q = "q";
const string MIME_TYPE = "mimeType";
const string APPLICATION = "'application/vnd.google-apps.spreadsheet'";
const string AND = "&";
const string AND_SIGN = "and";
const string TRASH_FALSE ="trashed=false";
const string PAGE_TOKEN = "pageToken";
const string QUESTION_MARK = "?";
const string EQUAL = "=";

isolated function prepareDriveUrl(string? pageToken = ()) returns string {
    string drivePath;
    if (pageToken is string) {
        drivePath = DRIVE_PATH + FILES + QUESTION_MARK + Q + EQUAL + MIME_TYPE + EQUAL + APPLICATION + 
            AND_SIGN + TRASH_FALSE + AND + PAGE_TOKEN + EQUAL + pageToken;
        return drivePath;
    }
    drivePath = DRIVE_PATH + FILES + QUESTION_MARK + Q + EQUAL + MIME_TYPE + EQUAL + APPLICATION + AND_SIGN + 
        TRASH_FALSE;
    return drivePath;
}

isolated function sendRequest(http:Client httpClient, string path) returns @tainted json | error {
    http:Response|error httpResponse = httpClient->get(<@untainted>path);
    if (httpResponse is http:Response) {
        int statusCode = httpResponse.statusCode;
        json | error jsonResponse = httpResponse.getJsonPayload();
        if (jsonResponse is json) {
            error? validateStatusCodeRes = validateStatusCode(jsonResponse, statusCode);
            if (validateStatusCodeRes is error) {
                return validateStatusCodeRes;
            }
            return jsonResponse;
        } else {
            return getSpreadsheetError(jsonResponse);
        }
    } else {
        return getSpreadsheetError(<json|error>httpResponse);
    }
}

isolated function validateStatusCode(json response, int statusCode) returns error? {
    if (!(statusCode == http:STATUS_OK)) {
        return getSpreadsheetError(response);
    }
}

isolated function getSpreadsheetError(json|error errorResponse) returns error {
  if (errorResponse is json) {
        return error(errorResponse.toString());
  } else {
        return errorResponse;
  }
}
