package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"net/http/cookiejar"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/hubert-heijkers/wow2016/hol3548/src/builder/northwind"
	"github.com/hubert-heijkers/wow2016/hol3548/src/builder/tm1"
	"github.com/joho/godotenv"
)

// Const defines
const productDimensionName = "Products"
const customerDimensionName = "Customers"
const employeeDimensionName = "Employees"
const timeDimensionName = "Time"
const measuresDimensionName = "Measures"
const ordersCubeName = "NorthWind-Orders"

// Environment variables
var datasourceServiceRootURL string
var tm1ServiceRootURL string

var client *http.Client

func executeGETRequest(urlStr string) *http.Response {
	// Create new, GET, request
	req, _ := http.NewRequest("GET", urlStr, nil)
	// We'll be expecting a JSON formatted response, set Accept header accordingly
	req.Header.Add("Accept", "application/json")
	fmt.Println(req.Method, req.URL)
	// Execute the request
	resp, err := client.Do(req)
	// If no errors then return the response
	if err != nil {
		log.Fatal(err)
	}
	return resp
}

func executePOSTRequest(urlStr, contentType, body string) *http.Response {
	// Create new, POST, request
	req, _ := http.NewRequest("POST", urlStr, strings.NewReader(body))
	req.Header.Add("Content-Type", contentType)
	// We'll be expecting a JSON formatted response, set Accept header accordingly
	req.Header.Add("Accept", "application/json")
	fmt.Println(req.Method, req.URL)
	fmt.Println(body)
	// Execute the request
	resp, err := client.Do(req)
	// If no errors then return the response
	if err != nil {
		log.Fatal(err)
	}
	return resp
}

/*
func processCollection(urlStr string, processResponse func([]byte) string) {
	// Set up the request to retrieve the collection given the passed url
	// The server however applies server side paging, as defined in the OData protocol, and therefore
	// we have to continue fetching, portions of, the collection until no more results are available.
	for nextLink := urlStr; nextLink != ""; {
		resp := executeGETRequest(datasourceServiceRootURL + nextLink)
		defer resp.Body.Close()
		body, _ := ioutil.ReadAll(resp.Body)
		fmt.Println(string(body))

		// Process the response
		nextLink = processResponse(body)
	}
}
*/
func processCollection(urlStr string, processResponse func([]byte) (int, string)) {
	// Set up the request to retrieve the collection given the passed url
	// The server however applies server side paging, as defined in the OData protocol, and therefore
	// we have to continue fetching, portions of, the collection until no more results are available.
	url := urlStr + "&$count=true&$top=10"
	nCount := 0
	nSkip := 0
	for {
		resp := executeGETRequest(datasourceServiceRootURL + url)
		defer resp.Body.Close()
		body, _ := ioutil.ReadAll(resp.Body)
		fmt.Println(string(body))

		// Process the response
		count, _ := processResponse(body)
		if nCount == 0 {
			if count == 0 {
				break
			}
			nCount = count
		}
		nSkip += 10
		if nCount <= nSkip {
			break
		}
		url = urlStr + "&$skip=" + strconv.Itoa(nSkip) + "&$top=10"
	}
}

