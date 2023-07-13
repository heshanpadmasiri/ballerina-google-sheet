import ballerina/os;

public function main() {
    string refreshToken = os:getEnv("REFRESH_TOKEN");
    string clientId = os:getEnv("CLIENT_ID");
    string clientSecret = os:getEnv("CLIENT_SECRET");

    ConnectionConfig config = {
        auth: {
            clientId,
            clientSecret,
            refreshUrl: "https://www.googleapis.com/oauth2/v3/token",
            refreshToken
        }
    };
    Client _ = checkpanic new (config);
}
