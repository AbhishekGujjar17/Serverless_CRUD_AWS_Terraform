# imports
import json
import boto3

# logger
import logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# table creation
dynamoDbTableName = 'users-table-demo'
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(dynamoDbTableName)

# methods
getMethod = 'GET'
postMethod = 'POST'
patchMethod = 'PATCH'
deleteMethod = 'DELETE'

# paths
health = '/health'
user = '/user'
users = '/users'

# lambda function for api endpoints

def lambda_handler(event, context):

    logger.info(event)
    httpMethod = event['httpMethod']
    path = event['path']

    if httpMethod == getMethod and path == health:
        response = buildResponse(200,{'Message':'Success'})

    elif httpMethod == getMethod and path == user:
        response = getUser(event['queryStringParameters']['userId'])

    elif httpMethod == getMethod and path == users:
        response = getUsers()

    elif httpMethod == postMethod and path == user:
        response = addUser(json.loads(event['body']))

    elif httpMethod == patchMethod and path == user:
        requestBody = json.loads(event['body'])
        response = updateUser(
            requestBody['userId'], requestBody['updatekey'], requestBody['updateValue'])

    elif httpMethod == deleteMethod and path == user:
        requestBody = json.loads(event['body'])
        response = deleteUser(requestBody['userId'])

    else:
        response = buildResponse(404, 'Not Found')

    return response


def getUser(userId):

    try:
        response = table.get_item(
            Key={'userId': userId}
        )

        if 'Item' in response:
            return buildResponse(200, response['Item'])
        else:
            return buildResponse(404, {'Message': 'UserId: %s not found' % userId})

    except:
        logger.exception('Logging the error here for now')


def getUsers():

    try:

        response = table.scan()
        users = response['Items']
        while 'LastEvaluatedKey' in response:
            response = table.scan(
                ExclusiveStartKey=response['LastEvaluatedKey'])
            users.extend(response['Items'])

        body = {
            'users': users
        }
        return buildResponse(200, body)

    except:
        logger.exception('Logging the error here for now')


def deleteUser(userId):

    try:

        response = table.delete_item(
            Key={'userId': userId},

            ReturnValues='ALL_OLD'
        )

        body = {

            'Operation': 'Delete',
            'Message': 'Success',
            'deletedItem': response
        }

        return buildResponse(200, body)

    except:
        logger.exception('Logging the error here for now')


def addUser(userInfo):

    try:
        response = table.put_item(Item=userInfo)
        body = {
            'Operation': 'POST',
            'Message': 'Success',
            'addedItem': response
        }

        return buildResponse(200, body)

    except:
        logger.exception('Logging the error here for now')


def updateUser(userId, updateKey, updateValue):

    try:

        response = table.update_item(Key={
            'userId': userId
        },

            UpdateExpression='set %s = :value' % updateKey,
            ExpressionAttributeValues={
            ':value': updateValue},
            ReturnValues='UPDATED_NEW')

        body = {
            'Operation': 'PATCH',
            'Message': 'SUCCESS',
            'UpdatedAttribute': response
        }
        return buildResponse(200, body)

    except:
        logger.exception('Logging the error here for now')


def buildResponse(statusCode, body=None):

    response = {
        'statusCode': statusCode,
        'headers': {
            'ContentType': 'application/json',
            'Access-Control-Allow-Origin': '*'
        }
    }

    if body is not None:
        response['body'] = json.dumps(body)
    return response