// createDimension is the function that triggers the TM1 server to create the dimension
func createDimension(dimension *tm1.Dimension) string {
	// Create a JSON representation for the dimension
	jDimension, _ := json.Marshal(dimension)

	// POST the dimension to the TM1 server
	fmt.Println(">> Create dimension", dimension.Name)
	resp := executePOSTRequest(tm1ServiceRootURL+"Dimensions", "application/json", string(jDimension))

	// Validate that the dimension got created successfully
	if resp.StatusCode != 201 {
		defer resp.Body.Close()
		body, _ := ioutil.ReadAll(resp.Body)
		log.Fatal("Failed to create dimension '" + dimension.Name + "'. Server responded with:\r\n" + string(body))
	} else {
		resp.Body.Close()
	}

	// Secondly create an element attribute named 'Caption' of type 'string'
	fmt.Println(">> Create 'Caption' attribute for dimension", dimension.Name)
	resp = executePOSTRequest(tm1ServiceRootURL+"Dimensions('"+dimension.Name+"')/Hierarchies('"+dimension.Name+"')/ElementAttributes", "application/json", `{"Name":"Caption","Type":"String"}`)

	// Validate that the element attribute got created successfully as well
	if resp.StatusCode != 201 {
		defer resp.Body.Close()
		body, _ := ioutil.ReadAll(resp.Body)
		log.Fatal("Creating element attribute 'Caption' for dimension '" + dimension.Name + "' failed. Server responded with:\r\n" + string(body))
	} else {
		resp.Body.Close()
	}

	// Now that the caption attribute exists lets set the captions accordingly for this we'll
	// simply update the }ElementAttributes_DIMENSION cube directly, updating the default value.
	// Note: TM1 Server doesn't support passing the attribute values as part of the dimension
	// definition just yet (should shortly), so for now this is the easiest way around that
	// Alternatively one could have updated the attribute values for elements one by one by
	// POSTing to or PATCHing the LocalizedAttributes of the individual elements.
	fmt.Println(">> Set 'Caption' attribute values for elements in dimension", dimension.Name)
	resp = executePOSTRequest(tm1ServiceRootURL+"Cubes('}ElementAttributes_"+dimension.Name+"')/tm1.Update", "application/json", dimension.GetAttributesJSON())

	// Validate that the update executed successfully (by default an empty response is expected, hence the 204).
	if resp.StatusCode != 200 && resp.StatusCode != 204 {
		defer resp.Body.Close()
		body, _ := ioutil.ReadAll(resp.Body)
		log.Fatal("Setting Caption values for elements in dimension '" + dimension.Name + "' failed. Server responded with:\r\n" + string(body))
	} else {
		resp.Body.Close()
	}

	// Return the odata.id of the generated dimension
	return "Dimensions('" + dimension.Name + "')"
}

// createCube is the function that, given a set of dimension Ids and rules, requests the TM1 server to create the cube
func createCube(name string, dimensionIds []string, rules string) string {

	//cube := &tm1.CubePost{Name: name, DimensionIds: dimensionIds, Rules: rules}
	jCube, _ := json.Marshal(tm1.CubePost{Name: name, DimensionIds: dimensionIds, Rules: rules})

	// POST the dimension to the TM1 server
	fmt.Println(">> Create cube", name)
	resp := executePOSTRequest(tm1ServiceRootURL+"Cubes", "application/json", string(jCube))

	// Validate that the dimension got created successfully
	if resp.StatusCode != 201 {
		defer resp.Body.Close()
		body, _ := ioutil.ReadAll(resp.Body)
		log.Fatal("Failed to create cube '" + name + "'. Server responded with:\r\n" + string(body))
	} else {
		resp.Body.Close()
	}

	// Return the odata.id of the generated cube
	return "Cubes('" + name + "')"
}

type productDimension struct {
	dimension       *tm1.Dimension
	hierarchy       *tm1.Hierarchy
	allElement      *tm1.Element
	categoryElement *tm1.Element
}

func (d *productDimension) processResponse(responseBody []byte) (int, string) {
	// Unmarshal the JSON response
	res := northwind.CategoriesResponse{}
	err := json.Unmarshal(responseBody, &res)
	if err != nil {
		log.Fatal(err)
	}

	// Process the collection of products, by category, returned by the data source
	// PRESUMPTIONS:
	//  - NO DUPLICATE CATEGORY OR PRODUCT IDS
	//  - HOWEVER IDS ARE NOT UNIQUE ACROSS CATEGORIES AND PRODUCTS
	if d.hierarchy == nil {
		if d.dimension == nil {
			d.dimension = tm1.NewDimension(productDimensionName)
		}
		d.hierarchy = d.dimension.NewHierarchy(productDimensionName)
		d.allElement = d.hierarchy.NewElement("All", "All Products")
	}
	for _, category := range res.Categories {
		if d.categoryElement == nil || d.categoryElement.Name != "C-"+category.Name {
			d.categoryElement = d.hierarchy.NewElement("C-"+strconv.Itoa(category.ID), category.Name)
			d.hierarchy.NewEdge(d.allElement, d.categoryElement)
		}
		for _, product := range category.Products {
			d.hierarchy.NewEdge(d.categoryElement, d.hierarchy.NewElement("P-"+strconv.Itoa(product.ID), product.Name))
		}
	}

	// Return the nextLink, if there is one
	return res.Count, res.NextLink
}

