package processes

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"strconv"
	"time"

	"github.com/hubert-heijkers/wow2016/hol3548/src/builder/helpers/odata"
	"github.com/hubert-heijkers/wow2016/hol3548/src/builder/northwind"
	"github.com/hubert-heijkers/wow2016/hol3548/src/builder/tm1"
)

// GenerateTimeDimension generates, based on the data from the northwind database, the dimension definition for the time dimension
func GenerateTimeDimension(client *odata.Client, datasourceServiceRootURL string, name string) *tm1.Dimension {

	// Grab the orderdate of the FIRST order, by order data, in the system
	resp := client.ExecuteGETRequest(datasourceServiceRootURL + "Orders?$select=OrderDate&$orderby=OrderDate%20asc&$top=1")
	defer resp.Body.Close()
	responseBody, _ := ioutil.ReadAll(resp.Body)
	res := northwind.OrdersResponse{}
	err := json.Unmarshal(responseBody, &res)
	if err != nil {
		log.Fatal(err)
	}
	tmBegin := res.Orders[0].Date

	// Grab the orderdate of the LAST order, by order data, in the system
	resp = client.ExecuteGETRequest(datasourceServiceRootURL + "Orders?$select=OrderDate&$orderby=OrderDate%20desc&$top=1")
	defer resp.Body.Close()
	responseBody, _ = ioutil.ReadAll(resp.Body)
	res = northwind.OrdersResponse{}
	err = json.Unmarshal(responseBody, &res)
	if err != nil {
		log.Fatal(err)
	}
	tmEnd := res.Orders[0].Date

	// Show the order date range we are going to use to create the time dimension
	fmt.Println("Order date range:", tmBegin.Format(time.ANSIC), "-", tmEnd.Format(time.ANSIC))

	// Build the dimension definition
	dimension := tm1.CreateDimension(name)
	hierarchy := dimension.AddHierarchy(name)
	allElement := hierarchy.AddElement("All", "All Years")
	year := tmBegin.Year() - 1
	var month int
	var quarter int
	var yearElement *tm1.Element
	var quarterElement *tm1.Element
	var monthElement *tm1.Element
	// Create elements for every day in the range from the first till last day we have data for
	for iTm := tmBegin; iTm.After(tmEnd) == false; iTm = iTm.AddDate(0, 0, 1) {
		if iTm.Year() != year {
			year = iTm.Year()
			yearElement = hierarchy.AddElement(strconv.Itoa(year), "")
			hierarchy.AddEdge(allElement, yearElement)
			month = int(iTm.Month())
			quarter = (month + 2) / 3
			quarterElement = hierarchy.AddElement(fmt.Sprintf("Q%d-%04d", quarter, year), fmt.Sprintf("Q%d %04d", quarter, year))
			hierarchy.AddEdge(yearElement, quarterElement)
			monthElement = hierarchy.AddElement(fmt.Sprintf("%02d-%04d", month, year), fmt.Sprintf("%s %04d", iTm.Month().String()[:3], year))
			hierarchy.AddEdge(quarterElement, monthElement)
		} else if (int(iTm.Month())+2)/3 != quarter {
			month = int(iTm.Month())
			quarter = (month + 2) / 3
			quarterElement = hierarchy.AddElement(fmt.Sprintf("Q%d-%04d", quarter, year), fmt.Sprintf("Q%d %04d", quarter, year))
			hierarchy.AddEdge(yearElement, quarterElement)
			monthElement = hierarchy.AddElement(fmt.Sprintf("%02d-%04d", month, year), fmt.Sprintf("%s %04d", iTm.Month().String()[:3], year))
			hierarchy.AddEdge(quarterElement, monthElement)
		} else if int(iTm.Month()) != month {
			month = int(iTm.Month())
			monthElement = hierarchy.AddElement(fmt.Sprintf("%02d-%04d", month, year), fmt.Sprintf("%s %04d", iTm.Month().String()[:3], year))
			hierarchy.AddEdge(quarterElement, monthElement)
		}
		hierarchy.AddEdge(monthElement, hierarchy.AddElement(fmt.Sprintf("%02d-%02d-%04d", iTm.Day(), month, year), fmt.Sprintf("%s %s %2d %04d", iTm.Weekday().String()[:3], iTm.Month().String()[:3], iTm.Day(), year)))
	}
	return dimension
}
