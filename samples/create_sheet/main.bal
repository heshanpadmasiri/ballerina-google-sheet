import ballerina/os;
import heshan/ballerina_google_sheet as sheet;
import ballerina/io;

public function main() returns error? {
    string refreshToken = os:getEnv("REFRESH_TOKEN");
    string clientId = os:getEnv("CLIENT_ID");
    string clientSecret = os:getEnv("CLIENT_SECRET");

    sheet:ConnectionConfig config = {
        auth: {
            clientId,
            clientSecret,
            refreshUrl: "https://www.googleapis.com/oauth2/v3/token",
            refreshToken
        }
    };
    sheet:Client gsheetClient = checkpanic new (config);
    sheet:Spreadsheet spreadSheet = check gsheetClient->createSpreadsheet("Delete me");
    string? title = spreadSheet.properties?.title;
    io:println(title); // @output Delete me
}