// GenerateProductDimension generates, based on the data from the northwind database, the dimension definition for the products dimension
func GenerateProductDimension() *tm1.Dimension {
	dimProducts := &productDimension{}
	processCollection("Categories?$select=CategoryID,CategoryName&$orderby=CategoryName&$expand=Products($select=ProductID,ProductName;$orderby=ProductName)", dimProducts.processResponse)
	return dimProducts.dimension
}

type customerDimension struct {
	dimension      *tm1.Dimension
	hierarchy      *tm1.Hierarchy
	allElement     *tm1.Element
	countryElement *tm1.Element
	regionElement  *tm1.Element
	cityElement    *tm1.Element
}

func (d *customerDimension) processResponse(responseBody []byte) (int, string) {
	// Unmarshal the JSON response
	res := northwind.CustomersResponse{}
	err := json.Unmarshal(responseBody, &res)
	if err != nil {
		log.Fatal(err)
	}

	// Process the collection of customers returned by the data source
	// PRESUMPTIONS:
	//  - NO DUPLICATE REGION NAMES (WHICH WORKS IN THIS EXAMPLE;-)
	//  - REGIONS CAN BE EMPTY IN WHICH CASE CITIES RESIDE UNDER COUNTRY
	//  - THERE ARE HOWEVER DUPLICATE CITY NAMES SO WE PRE-EMPT THEM WITH COUNTRY (WHICH SUFFICES IN THIS EXAMPLE)
	if d.hierarchy == nil {
		if d.dimension == nil {
			d.dimension = tm1.NewDimension(customerDimensionName)
		}
		d.hierarchy = d.dimension.NewHierarchy(customerDimensionName)
		d.allElement = d.hierarchy.NewElement("All", "All Customers")
	}
	for _, customer := range res.Customers {
		if d.countryElement == nil || d.countryElement.Name != customer.Country {
			d.countryElement = d.hierarchy.NewElement(customer.Country, "")
			d.hierarchy.NewEdge(d.allElement, d.countryElement)
			if customer.Region != "" {
				d.regionElement = d.hierarchy.NewElement(customer.Region, "")
				d.hierarchy.NewEdge(d.countryElement, d.regionElement)
			} else {
				d.regionElement = nil
			}
			d.cityElement = d.hierarchy.NewElement(customer.Country+"-"+customer.City, customer.City)
			if d.regionElement != nil {
				d.hierarchy.NewEdge(d.regionElement, d.cityElement)
			} else {
				d.hierarchy.NewEdge(d.countryElement, d.cityElement)
			}
		} else if (d.regionElement == nil && customer.Region != "") || (d.regionElement != nil && d.regionElement.Name != customer.Region) {
			if customer.Region != "" {
				d.regionElement = d.hierarchy.NewElement(customer.Region, "")
				d.hierarchy.NewEdge(d.countryElement, d.regionElement)
			} else {
				d.regionElement = nil
			}
			d.cityElement = d.hierarchy.NewElement(customer.Country+"-"+customer.City, customer.City)
			if d.regionElement != nil {
				d.hierarchy.NewEdge(d.regionElement, d.cityElement)
			} else {
				d.hierarchy.NewEdge(d.countryElement, d.cityElement)
			}
		} else if d.cityElement == nil || d.cityElement.Name != customer.Country+"-"+customer.City {
			d.cityElement = d.hierarchy.NewElement(customer.Country+"-"+customer.City, customer.City)
			if d.regionElement != nil {
				d.hierarchy.NewEdge(d.regionElement, d.cityElement)
			} else {
				d.hierarchy.NewEdge(d.countryElement, d.cityElement)
			}
		}
		d.hierarchy.NewEdge(d.cityElement, d.hierarchy.NewElement(customer.ID, customer.Name))
	}

	// Return the nextLink, if there is one
	return res.Count, res.NextLink
}

