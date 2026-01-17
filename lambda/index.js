// Import AWS SDK v3 clients using CommonJS require
const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const {
  DynamoDBDocumentClient,
  UpdateCommand,
} = require("@aws-sdk/lib-dynamodb");

// Create a DynamoDB client (region must match your table)
const client = new DynamoDBClient({ region: "us-east-1" });
const ddbDocClient = DynamoDBDocumentClient.from(client);

// Lambda handler function
exports.handler = async (event) => {
  // Allowed origins for CORS (production + localhost for dev)
  const allowedOrigins = [
    "https://visitcounter.foo",
    "http://127.0.0.1:5500",
  ];

  // Extract origin from request headers
  const origin = event.headers?.origin;
  // Use origin if allowed, otherwise default to production domain
  const allowOrigin = allowedOrigins.includes(origin)
    ? origin
    : allowedOrigins[0];

  // Handle CORS preflight OPTIONS request
  if (event.requestContext?.http?.method === "OPTIONS") {
    return {
      statusCode: 200,
      headers: {
        "Access-Control-Allow-Origin": allowOrigin,
        "Access-Control-Allow-Methods": "OPTIONS,GET,POST",
        "Access-Control-Allow-Headers": "Content-Type",
      },
      body: "", // No body needed for preflight
    };
  }

  try {
    // Parameters for updating the counter in DynamoDB
    const params = {
      TableName: "visitcounter-db-table", // DynamoDB table name
      Key: { id: "counter" }, // Primary key of the item
      UpdateExpression: "SET visit = if_not_exists(visit, :start) + :inc",
      ExpressionAttributeValues: {
        ":inc": 1, // Increment by 1
        ":start": 0, // If 'visit' doesn't exist yet, start at 0
      },
      ReturnValues: "UPDATED_NEW", // Return the new value after update
    };

    // Send the update command to DynamoDB
    const response = await ddbDocClient.send(new UpdateCommand(params));

    // Get the updated counter value
    const count = response.Attributes.visit;

    // Return the result to the caller with proper CORS headers
    return {
      statusCode: 200,
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": allowOrigin,
        "Access-Control-Allow-Methods": "OPTIONS,GET,POST",
        "Access-Control-Allow-Headers": "Content-Type",
      },
      body: JSON.stringify({ visitCount: count }),
    };
  } catch (error) {
    console.error("Error updating counter:", error);

    // Return error response with CORS headers
    return {
      statusCode: 500,
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": allowOrigin,
      },
      body: JSON.stringify({ error: error.message }),
    };
  }
};
