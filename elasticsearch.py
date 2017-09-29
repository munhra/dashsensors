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

def makeRequest(body, field):
	es  = Elasticsearch("https://search-fti-es-szgjq3dzpsev2nkngqfamoegiu.us-west-2.es.amazonaws.com/iot_fti2")

	pageSize = body['size']
	firstElementPosition = body['from']

	res = es.search(body=body)

	total = res['hits']['total']

	if firstElementPosition + pageSize < total:
		body['from'] = firstElementPosition + pageSize
		partialData = makeRequest(body, field)
	else:
		partialData = {}
		partialData[field] = []
		partialData['datetime'] = []

	currentPageData = {}
	currentPageData[field] = []
	currentPageData['datetime'] = []

	for f in res['hits']['hits']:
		currentPageData[field].append(f['_source'][field])
		currentPageData['datetime'].append(f['_source']['datetime'])

	currentPageData[field].extend(partialData[field])
	currentPageData['datetime'].extend(partialData['datetime'])

	return currentPageData


##
# Reuturn all data from requested field, within a given time frame, and all corresponding date time
# @param {string} field 			Field requested
# @param {string} sortingFeature 	Sorting feature
# @param {string} sortingType 		Sorting type: Ascendent(asc), Descendent(desc)
# @param {string} startTimestamp 	Starting timestamp in epoch milliseconds
# @param {string} endTimestamp 		End timestamp in epoch milliseconds
##
def queryData(field = "dust", sortingFeature = "datetime_idx", orderType = "asc", startTimestamp = "1491004800000", endTimestamp = "1499177600000"):
	body = buildBody(field, sortingFeature, orderType, startTimestamp, endTimestamp)
	data = makeRequest(body, field)
	dataJSON = json.dumps(data)

	return dataJSON


if __name__ == "__main__":
	data = queryData()
	# print(data)