// GenerateCustomerDimension generates, based on the data from the northwind database, the dimension definition for the customers dimension
func GenerateCustomerDimension() *tm1.Dimension {
	dimCustomers := &customerDimension{}
	processCollection("Customers?$orderby=Country%20asc,Region%20asc,%20City%20asc&$select=CustomerID,CompanyName,City,Region,Country", dimCustomers.processResponse)
	return dimCustomers.dimension
}

type employeeDimension struct {
	dimension      *tm1.Dimension
	hierarchy      *tm1.Hierarchy
	allElement     *tm1.Element
	countryElement *tm1.Element
	regionElement  *tm1.Element
	cityElement    *tm1.Element
}

func (d *employeeDimension) processResponse(responseBody []byte) (int, string) {
	// Unmarshal the JSON response
	res := northwind.EmployeesResponse{}
	err := json.Unmarshal(responseBody, &res)
	if err != nil {
		log.Fatal(err)
	}

	// Process the collection of employees returned by the data source
	// PRESUMPTIONS:
	//  - NO DUPLICATE REGION NAMES (WHICH WORKS IN THIS EXAMPLE;-)
	//  - REGIONS CAN BE EMPTY IN WHICH CASE CITIES RESIDE UNDER COUNTRY
	//  - THERE ARE, FORTUNATELY FOR THIS EXAMPLE, NO DUPLICATE CITY NAMES EITHER
	if d.hierarchy == nil {
		if d.dimension == nil {
			d.dimension = tm1.NewDimension(employeeDimensionName)
		}
		d.hierarchy = d.dimension.NewHierarchy(employeeDimensionName)
		d.allElement = d.hierarchy.NewElement("All", "All Employees")
	}
	for _, employee := range res.Employees {
		if d.countryElement == nil || d.countryElement.Name != employee.Country {
			d.countryElement = d.hierarchy.NewElement(employee.Country, "")
			d.hierarchy.NewEdge(d.allElement, d.countryElement)
			if employee.Region != "" {
				d.regionElement = d.hierarchy.NewElement(employee.Region, "")
				d.hierarchy.NewEdge(d.countryElement, d.regionElement)
			} else {
				d.regionElement = nil
			}
			d.cityElement = d.hierarchy.NewElement(employee.City, "")
			if d.regionElement != nil {
				d.hierarchy.NewEdge(d.regionElement, d.cityElement)
			} else {
				d.hierarchy.NewEdge(d.countryElement, d.cityElement)
			}
		} else if (d.regionElement == nil && employee.Region != "") || (d.regionElement != nil && d.regionElement.Name != employee.Region) {
			if employee.Region != "" {
				d.regionElement = d.hierarchy.NewElement(employee.Region, "")
				d.hierarchy.NewEdge(d.countryElement, d.regionElement)
			} else {
				d.regionElement = nil
			}
			d.cityElement = d.hierarchy.NewElement(employee.City, "")
			if d.regionElement != nil {
				d.hierarchy.NewEdge(d.regionElement, d.cityElement)
			} else {
				d.hierarchy.NewEdge(d.countryElement, d.cityElement)
			}
		} else if d.cityElement == nil || d.cityElement.Name != employee.City {
			d.cityElement = d.hierarchy.NewElement(employee.City, "")
			if d.regionElement != nil {
				d.hierarchy.NewEdge(d.regionElement, d.cityElement)
			} else {
				d.hierarchy.NewEdge(d.countryElement, d.cityElement)
			}
		}
		d.hierarchy.NewEdge(d.cityElement, d.hierarchy.NewElement(strconv.Itoa(employee.ID), employee.LastName+", "+employee.FirstName))
	}

	// Return the nextLink, if there is one
	return res.Count, res.NextLink
}

