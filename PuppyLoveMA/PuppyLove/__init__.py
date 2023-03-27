import logging
import math
import azure.functions as func
from geopy import distance


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    userA = req.params.get('userAge')
    userAR = req.params.get('userAgeRng')
    userGender = req.params.get('userGender')
    userSG = req.params.get('userShowGender')
    userLL = req.params.get('userLatLong')
    userAL = req.params.get('userActLvl')
    userW = req.params.get('userWeight')
    userBreed = req.params.get('userBreed')
    userIB = req.params.get('userIB')
    userD = req.params.get('userDist')

    matchA = req.params.get('matchAge')
    matchAR = req.params.get('matchAgeRng')
    matchGender = req.params.get('matchGender')
    matchSG = req.params.get('matchShowGender')
    matchLL = req.params.get('matchLatLong')
    matchAL = req.params.get('matchActLvl')
    matchW = req.params.get('matchWeight')
    matchBreed = req.params.get('matchBreed')
    matchIB = req.params.get('matchIB')
    matchD = req.params.get('matchDist')

    userAge = int(userA)
    userAgeRange = [int(x) for x in userAR.split(',')]
    userShowGender = userSG.split(',')
    userLatLong = [float(x) for x in userLL.split(',')]
    userActLvl = int(userAL)
    userWeight = int(userW)
    userIgnoreBreed = userIB.split(',')
    userDist = int(userD)

    matchAge = int(matchA)
    matchAgeRange = [int(x) for x in matchAR.split(',')]
    matchShowGender = matchSG.split(',')
    matchLatLong = [float(x) for x in matchLL.split(",")]
    matchActLvl = int(matchAL)
    matchWeight = int(matchW)
    matchIgnoreBreed = matchIB.split(',')
    matchDist = int(matchD)

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

    for breed in matchIgnoreBreed:
        if userBreed == breed:
            return func.HttpResponse(f"Compatability score: {0}")
    for breed in userIgnoreBreed:
        if matchBreed == breed:
            return func.HttpResponse(f"Compatability score: {0}")

    if matchAge < userAgeRange[0] or matchAge > userAgeRange[1]:
        return func.HttpResponse(f"Compatability score: {0}")
    if userAge < matchAgeRange[0] or userAge > matchAgeRange[1]:
        return func.HttpResponse(f"Compatability score: {0}")

    foundM = False
    for gender in matchShowGender:
        if userGender == gender:
            foundM = True
            break
    if not foundM:
        return func.HttpResponse(f"Compatability score: {0}")

    foundU = False
    for gender in matchShowGender:
        if userGender == gender:
            foundU = True
            break
    if not foundU:
        return func.HttpResponse(f"Compatability score: {0}")

    distance_2d = distance.distance(userLatLong, matchLatLong).miles
    if distance_2d > matchDist or distance_2d > userDist:
        return func.HttpResponse(f"Compatability score: {0}")
    distCom = 20 + pow(-1 * distance_2d, 5)/10000
    if (distCom < 0):
        distCom = 0
    weightCom = (40 * (1-pow(abs(math.log(userWeight, 3) -
                 math.log(matchWeight, 3))/((math.log(userWeight, 3))), 0.8)))
    actCom = (40 * (1-pow(abs(math.log(userActLvl+1, 2) -
              math.log(matchActLvl+1, 2))/((math.log(userActLvl+1, 2))), 1.25)))

    if (weightCom < 1):
        actCom = 0

    if (actCom < 1):
        actCom = 0
    com = weightCom + actCom + distCom

    return func.HttpResponse(f"Compatability score: {com}")
