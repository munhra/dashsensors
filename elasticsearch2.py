##
# Author: Andre Tsuyoshi Sakiyama
# Create date: 12 Sep 2017
# Description: Query data from AWS elastic search iot_fti2
##
from elasticsearch import Elasticsearch
import json
import threading

pageSize = 10000

def buildBody(field, sortingFeature, orderType, startTimestamp, endTimestamp):
	startPosition = 0

	body = {
	    "sort": [
	        {sortingFeature: {"order": orderType}}
	    ],
	    "size": pageSize,
	    "from": startPosition,
	    "query": {
	        "filtered": {
	            "filter": {
	                "bool": {
	                    "must": [{
	                        "exists": {
	                           "field": field
	                        }
	                    },
	                    {
	                        "range": {
	                            "datetime_idx": {
	                                "gte": startTimestamp,
	                                "lte": endTimestamp
	                            }
	                        }
	                    }]
	                }
	            }
	        }
	    }
	}

	return body


def parseData(data, field):
	currentPageData = {}
	currentPageData[field] = []
	currentPageData['datetime'] = []

	for f in data['hits']['hits']:
		currentPageData[field].append(f['_source'][field])
		currentPageData['datetime'].append(f['_source']['datetime'])

	return currentPageData


def requestThread(body, es, field):
	res = es.search(body=body)

	return parseData(res, field)


def makeRequest(body, field):
	es  = Elasticsearch("https://search-fti-es-szgjq3dzpsev2nkngqfamoegiu.us-west-2.es.amazonaws.com/iot_fti2")

	pageSize = body['size']
	firstElementPosition = body['from']

	res = es.search(body=body)

	total = res['hits']['total']

	threads = []
	partialData = []

	t = threading.Thread(target = partialData.append(parseData(res, field)))
	t.start()
	threads.append(t)

	if total > pageSize:
		nThreads = math.ceil((total - pageSize) / pageSize)
		threads = []

		for i in range(int(nThreads)):
			body['from'] = (i + 1) * pageSize
			t = threading.Thread(target = partialData.append(requestThread(body, es, field)))
			t.start()
			threads.append(t)


	for thread in threads:
		thread.join()

	partialData.sort(key = lambda x: x['datetime'])

	data = {}
	data[field] = []
	data['datetime'] = []

	for pData in partialData:
		data[field].extend(pData[field])
		data['datetime'].extend(pData['datetime'])

	return data

##
# Reuturn all data from requested field, within a given time frame, and all corresponding date time
# @param {string} field 			Field requested
# @param {string} sortingFeature 	Sorting feature
# @param {string} sortingType 		Sorting type: Ascendent(asc), Descendent(desc)
# @param {string} startTimestamp 	Starting timestamp in epoch milliseconds
# @param {string} endTimestamp 		End timestamp in epoch milliseconds
##
def queryData(field = "temperature", sortingFeature = "datetime_idx", orderType = "asc", startTimestamp = "1506444940000", endTimestamp = "1506532234001"):
	body = buildBody(field, sortingFeature, orderType, startTimestamp, endTimestamp)
	data = makeRequest(body, field)
	dataJSON = json.dumps(data)

	return dataJSON


if __name__ == "__main__":
	data = queryData()
	print(data)