// GenerateEmployeeDimension generates, based on the data from the northwind database, the dimension definition for the employees dimension
func GenerateEmployeeDimension() *tm1.Dimension {
	dimEmployees := &employeeDimension{}
	processCollection("Employees?$select=EmployeeID,LastName,FirstName,TitleOfCourtesy,City,Region,Country&$orderby=Country%20asc,Region%20asc,City%20asc", dimEmployees.processResponse)
	return dimEmployees.dimension
}

// GenerateTimeDimension generates, based on the data from the northwind database, the dimension definition for the time dimension
func GenerateTimeDimension() *tm1.Dimension {

	// Grab the orderdate of the FIRST order, by order data, in the system
	resp := executeGETRequest(datasourceServiceRootURL + "Orders?$select=OrderDate&$orderby=OrderDate%20asc&$top=1")
	defer resp.Body.Close()
	responseBody, _ := ioutil.ReadAll(resp.Body)
	res := northwind.OrdersResponse{}
	err := json.Unmarshal(responseBody, &res)
	if err != nil {
		log.Fatal(err)
	}
	tmBegin := res.Orders[0].Date

	// Grab the orderdate of the LAST order, by order data, in the system
	resp = executeGETRequest(datasourceServiceRootURL + "Orders?$select=OrderDate&$orderby=OrderDate%20desc&$top=1")
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
	dimension := tm1.NewDimension(timeDimensionName)
	hierarchy := dimension.NewHierarchy(timeDimensionName)
	allElement := hierarchy.NewElement("All", "All Years")
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
			yearElement = hierarchy.NewElement(strconv.Itoa(year), "")
			hierarchy.NewEdge(allElement, yearElement)
			month = int(iTm.Month())
			quarter = (month + 2) / 3
			quarterElement = hierarchy.NewElement(fmt.Sprintf("Q%d-%04d", quarter, year), fmt.Sprintf("Q%d %04d", quarter, year))
			hierarchy.NewEdge(yearElement, quarterElement)
			monthElement = hierarchy.NewElement(fmt.Sprintf("%02d-%04d", month, year), fmt.Sprintf("%s %04d", iTm.Month().String()[:3], year))
			hierarchy.NewEdge(quarterElement, monthElement)
		} else if (int(iTm.Month())+2)/3 != quarter {
			month = int(iTm.Month())
			quarter = (month + 2) / 3
			quarterElement = hierarchy.NewElement(fmt.Sprintf("Q%d-%04d", quarter, year), fmt.Sprintf("Q%d %04d", quarter, year))
			hierarchy.NewEdge(yearElement, quarterElement)
			monthElement = hierarchy.NewElement(fmt.Sprintf("%02d-%04d", month, year), fmt.Sprintf("%s %04d", iTm.Month().String()[:3], year))
			hierarchy.NewEdge(quarterElement, monthElement)
		} else if int(iTm.Month()) != month {
			month = int(iTm.Month())
			monthElement = hierarchy.NewElement(fmt.Sprintf("%02d-%04d", month, year), fmt.Sprintf("%s %04d", iTm.Month().String()[:3], year))
			hierarchy.NewEdge(quarterElement, monthElement)
		}
		hierarchy.NewEdge(monthElement, hierarchy.NewElement(fmt.Sprintf("%02d-%02d-%04d", iTm.Day(), month, year), fmt.Sprintf("%s %s %2d %04d", iTm.Weekday().String()[:3], iTm.Month().String()[:3], iTm.Day(), year)))
	}
	return dimension
}

// GenerateMeasuresDimension generates, based on the data from the northwind database, the dimension definition for the time dimension
func GenerateMeasuresDimension() *tm1.Dimension {
	// Build the measures dimension definition which simply contains three measures: Quantity, UnitPrice and Revenue
	dimension := tm1.NewDimension(measuresDimensionName)
	hierarchy := dimension.NewHierarchy(measuresDimensionName)
	hierarchy.NewElement("Quantity", "")
	hierarchy.NewElement("UnitPrice", "Unit Price")
	hierarchy.NewElement("Revenue", "")
	return dimension
}

