import logging
import math
import azure.functions as func
from geopy import distance
import requests
import json

def main(req: func.HttpRequest) -> func.HttpResponse:
    
    
    logging.info('Python HTTP trigger function processed a request.')

    userEmail = req.params.get('userEmail')
    matchEmail = req.params.get('matchEmail')
    #print(userEmail)
    #print(matchEmail)
    urlUser = "https://puppyloveapi.azurewebsites.net/MatchingInfo/" + userEmail
    urlMatch = "https://puppyloveapi.azurewebsites.net/MatchingInfo/" + matchEmail

    responseUser = requests.request("GET", urlUser)
    responseMatch = requests.request("GET", urlMatch)

    userJson = json.loads(responseUser.text)
    matchJson = json.loads(responseMatch.text)
    #print(userJson)
    #print(matchJson)

    userAge = int(userJson['Age'])
    userAgeRange = [int(userJson['MinAge']),int(userJson['MaxAge'])]
    userActLvl = int(userJson['ActivityLevel'])
    userWeight = int(userJson['Weight'])
    userGender = userJson['Sex']
    userShowG = userJson['SexPreference']

    matchAge = int(matchJson['Age'])
    matchAgeRange = [int(matchJson['MinAge']),int(matchJson['MaxAge'])]
    matchActLvl = int(matchJson['ActivityLevel'])
    matchWeight = int(matchJson['Weight'])
    matchGender = matchJson['Sex']
    matchShowG = matchJson['SexPreference']

    if userActLvl == 0:
      userActLvl = 1
    if matchActLvl == 0:
      matchActLvl = 1
    if userWeight == 0:
        userWeight = 2
    if matchWeight == 0:
        matchWeight = 2

    # print("user")
    # print(userAge)
    # print(userAgeRange)
    # print(userGender)
    # print(userShowGender)
    # print(userLatLong)
    # print(userActLvl)
    # print(userWeight)
    # print(userBreed)
    # print(userIgnoreBreed)
    # print(' ')
    # print(' ')
    # print("match")
    # print(matchAge)
    # print(matchAgeRange)
    # print(matchGender)
    # print(matchShowGender)
    # print(matchLatLong)
    # print(matchActLvl)
    # print(matchWeight)
    # print(matchBreed)
    # print(matchIgnoreBreed)
    # print(' ')

    #for breed in matchIgnoreBreed:
    #    if userBreed == breed:
    #        return func.HttpResponse(f"Compatability score: {0}")
    #for breed in userIgnoreBreed:
    #    if matchBreed == breed:
    #        return func.HttpResponse(f"Compatability score: {0}")

    if matchAge < userAgeRange[0] or matchAge > userAgeRange[1]:
         return func.HttpResponse(f"Compatability score: {0}")
    if userAge < matchAgeRange[0] or userAge > matchAgeRange[1]:
         return func.HttpResponse(f"Compatability score: {0}")

    # foundM = False
    # for gender in matchShowGender:
    #     if userGender == gender:
    #         foundM = True
    #         break
    # if not foundM:
    #     return func.HttpResponse(f"Compatability score: {0}")

    # foundU = False
    # for gender in userShowGender:
    #     if matchGender == gender:
    #         foundU = True
    #         break
    # if not foundU:
    #     return func.HttpResponse(f"Compatability score: {0}")

    # distance_2d = distance.distance(userLatLong, matchLatLong).miles
    # if distance_2d > matchDist or distance_2d > userDist:
    #     return func.HttpResponse(f"Compatability score: {0}")
    # distCom = 20 + pow(-1 * distance_2d, 5)/10000
    # if (distCom < 0):
    #     distCom = 0
    weightCom = (40 * (1-pow(abs(math.log(userWeight, 3) -
        math.log(matchWeight, 3))/((math.log(userWeight, 3))), 0.8)))
    actCom = (40 * (1-pow(abs(math.log(userActLvl+1, 2) -
        math.log(matchActLvl+1, 2))/((math.log(userActLvl+1, 2))), 1.25)))

    if (weightCom < 1):
       actCom = 0

    if (actCom < 1):
        actCom = 0
    distCom = 10
    com = weightCom + actCom + distCom
    #com = 0

    return func.HttpResponse(f"{com}")
