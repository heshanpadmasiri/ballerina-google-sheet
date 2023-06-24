import ballerina/test;
import ballerina/os;

configurable string & readonly refreshToken = os:getEnv("REFRESH_TOKEN");
configurable string & readonly clientId = os:getEnv("CLIENT_ID");
configurable string & readonly clientSecret = os:getEnv("CLIENT_SECRET");

@test:Config {}
function test() {
    ConnectionConfig config = {
        auth: {
            clientId,
            clientSecret,
            refreshUrl: "https://www.googleapis.com/oauth2/v3/token",
            refreshToken
        }
    };
    GsheetClient c = checkpanic new (config);
    Spreadsheet props = {
        properties: {
            title: "Deleted me"
        }
    };
    Spreadsheet _ = checkpanic c->createSpreadsheet(props);
}