func processOrderData(responseBody []byte) (int, string) {
	// Unmarshal the JSON response
	res := northwind.OrdersResponse{}
	err := json.Unmarshal(responseBody, &res)
	if err != nil {
		log.Fatal(err)
	}

	// Process the collection of orders and convert to a set of cell updates
	// Note that we are using making it easy on ourselves here and not perform
	// pre-aggregation at the cell level and use a 'spreading' command to update
	// the cells to not have to retrieve the data before adding the new value to
	// it before updating the cell again.
	var jCellUpdates bytes.Buffer
	var bFirst = true
	jCellUpdates.WriteString("[")
	for _, order := range res.Orders {
		var jOrderTuple bytes.Buffer
		jOrderTuple.WriteString(`"Dimensions('`)
		jOrderTuple.WriteString(customerDimensionName)
		jOrderTuple.WriteString(`')/Hierarchies('`)
		jOrderTuple.WriteString(customerDimensionName)
		jOrderTuple.WriteString(`')/Elements('`)
		jOrderTuple.WriteString(order.CustomerID)
		jOrderTuple.WriteString(`')","Dimensions('`)
		jOrderTuple.WriteString(employeeDimensionName)
		jOrderTuple.WriteString(`')/Hierarchies('`)
		jOrderTuple.WriteString(employeeDimensionName)
		jOrderTuple.WriteString(`')/Elements('`)
		jOrderTuple.WriteString(strconv.Itoa(order.EmployeeID))
		jOrderTuple.WriteString(`')","Dimensions('`)
		jOrderTuple.WriteString(timeDimensionName)
		jOrderTuple.WriteString(`')/Hierarchies('`)
		jOrderTuple.WriteString(timeDimensionName)
		jOrderTuple.WriteString(`')/Elements('`)
		jOrderTuple.WriteString(fmt.Sprintf("%02d-%02d-%04d", order.Date.Day(), int(order.Date.Month()), order.Date.Year()))
		for _, detail := range order.Details {
			if bFirst == true {
				bFirst = false
			} else {
				jCellUpdates.WriteString(",")
			}
			// Quantity
			jCellUpdates.WriteString(`{"Slice@odata.bind":[`)
			jCellUpdates.Write(jOrderTuple.Bytes())
			jCellUpdates.WriteString(`')","Dimensions('`)
			jCellUpdates.WriteString(productDimensionName)
			jCellUpdates.WriteString(`')/Hierarchies('`)
			jCellUpdates.WriteString(productDimensionName)
			jCellUpdates.WriteString(`')/Elements('P-`)
			jCellUpdates.WriteString(strconv.Itoa(detail.ProductID))
			jCellUpdates.WriteString(`')","Dimensions('`)
			jCellUpdates.WriteString(measuresDimensionName)
			jCellUpdates.WriteString(`')/Hierarchies('`)
			jCellUpdates.WriteString(measuresDimensionName)
			jCellUpdates.WriteString(`')/Elements('Quantity')"],"Value":"+`)
			jCellUpdates.WriteString(strconv.Itoa(detail.Quantity))
			jCellUpdates.WriteString(`"},`)
			// Revenue
			jCellUpdates.WriteString(`{"Slice@odata.bind":[`)
			jCellUpdates.Write(jOrderTuple.Bytes())
			jCellUpdates.WriteString(`')","Dimensions('`)
			jCellUpdates.WriteString(productDimensionName)
			jCellUpdates.WriteString(`')/Hierarchies('`)
			jCellUpdates.WriteString(productDimensionName)
			jCellUpdates.WriteString(`')/Elements('P-`)
			jCellUpdates.WriteString(strconv.Itoa(detail.ProductID))
			jCellUpdates.WriteString(`')","Dimensions('`)
			jCellUpdates.WriteString(measuresDimensionName)
			jCellUpdates.WriteString(`')/Hierarchies('`)
			jCellUpdates.WriteString(measuresDimensionName)
			jCellUpdates.WriteString(`')/Elements('Revenue')"],"Value":"+`)
			jCellUpdates.WriteString(fmt.Sprintf("%f", float64(detail.Quantity)*detail.UnitPrice))
			jCellUpdates.WriteString(`"}`)
		}
	}
	jCellUpdates.WriteString("]")

	fmt.Println(">> Loading order data...")
	resp := executePOSTRequest(tm1ServiceRootURL+"Cubes('"+ordersCubeName+"')/tm1.Update", "application/json", jCellUpdates.String())

	// Validate that the update executed successfully (by default an empty response is expected, hence the 204).
	if resp.StatusCode != 200 && resp.StatusCode != 204 {
		defer resp.Body.Close()
		body, _ := ioutil.ReadAll(resp.Body)
		log.Fatal("Loading data into cube '" + ordersCubeName + "' failed. Server responded with:\r\n" + string(body))
	} else {
		resp.Body.Close()
	}

	// Return the nextLink, if there is one
	return res.Count, res.NextLink
}

// LoadOrderData loads, based on the data from the northwind database, the order data into our cube
func LoadOrderData() {
	processCollection("Orders?$select=CustomerID,EmployeeID,OrderDate&$expand=Order_Details($select=ProductID,UnitPrice,Quantity)", processOrderData)
}

func main() {
	// Load environment variables from .env file
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}
	datasourceServiceRootURL = os.Getenv("DATASOURCE_SERVICE_ROOT_URL")
	tm1ServiceRootURL = os.Getenv("TM1_SERVICE_ROOT_URL")

	// Create the one and only http client we'll be using, with a cookie jar enabled to keep reusing our session
	cookieJar, _ := cookiejar.New(nil)
	client = &http.Client{
		Jar: cookieJar,
	}

	// Validate that the TM1 server is accessable by requesting the version of the server
	req, _ := http.NewRequest("GET", tm1ServiceRootURL+"Configuration/ProductVersion/$value", nil)

	// Since this is our initial request we'll have to provide a user name and password, also stored in the .env file, to authenticate
	// Note: using authentication mode 1, TM1 authentication, here which maps to basic authentication in HTTP[S]
	req.SetBasicAuth(os.Getenv("TM1_USER"), os.Getenv("TM1_PASSWORD"))

	// We'll expect text back in this case but we'll simply dump the content out and won't do any content type verification here
	req.Header.Add("Accept", "*/*")

	// Let's execute the request
	resp, err := client.Do(req)
	if err != nil {
		// Execution of the request failed, log the error and terminate
		log.Fatal(err)
	}

	// The body simply contains the version number of the server
	version, _ := ioutil.ReadAll(resp.Body)
	resp.Body.Close()

	// which we'll simply dump to the console
	fmt.Println("Using TM1 Server version", string(version))

	// Note that as a result of this request a TM1SessionId cookie was added to the cookie jar which will automatically be
	// reused on subsequent requests to our TM1 server, and therefore don't need to send the credentials over and over again.

	// Now let's build some Dimensions
	// The definition of the dimension is based on data in the northwind database, a data source hosted on
	// odata.org which, as one might have already gathered, can be queried using an OData compliant REST API.
	var dimensionIds [5]string
	dimensionIds[0] = createDimension(GenerateProductDimension())
	dimensionIds[1] = createDimension(GenerateCustomerDimension())
	dimensionIds[2] = createDimension(GenerateEmployeeDimension())
	dimensionIds[3] = createDimension(GenerateTimeDimension())
	dimensionIds[4] = createDimension(GenerateMeasuresDimension())
	/*
		dimensionIds[0] = "Dimensions('Products')"
		dimensionIds[1] = "Dimensions('Customers')"
		dimensionIds[2] = "Dimensions('Employees')"
		dimensionIds[3] = "Dimensions('Time')"
		dimensionIds[4] = "Dimensions('Measures')"
	*/

	// Now that we have all our dimensions, let's create cube
	createCube(ordersCubeName, dimensionIds[:], "UNDEFVALS;\nSKIPCHECK;\n\n['UnitPrice']=['Revenue']\\['Quantity'];\n\nFEEDERS;\n['Quantity']=>['UnitPrice'];")

	// Load the data in the cube
	LoadOrderData()

	// And we are done!
	fmt.Println(">> Done! Dimensions created, Cube created and Data loaded successfully!")
}
